local _1_0 = nil
do
  local mod_name_0_ = ("javascript" .. "_" .. "jsdoc")
  local module_0_ = {lang = "javascript", spec = "jsdoc", templates = {}, utils = {}}
  require("nvim-tree-docs.template")["loaded-specs"][mod_name_0_] = module_0_
  _1_0 = module_0_
end
local function _2_(ctx, param)
  if param.default_value then
    return string.format("%s=%s", ctx["get-text"](param.name), ctx["get-text"](param.default_value))
  else
    return ctx["get-text"](param.name)
  end
end
_1_0.utils["get-param-name"] = _2_
local function _3_()
  local function _4_(_241)
    return _241["eval-and-mark"]("any")
  end
  return {" {", _4_, "} "}
end
_1_0.utils["get-marked-type"] = _3_
local function _4_(ctx, parameters)
  local function _5_(_241)
    local iterator_0_ = ctx.iter(ctx.parameters)
    local param = iterator_0_()
    while param do
      local function _6_(_2410)
        local function _7_(_2411)
          return _2411["get-text"](param.entry.name)
        end
        return _2410["eval-and-mark"]({"The ", _7_})
      end
      _241["eval-content"]({" * @param ", _1_0.utils["get-param-name"](ctx, param.entry), _1_0.utils["get-marked-type"](), "- ", _6_})
      param = iterator_0_()
      if param then
        _241["next-line"]()
      end
    end
    return nil
  end
  return _5_
end
_1_0.utils["get-parameter-lines"] = _4_
local function _5_()
  return {" * returns", _1_0.utils["get-marked-type"](), "The result"}
end
_1_0.utils["get-return-line"] = _5_
local function _6_(context_0_)
  local function _7_(_241)
    local function _8_(_2410)
      return _2410["get-text"](_2410.name)
    end
    return _241["eval-and-mark"]({_8_, " description"})
  end
  local function _8_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _9_(_241)
    return _1_0.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _10_(_241)
    if _241.return_statement then
      return _1_0.utils["get-return-line"]()
    end
  end
  local function _11_(_241)
    local function _12_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_12_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _7_}, _8_, _9_, _10_, " */", _11_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["function"] = _6_
local function _7_(context_0_)
  local function _8_(_241)
    return _241["get-text"](_241.name)
  end
  local function _9_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _10_(_241)
    local function _11_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_11_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _8_, " Description"}, _9_, " * @type {any}", " */", _10_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["variable"] = _7_
local function _8_(context_0_)
  local function _9_(_241)
    local function _10_(_2410)
      return _2410["get-text"](_2410.name)
    end
    return _241["eval-and-mark"](_10_)
  end
  local function _10_(_241)
    if _241.class then
      local function _11_(_2410)
        return _2410["get-text"](_2410.class)
      end
      return {" * @memberOf ", _11_}
    end
  end
  local function _11_(_241)
    return _1_0.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _12_(_241)
    if _241.return_statement then
      return _1_0.utils["get-return-line"]()
    end
  end
  local function _13_(_241)
    local function _14_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_14_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _9_}, _10_, _11_, _12_, " */", _13_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["method"] = _8_
local function _9_(context_0_)
  local function _10_(_241)
    return _241["get-text"](_241.name)
  end
  local function _11_(_241)
    return _241["get-text"](_241.name)
  end
  local function _12_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _13_(_241)
    for extention in _241.iter(_241.extentions) do
      local function _14_(_2410)
        return _2410["get-text"](extention.entry.name)
      end
      do local _ = {" * @extends", _14_} end
    end
    return nil
  end
  local function _14_(_241)
    local function _15_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_15_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * The ", _10_, " class."}, {" * @class ", _11_}, _12_, _13_, " */", _14_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["class"] = _9_
local function _10_(context_0_)
  local function _11_(_241)
    if _241.class then
      local function _12_(_2410)
        return _2410["get-text"](_2410.class)
      end
      return {" * @memberOf ", _12_}
    end
  end
  local function _12_(_241)
    local function _13_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_13_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", " * Description", _11_, {" * @type", _1_0.utils["get-marked-type"]()}, " */", _12_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_1_0.templates["member"] = _10_
return nil