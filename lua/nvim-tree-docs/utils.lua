local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.utils"
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
  _0_0["aniseed/local-fns"] = {require = {core = "aniseed.core"}}
  return {require("aniseed.core")}
end
local _1_ = _2_(...)
local core = _1_[1]
do local _ = ({nil, _0_0, {{}, nil}})[2] end
local get_start_node = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_start_node0(entry)
      if (entry.start_point and entry.start_point.node) then
        return entry.start_point.node
      elseif (entry.definition and entry.definition.node) then
        return entry.definition.node
      else
        return nil
      end
    end
    v_0_0 = get_start_node0
    _0_0["get-start-node"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-start-node"] = v_0_
  get_start_node = v_0_
end
local get_end_node = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_end_node0(entry)
      if (entry.end_point and entry.end_point.node) then
        return entry.end_point.node
      elseif (entry.definition and entry.definition.node) then
        return entry.definition.node
      else
        return nil
      end
    end
    v_0_0 = get_end_node0
    _0_0["get-end-node"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-end-node"] = v_0_
  get_end_node = v_0_
end
return nil