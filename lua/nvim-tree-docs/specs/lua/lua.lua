local _1_0 = nil
do
  local mod_name_0_ = ("lua" .. "_" .. "lua")
  local module_0_ = {lang = "lua", spec = "lua", templates = {}, utils = {}}
  require("nvim-tree-docs.template")["loaded-specs"][mod_name_0_] = module_0_
  _1_0 = module_0_
end
local function _2_(context_0_)
  local function _3_(_241)
    for _, param in _241.iter(_241.parameters) do
      local function _4_(_2410)
        return _2410["get-text"](param.name)
      end
      local function _5_(_2410)
        return _2410["get-text"](param.name)
      end
      do local _ = {"-- @param ", _4_, ": the ", _5_} end
    end
    return nil
  end
  for i_0_, line_0_ in ipairs({"--- Description", _3_, "-- @returns"}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["function"] = _2_
local function _3_(context_0_)
  for i_0_, line_0_ in ipairs({"--- Description"}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["variable"] = _3_
return nil