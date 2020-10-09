local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.main"
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
  _0_0["aniseed/local-fns"] = {}
  return {}
end
local _1_ = _2_(...)
do local _ = ({nil, _0_0, {{}, nil}})[2] end
local queries = require("nvim-treesitter.query")
local init = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function init0()
      local function _3_(_241)
        return (queries.get_query(_241, "docs") ~= nil)
      end
      return require("nvim-treesitter", {tree_docs = {is_supported = _3_, keymaps = {doc_all_in_range = "gdd", doc_node_at_cursor = "gdd"}, module_path = "nvim-tree-docs.internal"}})
    end
    v_0_0 = init0
    _0_0["init"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["init"] = v_0_
  init = v_0_
end
return nil