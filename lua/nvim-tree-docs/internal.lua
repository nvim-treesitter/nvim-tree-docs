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

local function get_insert_loc(entry)
  local start_node = get_start_node(entry)

  for key, match in pairs(entry) do
    local direction = string.match(key, "^insert_([a-z]+)")
    local col = 0

    if direction then
      local at_col = string.match(key, "_at_(%d+)$")

      return match.node, direction, (at_col or col)
    end
  end

  return start_node, 'above', 0
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

function M.node_to_lsp_range(node, direction)
  local start_row, _, end_row, _ = node:range()
  local row = start_row

  if direction == 'below' then
    row = end_row + 1
  end

  return {
    start = {  line = row, character = 0 },
    ['end'] = { line = row, character = 0 }
  }
end

function M.generate_docs(doc_data_list, bufnr)
  local edits = {}
  local bufnr = bufnr or api.nvim_get_current_buf()

  for _, doc_data in ipairs(doc_data_list) do
    local doc_lines = templates.execute_template(doc_data)

    if doc_lines then
      local start_node = get_start_node(doc_data)
      local insert_node, direction, at_col = get_insert_loc(doc_data)
      local _, node_start_col, _ = start_node:start()
      local range = M.node_to_lsp_range(insert_node, direction)
      local new_text = indent_lines(doc_lines, node_start_col + at_col)

      table.insert(edits, { range = range, newText = table.concat(new_text, '\n') .. '\n' })
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
