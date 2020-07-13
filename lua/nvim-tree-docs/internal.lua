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

local function get_start_node(entry)
  return entry.start_point and entry.start_point.node or entry.definition.node
end

local function get_end_node(entry)
  return entry.end_point and entry.end_point.node or entry.definition.node
end

function M.doc_node_at_cursor()
  local node_at_point = ts_utils.get_node_at_cursor()

  M.doc_node(node_at_point)
end

function M.doc_node(node, bufnr)
  if not node then return end

  local bufnr = bufnr or api.nvim_get_current_buf()
  local doc_data = M.get_doc_data_for_node(node, bufnr)

  if not doc_data then return end

  local doc_lines = templates.execute_template(doc_data)

  if not doc_lines then return end

  -- Root node to use for indentation of the doc comment.
  local start_node = get_start_node(doc_data)

  local node_start_row, node_start_col, _ = start_node:start()

  api.nvim_buf_set_lines(
    bufnr,
    node_start_row,
    node_start_row,
    false,
    indent_lines(doc_lines, node_start_col))
end

function M.get_doc_data_for_node(node, bufnr)
  local doc_data = M.collect_docs(bufnr)
  local _, _, node_start = node:start()

  for _, def in doc_data:iterate() do
    local _, _, start_point = get_start_node(def):start()
    local _, _, end_point = get_end_node(def):end_()

    if node_start >= start_point and node_start < end_point then
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

  local collector = Collector.new()
  local doc_matches = locals.get_locals(bufnr, 'docs')

  for _, item in ipairs(doc_matches) do
    for kind, match in pairs(item) do
      collector:add(kind, match)
    end
  end

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
