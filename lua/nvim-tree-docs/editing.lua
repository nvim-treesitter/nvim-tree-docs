local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.editing"
  local loaded_0_ = package.loaded[name_0_]
  local module_0_ = nil
  if ("table" == type(loaded_0_)) then
    module_0_ = loaded_0_
  else
    module_0_ = {}
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = (module_0_["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = (module_0_["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _1_ = _2_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.editing"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local ts_utils = require("nvim-treesitter.ts_utils")
local tsq = require("vim.treesitter.query")
local ns = vim.api.nvim_create_namespace("doc-edit")
local get_doc_comment_data = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_doc_comment_data0(args)
      local _3_ = args
      local bufnr = _3_["bufnr"]
      local doc_lang = _3_["doc-lang"]
      local lang = _3_["lang"]
      local node = _3_["node"]
      local doc_lines = ts_utils.get_node_text(node, bufnr)
      local doc_string = table.concat(doc_lines, "\n")
      local parser = vim.treesitter.get_string_parser(doc_string, doc_lang)
      local query = tsq.get_query(doc_lang, "edits")
      local iter = query:iter_matches(parser:parse():root(), doc_string, 1, (#doc_string + 1))
      local result = {}
      local item = {iter()}
      while item[1] do
        local _4_ = item
        local pattern_id = _4_[1]
        local matches = _4_[2]
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
    _0_0["get-doc-comment-data"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-doc-comment-data"] = v_0_
  get_doc_comment_data = v_0_
end
local edit_doc = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function edit_doc0(args)
      local _3_ = args
      local bufnr = _3_["bufnr"]
      local doc_node = _3_["node"]
      local _4_ = get_doc_comment_data(args)
      local edit = _4_["edit"]
      local sr = doc_node:range()
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      for _, node in ipairs(edit) do
        local dsr, dsc, der, dec = node:range()
        ts_utils.highlight_range({(dsr + sr), dsc, (der + sr), dec}, bufnr, ns, "Visual")
      end
      return nil
    end
    v_0_0 = edit_doc0
    _0_0["edit-doc"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["edit-doc"] = v_0_
  edit_doc = v_0_
end
return nil