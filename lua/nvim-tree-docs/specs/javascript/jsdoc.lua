do
  local _1_0 = {templates = {}, utils = {}}
  require("nvim-tree-docs.template")["loaded-specs"][("javascript" .. "_" .. "jsdoc")] = _1_0
end
local function _2_(ctx, param)
  if param.default_value then
    return string.format("%s=%s", ctx["get-text"](param.name), ctx["get-text"](param.default_value))
  else
    return ctx["get-text"](param.name)
  end
end
_1_.utils["get-param-name"] = _2_
local function _3_()
  local function _4_(_241)
    return _241["eval-and-mark"]("any")
  end
  return {" {", _4_, "} "}
end
_1_.utils["get-marked-type"] = _3_
local function _4_(ctx, parameters)
  for _, param in ctx.iter(ctx.parameters) do
    local function _5_(_241)
      local function _6_()
        return ctx_0_["get-text"](param.name)
      end
      return _241["eval-and-mark"]({"The ", _6_})
    end
    do local _ = {" * @param ", _1_.utils["get-param-name"](ctx, param), _1_.utils["get-marked-type"](), "- ", _5_} end
  end
  return nil
end
_1_.utils["get-parameter-lines"] = _4_
local function _5_()
  return {" * returns", _1_.utils["get-marked-type"](), "The result"}
end
_1_.utils["get-return-line"] = _5_
local function _6_(context_0_)
  local function _7_(_241)
    local function _8_(_2410)
      return ctx_0_["get-text"](_2410.name)
    end
    return _241["eval-and-mark"]({_8_, " description"})
  end
  local function _8_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _9_(_241)
    return _1_.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _10_(_241)
    if _241.return_statement then
      return _1_.utils["get-return-line"]()
    end
  end
  for __0_, line_0_ in ipairs({"/**", {" *", _7_}, _8_, _9_, _10_, " */"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["function"] = _6_
local function _7_(context_0_)
  local function _8_(_241)
    if _241.export then
      return " * @export"
    end
  end
  for __0_, line_0_ in ipairs({"/**", " * Description", _8_, " * @type {any}", " */"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["variable"] = _7_
local function _8_(context_0_)
  local function _9_(_241)
    local function _10_(_2410)
      return ctx_0_["get-text"](_2410.name)
    end
    return _241["eval-and-mark"](_10_)
  end
  local function _10_(_241)
    if _241.class then
      local function _11_(_2410)
        return ctx_0_["get-text"](_2410.class)
      end
      return {" * @memberOf ", _11_}
    end
  end
  local function _11_(_241)
    return _1_.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _12_(_241)
    if _241.return_statement then
      return _1_.utils["get-return-line"]()
    end
  end
  for __0_, line_0_ in ipairs({"/**", {" *", _9_}, _10_, _11_, _12_, " */"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["method"] = _8_
local function _9_(context_0_)
  local function _10_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _11_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _12_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _13_(_241)
    for _, extention in _241.iter(_241.extentions) do
      local function _14_()
        return ctx_0_["get-text"](extention.name)
      end
      do local _ = {" * @extends", _14_} end
    end
    return nil
  end
  for __0_, line_0_ in ipairs({"/**", {" * The ", _10_, " class."}, {" * @class ", _11_}, _12_, _13_, " */"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["class"] = _9_
local function _10_(context_0_)
  local function _11_(_241)
    if _241.class then
      local function _12_(_2410)
        return ctx_0_["get-text"](_2410.class)
      end
      return {" * @memberOf ", _12_}
    end
  end
  for __0_, line_0_ in ipairs({"/**", " * Description", _11_, {" * @type", _1_.utils["get-marked-type"]()}, " */"}) do
    context_0_["eval-content"](line_0_)
    context_0_["next-line"]()
  end
  return context_0_
end
_1_.templates["member"] = _10_
return nil