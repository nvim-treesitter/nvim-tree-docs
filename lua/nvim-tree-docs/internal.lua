local locals = require "nvim-treesitter.locals"
local configs = require "nvim-treesitter.configs"
local queries = require "nvim-treesitter.query"
local ts_utils = require "nvim-treesitter.ts_utils"
local templates = require "nvim-tree-docs.template"
local Collector = require "nvim-tree-docs.collector"
local api = vim.api

local M = {}

M.doc_cache = {}

local function indent_lines(lines, count)
  if not count or count == 0 then return lines end

  local result = {}

  for _, line in ipairs(lines) do
    table.insert(result, string.rep(' ', count) .. line)
  end

  return result
end

function M.doc_node_at_cursor()
  local doc_data, node = M.get_docs_at_cursor()

  if not doc_data or not node then return end

  local doc_lines = templates.execute_template(doc_data)

  if not doc_lines then return end

  local node_start_row, node_start_col, _ = doc_data.definition.node:start()

  api.nvim_buf_set_lines(
    0,
    node_start_row,
    node_start_row,
    false,
    indent_lines(doc_lines, node_start_col))
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

  for _, def in pairs(doc_data:get_items()) do
    local def_start_row, def_start_col, _ = def.definition.node:start()

    if def_start_row == node_start_row and node_start_col >= def_start_col then
      return def
    end
  end

  return nil
end

function M.collect_docs(bufnr)
  local bufnr = bufnr or api.nvim_get_current_buf()

  if M.doc_cache[bufnr] and M.doc_cache[bufnr].tick == api.nvim_buf_get_changedtick(bufnr) then
    return M.doc_cache[bufnr].docs
  end

  -- TODO: Cache this logic
  local collector = Collector.new {
    ['function'] = {
      keys = {
        'name',
        'return',
        'doc',
        { key = 'parameters', is_list = true },
      }
    },
    variable = {
      keys = { 'name', 'var_type', 'initial_value', 'doc' }
    },
    method = {
      keys = {
        'name',
        'return',
        'doc',
        'class',
        { key = 'parameters', is_list = true },
      }
    },
    class = {
      keys = {
        'name',
        { key = 'extensions', is_list = true },
        { key = 'implementations', is_list = true }
      }
    }
  }

  collector:collect_all(locals.get_locals(bufnr, 'docs'))

  M.doc_cache[bufnr] = {
    tick = api.nvim_buf_get_changedtick(bufnr),
    docs = collector
  }

  return collector
end

function M.attach(bufnr)
  local buf = bufnr or api.nvim_get_current_buf()
  local config = configs.get_module('tree_docs')

  for fn, mapping in pairs(config.keymaps) do
    local cmd = string.format(":lua require 'nvim-tree-docs.internal'.%s()<CR>", fn)
    api.nvim_buf_set_keymap(bufnr, 'n', mapping, cmd, { silent = true })
  end
end

function M.detach(bufnr)
  local buf = bufnr or api.nvim_get_current_buf()

  local config = configs.get_module('tree_docs')
  for _, mapping in pairs(config.keymaps) do
    api.nvim_buf_del_keymap(buf, 'n', mapping)
  end
end

return M
