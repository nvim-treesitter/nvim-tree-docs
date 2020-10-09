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
  _0_0["aniseed/local-fns"] = {require = {collectors = "nvim-tree-docs.collector", utils = "nvim-tree-docs.utils"}}
  return {require("nvim-tree-docs.collector"), require("nvim-tree-docs.utils")}
end
local _1_ = _2_(...)
local collectors = _1_[1]
local utils = _1_[2]
do local _ = ({nil, _0_0, {{}, nil}})[2] end
local configs = require("nvim-treesitter.configs")
local queries = require("nvim-treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local doc_node = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function doc_node0()
    end
    v_0_0 = doc_node0
    _0_0["doc-node"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["doc-node"] = v_0_
  doc_node = v_0_
end
local doc_node_at_cursor = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function doc_node_at_cursor0()
      return doc_node(ts_utils.get_node_at_cursor())
    end
    v_0_0 = doc_node_at_cursor0
    _0_0["doc-node-at-cursor"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["doc-node-at-cursor"] = v_0_
  doc_node_at_cursor = v_0_
end
return nil