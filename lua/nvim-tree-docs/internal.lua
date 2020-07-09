local locals = require "nvim-treesitter.locals"
local queries = require "nvim-treesitter.query"
local ts_utils = require "nvim-treesitter.ts_utils"
local templates = require "nvim-tree-docs.template"
local Collector = require "nvim-tree-docs.collector"
local api = vim.api

local M = {}

local function get_node_id(node)
  local start_row, start_col, end_row, end_column = node:range()

  return string.format([[%d_%d_%d_%d]], start_row, start_col, end_row, end_column)
end

function M.doc_node_at_cursor()
  local doc_data, node = M.get_docs_at_cursor()

  if not doc_data or not node then return end

  local doc_tbl = templates.execute_template(doc_data)


  if not doc_tbl then return end

  local node_start_row, _, _ = node:start()

  -- TODO: Handle indentation here... should be easy if we have the nodes start column

  api.nvim_buf_set_lines(0, node_start_row, node_start_row, false, doc_tbl)
end

function M.get_docs_at_cursor()
  local node = ts_utils.get_node_at_cursor()

  if node then
    return M.get_doc_data_for_node(node), node
  end

  return nil, nil
end

function M.get_doc_data_for_node(node, bufnr)
  local doc_data = M.collect_docs(bufnr)
  local node_start_row, node_start_col, _ = node:start()

  for _, def in pairs(doc_data) do
    local def_start_row, def_start_col, _ = def.definition.node:start()

    if def_start_row == node_start_row and node_start_col >= def_start_col then
      return def
    end
  end

  return nil
end

function M.collect_docs(bufnr)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local result = Collector:new()
  local locals = locals.get_locals(bufnr, 'docs')

  -- TODO: Clean this up and abstract it...
  -- TODO: Cache this logic

  for _, match in ipairs(locals) do
    if match['function'] then
      -- TODO: add type data
      result:add(match['function'], {
        type = 'function',
        list_keys = { 'parameters' },
        extract_keys = { 'name', 'parameters', 'return' }
      })
    elseif match.variable then
      result:add(match.variable, {
        type = 'variable',
        extract_keys = { 'name', 'var_type', 'initial_value' }
      })
    end
  end

  -- print(vim.inspect(result))

  -- TODO: sort parameters by node range here

  return result
end

function M.attach(bufnr, lang)
end

function M.detach(bufnr)
end

return M
