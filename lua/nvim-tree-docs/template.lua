local api = vim.api

local M = {}

function M.get_template(bufnr, ft)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local ft = ft or api.nvim_buf_get_option(bufnr, 'ft')

  local successful, template = pcall(function()
    return require(string.format("nvim-tree-docs.templates.%s", ft))
  end)

  return successful and template or nil
end

return M
