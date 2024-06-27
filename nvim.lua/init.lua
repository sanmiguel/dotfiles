local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup("plugins")

vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.title = true
-- "${branchname} | ${pwd}"
-- TODO: FugitiveHead() like this gets weird if focused on e.g. help page
vim.o.titlestring = "%{FugitiveHead()} | %{substitute(getcwd(), $HOME, '~', '')}"

vim.opt.diffopt:append("vertical")
vim.opt.clipboard:append("unnamed")

-- TODO Move tmp/swap files to a globally-ignored local dir in projects
-- to avoid swap clash between e.g. ~/review/valified and ~/git/valified/valified

-- TODO Move this to plugins/lspconfig
-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
-- you may set those key mappings based on your own preference
local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

-- setting up the elixir language server
-- you have to manually specify the entrypoint cmd for elixir-ls
require('lspconfig').elixirls.setup {
  cmd = { "/Users/sanmiguel/git/elixir-lsp/elixir-ls/release/language_server.sh" },
  on_attach = on_attach
}

-- require("neotest").setup({
--     adapters = {
--         require("neotest-elixir"){
--         }
--     }
-- })

-- require("neodev").setup({
--     library = { plugins = { "neotest" }, types = true },
-- })

-- things in here almost certainly rely on things setup above
require("keys")
if (vim.fn.exists("g:neovide"))
then
	require('neovide')
end

-- If no args were given, default to opening the find_files dialog
-- TODO FIXME Need to validate no session is being restored
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" then
      require("telescope.builtin").find_files()
    end
  end,
})

-- TODO: local map this in qflist windows 
-- TODO: a periodic watcher to show any rpc requests pending for LSP
--       • {requests} (table): The current pending requests in flight to the
        -- server. Entries are key-value pairs with the key being the request ID
        -- while the value is a table with `type`, `bufnr`, and `method`
        -- key-value pairs. `type` is either "pending" for an active request, or
        -- "cancel" for a cancel request.
-- clients are vim.lsp.get_active_clients() or vim.lsp.get_client_by_id()
-- Filter by req.type == "pending"
--
-- TODO investigate if client.rpc.notify is a callback we can wrap to hook

