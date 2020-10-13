local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.internal"
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
    return {require("nvim-tree-docs.collector"), require("aniseed.core"), require("nvim-tree-docs.template"), require("nvim-tree-docs.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {collectors = "nvim-tree-docs.collector", core = "aniseed.core", templates = "nvim-tree-docs.template", utils = "nvim-tree-docs.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _1_ = _2_(...)
local collectors = _1_[1]
local core = _1_[2]
local templates = _1_[3]
local utils = _1_[4]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.internal"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local configs = require("nvim-treesitter.configs")
local queries = require("nvim-treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local language_specs = nil
do
  local v_0_ = {javascript = "jsdoc", lua = "lua", typescript = "jsdoc"}
  _0_0["aniseed/locals"]["language-specs"] = v_0_
  language_specs = v_0_
end
local get_spec_for_lang = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_spec_for_lang0(lang)
      local spec = language_specs[lang]
      if not spec then
        error(string.format("No language spec configured for %s", lang))
      end
      return spec
    end
    v_0_0 = get_spec_for_lang0
    _0_0["get-spec-for-lang"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-spec-for-lang"] = v_0_
  get_spec_for_lang = v_0_
end
local get_spec_for_buf = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_spec_for_buf0(bufnr_3f)
      local bufnr = (bufnr_3f or vim.api.nvim_get_current_buf())
      return get_spec_for_lang(vim.api.nvim_buf_get_option(bufnr, "ft"))
    end
    v_0_0 = get_spec_for_buf0
    _0_0["get-spec-for-buf"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-spec-for-buf"] = v_0_
  get_spec_for_buf = v_0_
end
local generate_docs = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function generate_docs0(data_list, bufnr_3f)
      local bufnr = utils["get-bufnr"](bufnr_3f)
      local lang = vim.api.nvim_buf_get_option(bufnr, "ft")
      local spec = templates["get-spec"](lang, get_spec_for_lang(lang))
      local edits = {}
      for _, doc_data in ipairs(data_list) do
        local node_sr, node_sc = utils["get-start-node"](doc_data):start()
        local node_er, node_ec = utils["get-end-node"](doc_data):end_()
        local context = templates["execute-template"](doc_data, spec[doc_data.kind])
        local content_lines = ts_utils.get_node_text(doc_data, bufnr)
        local lines = templates["context-to-lines"](context, content_lines, node_sc)
        table.insert(edits, {newText = table.concat(lines, "\n"), range = {["end"] = {character = node_ec, line = node_er}, start = {character = 0, line = node_sr}}})
      end
      return vim.lsp.util.apply_text_edits(edits, bufnr)
    end
    v_0_0 = generate_docs0
    _0_0["generate-docs"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["generate-docs"] = v_0_
  generate_docs = v_0_
end
return nil