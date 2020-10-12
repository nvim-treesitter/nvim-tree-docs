do
  local _1_0 = {templates = {}, utils = {}}
  require("nvim-tree-docs.template")["loaded-specs"][("lua" .. "_" .. "lua")] = _1_0
end
local function _2_(context_0_)
  local function _3_(_241)
    for _, param in _241.iter(_241.parameters) do
      local function _4_()
        return ctx_0_["get-text"](param.name)
      end
      local function _5_()
        return ctx_0_["get-text"](param.name)
      end
      do local _ = {"-- @param ", _4_, ": the ", _5_} end
    end
    return nil
  end
  for __0_, line_0_ in ipairs({"--- Description", _3_, "-- @returns"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["function"] = _2_
local function _3_(context_0_)
  for __0_, line_0_ in ipairs({"--- Description"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["variable"] = _3_
return nil