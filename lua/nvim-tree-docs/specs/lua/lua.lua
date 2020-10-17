local _3_ = nil
do
  local mod_name_0_ = ("lua" .. "." .. "ldoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = {default_tags = {author = {}, release = {}, see = {}, usage = {}}, use_type_tags = false}, inherits = nil, lang = "lua", spec = "ldoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _3_ = module_0_
end
local function _1_(ctx, tag)
  if ctx.conf("use_type_tags") then
    return ("t" .. tag)
  else
    return tag
  end
end
_3_.utils["get-typed-tag"] = _1_
local function _2_(context_0_)
  local function _4_(_241)
    local iterator_0_ = _241.iter(_241.parameters)
    local param = iterator_0_()
    while param do
      local function _5_(_2410)
        return _3_.utils["get-typed-tag"](_2410, "param")
      end
      local function _6_(_2410)
        return _2410["get-text"](param.entry.name)
      end
      local function _7_(_2410)
        return _2410["get-text"](param.entry.name)
      end
      _241["eval-content"]({"-- @", _5_, " ", _6_, ": the ", _7_})
      param = iterator_0_()
      if param then
        _241["next-line"]()
      end
    end
    return nil
  end
  local function _5_(_241)
    return _3_.utils["get-typed-tag"](_241, "returns")
  end
  for i_0_, line_0_ in ipairs({"--- Description", _4_, "-- @", _5_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["function"] = _2_
local function _4_(context_0_)
  for i_0_, line_0_ in ipairs({"--- Description"}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["variable"] = _4_
return nil