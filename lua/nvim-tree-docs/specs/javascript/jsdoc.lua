do
  local _1_0 = {templates = {}}
  require("nvim-tree-docs.template")["loaded-specs"][("javascript" .. "_" .. "jsdoc")] = _1_0
end
local function get_param_name(ctx, param)
  if param.default_value then
    return string.format("%s=%s", ctx["get-text"](param.name), ctx["get-text"](param.default_value))
  else
    return ctx["get-text"](param.name)
  end
end
local function _2_(context_0_)
  local output_0_ = {}
  local function _3_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _4_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _5_(_241)
    for _, param in _241.iter(_241.parameters) do
      local function _6_(_2410)
        return get_param_name(_2410, param)
      end
      local function _7_()
        return ctx_0_["get-text"](param.name)
      end
      do local _ = {" * @param", _6_, "{any} - The", _7_} end
    end
    return nil
  end
  local function _6_(_241)
    if _241.return_statement then
      return " * returns {any} The result"
    end
  end
  for __0_, line_0_ in ipairs({"/**", {" *", _3_, "description"}, _4_, _5_, _6_, " */"}) do
    table.insert(output_0_, context_0_["eval-line"](line_0_, context_0_))
  end
  return output_0_
end
_1_.templates["function"] = _2_
local function _3_(context_0_)
  local output_0_ = {}
  local function _4_(_241)
    if _241.export then
      return " * @export"
    end
  end
  for __0_, line_0_ in ipairs({"/**", " * Description", _4_, " * @type {any}", " */"}) do
    table.insert(output_0_, context_0_["eval-line"](line_0_, context_0_))
  end
  return output_0_
end
_1_.templates["variable"] = _3_
local function _4_(context_0_)
  local output_0_ = {}
  local function _5_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _6_(_241)
    if _241.class then
      local function _7_(_2410)
        return ctx_0_["get-text"](_2410.class)
      end
      return {" * @memberOf", _7_}
    end
  end
  local function _7_(_241)
    for _, param in _241.iter(_241.parameters) do
      local function _8_(_2410)
        return get_param_name(_2410, param)
      end
      local function _9_()
        return ctx_0_["get-text"](param.name)
      end
      do local _ = {" * @param", _8_, "{any} - The", _9_, "argument"} end
    end
    return nil
  end
  local function _8_(_241)
    if _241.return_statement then
      return " * @returns"
    end
  end
  for __0_, line_0_ in ipairs({"/**", {" *", _5_}, _6_, _7_, _8_, " */"}) do
    table.insert(output_0_, context_0_["eval-line"](line_0_, context_0_))
  end
  return output_0_
end
_1_.templates["method"] = _4_
local function _5_(context_0_)
  local output_0_ = {}
  local function _6_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _7_(_241)
    return ctx_0_["get-text"](_241.name)
  end
  local function _8_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _9_(_241)
    for _, extention in _241.iter(_241.extentions) do
      local function _10_()
        return ctx_0_["get-text"](extention.name)
      end
      do local _ = {" * @extends", _10_} end
    end
    return nil
  end
  for __0_, line_0_ in ipairs({"/**", {" * The", _6_, "class."}, {" * @class", _7_}, _8_, _9_, " */"}) do
    table.insert(output_0_, context_0_["eval-line"](line_0_, context_0_))
  end
  return output_0_
end
_1_.templates["class"] = _5_
return nil