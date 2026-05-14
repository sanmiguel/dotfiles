--- Custom MCP tool: set the quickfix list with file:line entries.

local schema = {
  description = "Set the quickfix list in the editor with a list of file locations",
  inputSchema = {
    type = "object",
    properties = {
      items = {
        type = "array",
        description = "Array of location entries to populate the quickfix list",
        items = {
          type = "object",
          properties = {
            filename = {
              type = "string",
              description = "Absolute path to the file",
            },
            lnum = {
              type = "integer",
              description = "Line number (1-indexed)",
            },
            col = {
              type = "integer",
              description = "Column number (1-indexed)",
            },
            text = {
              type = "string",
              description = "Description text for this entry",
            },
            type = {
              type = "string",
              description = "Entry type: E (error), W (warning), I (info), N (note), or empty",
            },
          },
          required = { "filename", "lnum" },
        },
      },
      title = {
        type = "string",
        description = "Title for the quickfix list window",
      },
    },
    required = { "items" },
    additionalProperties = false,
    ["$schema"] = "http://json-schema.org/draft-07/schema#",
  },
}

local function handler(params)
  if not params.items or type(params.items) ~= "table" or #params.items == 0 then
    error({
      code = -32602,
      message = "Invalid params",
      data = "items must be a non-empty array",
    })
  end

  local qf_items = {}
  for _, item in ipairs(params.items) do
    if not item.filename or not item.lnum then
      error({
        code = -32602,
        message = "Invalid params",
        data = "Each item must have filename and lnum",
      })
    end
    table.insert(qf_items, {
      filename = item.filename,
      lnum = item.lnum,
      col = item.col or 0,
      text = item.text or "",
      type = item.type or "",
    })
  end

  local what = { items = qf_items }
  if params.title then
    what.title = params.title
  end

  vim.fn.setqflist({}, " ", what)
  vim.cmd("copen")

  return {
    content = {
      {
        type = "text",
        text = vim.json.encode({
          success = true,
          count = #qf_items,
          message = "Quickfix list set with " .. #qf_items .. " entries",
        }),
      },
    },
  }
end

return {
  name = "setQuickfixList",
  schema = schema,
  handler = handler,
}
