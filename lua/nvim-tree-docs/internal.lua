local configs = require "nvim-treesitter.configs"
local queries = require "nvim-treesitter.query"
local ts_utils = require "nvim-treesitter.ts_utils"
local templates = require "nvim-tree-docs.template"
local Collector = require "nvim-tree-docs.collector"
local api = vim.api

local M = {}

M.doc_cache = {}

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

function M.get_docs_from_selection()
  local _, start_line, _, _ = unpack(vim.fn.getpos("'<"))
  local _, end_line, _, _ = unpack(vim.fn.getpos("'>"))

  start_line = start_line - 1
  end_line = end_line - 1

  return M.get_docs_in_range(start_line, end_line)
end

function M.get_docs_in_range(start_line, end_line)
  local doc_data = M.collect_docs(bufnr)
  local edits = {}

  for _, def in doc_data:iterate() do
    local start_row, _, _ = get_start_node(def):start()
    local end_row, _, _ = get_end_node(def):end_()

    if start_row >= start_line and end_row <= end_line then
      table.insert(edits, def)
    end
  end

  return edits
end

function M.doc_all_in_range()
  M.generate_docs(M.get_docs_from_selection())
end

function M.generate_docs(doc_data_list, bufnr)
  local edits = {}
  local bufnr = bufnr or api.nvim_get_current_buf()

  for _, doc_data in ipairs(doc_data_list) do
    local node_start_row, node_start_col, _ = get_start_node(doc_data):start()
    local node_end_row, _, _ = get_end_node(doc_data):end_()

    local doc_lines_above, doc_lines_below = templates.execute_template(doc_data, node_start_col)

    if doc_lines_above then
      table.insert(edits, {
        range = {
          start = {  line = node_start_row, character = 0 },
          ['end'] = { line = node_start_row, character = 0 }
        },
        newText = table.concat(doc_lines_above, '\n') .. '\n'
      })
    end

    if doc_lines_below then
      table.insert(edits, {
        range = {
          start = {  line = node_end_row + 1, character = 0 },
          ['end'] = { line = node_end_row + 1, character = 0 }
        },
        newText = table.concat(doc_lines_below, '\n') .. '\n'
      })
    end
  end

  vim.lsp.util.apply_text_edits(edits, bufnr)
end

function M.doc_node(node, bufnr)
  if not node then return end

  local bufnr = bufnr or api.nvim_get_current_buf()
  local doc_data = M.get_doc_data_for_node(node, bufnr)

  M.generate_docs({ doc_data })
end

function M.get_doc_data_for_node(node, bufnr)
  local doc_data = M.collect_docs(bufnr)
  local _, _, node_start = node:start()
  local current
  local last_start
  local last_end

  for _, def in doc_data:iterate() do
    local _, _, start_point = get_start_node(def):start()
    local _, _, end_point = get_end_node(def):end_()
    local is_in_range = node_start >= start_point and node_start < end_point
    local is_more_specific = true

    -- Find the most specific doc for docs that overlap in range
    if last_start and last_end then
      is_more_specific = start_point >= last_start and end_point <= last_end
    end

    if is_in_range and is_more_specific then
      last_start = start_point
      last_end = end_point
      current = def
    end
  end

  return current
end

function M.collect_docs(bufnr)
  local bufnr = bufnr or api.nvim_get_current_buf()

  if M.doc_cache[bufnr] and M.doc_cache[bufnr].tick == api.nvim_buf_get_changedtick(bufnr) then
    return M.doc_cache[bufnr].docs
  end

  local collector = Collector.new()
  local doc_matches = queries.collect_group_results(bufnr, 'docs')

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
    local mode = 'n'

    if fn == 'doc_all_in_range' then
      mode = 'v'
    end

    if mapping then
      local cmd = string.format(":lua require 'nvim-tree-docs.internal'.%s()<CR>", fn)
      api.nvim_buf_set_keymap(bufnr, mode, mapping, cmd, { silent = true })
    end
  end
end

function M.detach(bufnr)
  local buf = bufnr or api.nvim_get_current_buf()

  local config = configs.get_module('tree_docs')
  for fn, mapping in pairs(config.keymaps) do
    local mode = 'n'

    if fn == 'doc_all_in_range' then
      mode = 'v'
    end

    if mapping then
      api.nvim_buf_del_keymap(buf, mode, mapping)
    end
  end
end

return M
