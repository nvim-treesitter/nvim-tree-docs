local _2afile_2a = "fnl/nvim-tree-docs/editing.fnl"
local _0_
do
  local name_0_ = "nvim-tree-docs.editing"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("nvim-tree-docs.aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "nvim-tree-docs.editing"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local ts_utils = require("nvim-treesitter.ts_utils")
local tsq = require("vim.treesitter.query")
local ns = vim.api.nvim_create_namespace("doc-edit")
local get_doc_comment_data
do
  local v_0_
  do
    local v_0_0
    local function get_doc_comment_data0(args)
      local _let_0_ = args
      local bufnr = _let_0_["bufnr"]
      local doc_lang = _let_0_["doc-lang"]
      local lang = _let_0_["lang"]
      local node = _let_0_["node"]
      local doc_lines = ts_utils.get_node_text(node, bufnr)
      local doc_string = table.concat(doc_lines, "\n")
      local parser = vim.treesitter.get_string_parser(doc_string, doc_lang)
      local query = tsq.get_query(doc_lang, "edits")
      local iter = query:iter_matches(parser:parse():root(), doc_string, 1, (#doc_string + 1))
      local result = {}
      local item = {iter()}
      while item[1] do
        local _let_1_ = item
        local pattern_id = _let_1_[1]
        local matches = _let_1_[2]
        for id, match_node in pairs(matches) do
          local match_name = query.captures[id]
          if not result[match_name] then
            result[match_name] = {}
          end
          table.insert(result[match_name], match_node)
        end
        item = {iter()}
      end
      return result
    end
    v_0_0 = get_doc_comment_data0
    _0_["get-doc-comment-data"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-doc-comment-data"] = v_0_
  get_doc_comment_data = v_0_
end
local edit_doc
do
  local v_0_
  do
    local v_0_0
    local function edit_doc0(args)
      local _let_0_ = args
      local bufnr = _let_0_["bufnr"]
      local doc_node = _let_0_["node"]
      local _let_1_ = get_doc_comment_data(args)
      local edit = _let_1_["edit"]
      local sr = doc_node:range()
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      for _, node in ipairs(edit) do
        local dsr, dsc, der, dec = node:range()
        ts_utils.highlight_range({(dsr + sr), dsc, (der + sr), dec}, bufnr, ns, "Visual")
      end
      return nil
    end
    v_0_0 = edit_doc0
    _0_["edit-doc"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["edit-doc"] = v_0_
  edit_doc = v_0_
end
return nil