local M = {}

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function entry_maker(call)
  local item = call.from or call.to
  local filename = vim.uri_to_fname(item.uri)
  local lnum = item.range.start.line + 1
  local col = item.range.start.character + 1
  return {
    value = call,
    display = string.format('%s  %s:%d', item.name, vim.fn.fnamemodify(filename, ':.'), lnum),
    ordinal = item.name .. ' ' .. filename,
    filename = filename,
    lnum = lnum,
    col = col,
  }
end

local function pick(title, results)
  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table({ results = results, entry_maker = entry_maker }),
    sorter = conf.generic_sorter({}),
    previewer = conf.qflist_previewer({}),
    attach_mappings = function(_, _)
      actions.select_default:replace(function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd.edit(entry.filename)
        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
      end)
      return true
    end,
  }):find()
end

local function run(direction)
  local method = direction == 'incoming'
    and 'callHierarchy/incomingCalls'
    or 'callHierarchy/outgoingCalls'

  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  vim.lsp.buf_request(0, 'textDocument/prepareCallHierarchy', params, function(err, items)
    if err or not items or #items == 0 then
      vim.notify('No call hierarchy item at cursor', vim.log.levels.INFO)
      return
    end
    vim.lsp.buf_request(0, method, { item = items[1] }, function(err2, calls)
      if err2 or not calls or #calls == 0 then
        vim.notify('No ' .. direction .. ' calls for ' .. items[1].name, vim.log.levels.INFO)
        return
      end
      pick(direction .. ' calls: ' .. items[1].name, calls)
    end)
  end)
end

M.incoming = function() run('incoming') end
M.outgoing = function() run('outgoing') end

return M
