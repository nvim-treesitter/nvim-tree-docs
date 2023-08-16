local _2afile_2a = "fnl/nvim-tree-docs/editing.fnl"
local _2amodule_name_2a = "nvim-tree-docs.editing"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("nvim-tree-docs.aniseed.autoload")).autoload
local ts_utils, tsq = autoload("nvim-treesitter.ts_utils"), autoload("vim.treesitter.query")
do end (_2amodule_locals_2a)["ts-utils"] = ts_utils
_2amodule_locals_2a["tsq"] = tsq
local ns = vim.api.nvim_create_namespace("doc-edit")
do end (_2amodule_locals_2a)["ns"] = ns
local function get_doc_comment_data(args)
  local _let_1_ = args
  local lang = _let_1_["lang"]
  local doc_lang = _let_1_["doc-lang"]
  local node = _let_1_["node"]
  local bufnr = _let_1_["bufnr"]
  local doc_lines = ts_utils.get_node_text(node, bufnr)
  local doc_string = table.concat(doc_lines, "\n")
  local parser = vim.treesitter.get_string_parser(doc_string, doc_lang)
  local query = tsq.get_query(doc_lang, "edits")
  local iter = query:iter_matches(parser:parse():root(), doc_string, 1, (#doc_string + 1))
  local result = {}
  local item = {iter()}
  while item[1] do
    local _let_2_ = item
    local pattern_id = _let_2_[1]
    local matches = _let_2_[2]
    for id, match_node in pairs(matches) do
      local match_name = query.captures[id]
      if not result[match_name] then
        result[match_name] = {}
      else
      end
      table.insert(result[match_name], match_node)
    end
    item = {iter()}
  end
  return result
end
_2amodule_2a["get-doc-comment-data"] = get_doc_comment_data
local function edit_doc(args)
  local _let_4_ = args
  local bufnr = _let_4_["bufnr"]
  local doc_node = _let_4_["node"]
  local _let_5_ = get_doc_comment_data(args)
  local edit = _let_5_["edit"]
  local sr = doc_node:range()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  for _, node in ipairs(edit) do
    local dsr, dsc, der, dec = node:range()
    ts_utils.highlight_range({(dsr + sr), dsc, (der + sr), dec}, bufnr, ns, "Visual")
  end
  return nil
end
_2amodule_2a["edit-doc"] = edit_doc
return _2amodule_2a