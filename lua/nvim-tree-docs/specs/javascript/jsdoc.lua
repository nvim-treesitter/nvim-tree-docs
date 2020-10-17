local _3_ = nil
do
  local mod_name_0_ = ("javascript" .. "." .. "jsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = {empty_line_after_description = true, include_types = true}, inherits = nil, lang = "javascript", spec = "jsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _3_ = module_0_
end
local function _1_(_24, param)
  if param.default_value then
    return string.format("%s=%s", _24["get-text"](param.name), _24["get-text"](param.default_value))
  else
    return _24["get-text"](param.name)
  end
end
_3_.utils["get-param-name"] = _1_
local function _2_(_24, not_found_3f)
  if _24.conf("include_types") then
    local function _4_(_241)
      return _241["eval-and-mark"]("any")
    end
    return {" {", _4_, "} "}
  else
    return (not_found_3f or "")
  end
end
_3_.utils["get-marked-type"] = _2_
local function _4_(_24, parameters)
  local function _5_(_241)
    local iterator_0_ = _241.iter(_241.parameters)
    local param = iterator_0_()
    while param do
      local function _6_(_2410)
        return _3_.utils["get-param-name"](_2410, param.entry)
      end
      local function _7_(_2410)
        return _3_.utils["get-marked-type"](_2410, " ")
      end
      local function _8_(_2410)
        local function _9_(_2411)
          return _2411["get-text"](param.entry.name)
        end
        return _2410["eval-and-mark"]({"The ", _9_})
      end
      _241["eval-content"]({" * @param ", _6_, _7_, "- ", _8_})
      param = iterator_0_()
      if param then
        _241["next-line"]()
      end
    end
    return nil
  end
  return _5_
end
_3_.utils["get-parameter-lines"] = _4_
local function _5_(_24)
  local function _6_(_241)
    return _3_.utils["get-marked-type"](_241, " ")
  end
  return {" * @returns", _6_, "The result"}
end
_3_.utils["get-return-line"] = _5_
local function _6_(context_0_)
  local function _7_(_241)
    local function _8_(_2410)
      return _2410["get-text"](_2410.name)
    end
    return _241["eval-and-mark"]({_8_, " description"})
  end
  local function _8_(_241)
    if _241.conf("empty_line_after_description") then
      return " *"
    end
  end
  local function _9_(_241)
    if _241.export then
      return " * @export"
    end
  end
  local function _10_(_241)
    return _3_.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _11_(_241)
    if _241.return_statement then
      local function _12_(_2410)
        return _3_.utils["get-return-line"](_2410)
      end
      return _12_
    end
  end
  local function _12_(_241)
    local function _13_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_13_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _7_}, _8_, _9_, _10_, _11_, " */", _12_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["function"] = _6_
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
    if _241.conf("include_types") then
      local function _11_(_2410)
        return _3_.utils["get-marked-type"](_2410)
      end
      return {" * @type", _11_}
    end
  end
  local function _11_(_241)
    local function _12_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_12_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _8_, " Description"}, _9_, _10_, " */", _11_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["variable"] = _7_
local function _8_(context_0_)
  local function _9_(_241)
    local function _10_(_2410)
      return _2410["get-text"](_2410.name)
    end
    return _241["eval-and-mark"](_10_)
  end
  local function _10_(_241)
    if _241.conf("empty_line_after_description") then
      return " *"
    end
  end
  local function _11_(_241)
    if _241.class then
      local function _12_(_2410)
        return _2410["get-text"](_2410.class)
      end
      return {" * @memberOf ", _12_}
    end
  end
  local function _12_(_241)
    return _3_.utils["get-parameter-lines"](_241, _241.parameters)
  end
  local function _13_(_241)
    if _241.return_statement then
      local function _14_()
        return _3_.utils["get-return-line"]()
      end
      return _14_
    end
  end
  local function _14_(_241)
    local function _15_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_15_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", {" * ", _9_}, _10_, _11_, _12_, _13_, " */", _14_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["method"] = _8_
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
    local iterator_0_ = _241.iter(_241.extentions)
    local extention = iterator_0_()
    while extention do
      local function _14_(_2410)
        return _2410["get-text"](extention.entry.name)
      end
      _241["eval-content"]({" * @extends", _14_})
      extention = iterator_0_()
      if extention then
        _241["next-line"]()
      end
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
_3_.templates["class"] = _9_
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
    if _241.conf("include_types") then
      local function _13_(_2410)
        return _3_.utils["get-marked-type"](_2410)
      end
      return {" * @type", _13_}
    end
  end
  local function _13_(_241)
    local function _14_(_2410)
      return _2410["expand-content-lines"]()
    end
    return _241["eval-and-mark"](_14_, "%content")
  end
  for i_0_, line_0_ in ipairs({"/**", " * Description", _11_, _12_, " */", _13_}) do
    context_0_["eval-content"](line_0_, (i_0_ == 1))
    context_0_["next-line"]()
  end
  return context_0_
end
_3_.templates["member"] = _10_
return nil