local _1_0 = nil
do
  local mod_name_0_ = ("javascript" .. "." .. "jsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {__build = template_mod_0_["build-line"], config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {empty_line_after_description = false, include_types = true, slots = {["function"] = {["function"] = true, example = false, export = true, generator = true, param = true, returns = true, template = true, yields = true}, class = {class = true, example = false, export = true, extends = true}, member = {memberof = true, type = true}, method = {example = false, generator = true, memberof = true, param = true, returns = true, yields = true}, module = {module = true}, variable = {export = true, type = true}}}), inherits = nil, lang = "javascript", module = mod_name_0_, processors = {}, spec = "jsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "base.base")
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _1_0 = module_0_
end
_1_0.templates["function"] = {"doc-start", "description", "function", "generator", "yields", "%rest%", "param", "returns", "example", "doc-end", "%content%"}
_1_0.templates["variable"] = {"doc-start", "description", "%rest%", "doc-end", "%content%"}
_1_0.templates["method"] = {"doc-start", "description", "memberof", "%rest%", "param", "returns", "example", "doc-end", "%content%"}
_1_0.templates["class"] = {"doc-start", "description", "class", "extends", "%rest%", "example", "doc-end", "%content%"}
_1_0.templates["member"] = {"doc-start", "description", "memberof", "%rest%", "doc-end", "%content%"}
_1_0.templates["module"] = {"doc-start", "description", "module", "%rest%", "doc-end"}
local function _2_()
  return "/**"
end
_1_0.processors["doc-start"] = {build = _2_, implicit = true}
local function _3_()
  return " */"
end
_1_0.processors["doc-end"] = {build = _3_, implicit = true}
local function _4_(_241)
  local type_str = _1_0.utils["get-marked-type"](_241, " ")
  return _1_0.__build(" * @returns", type_str, {content = "The result", mark = "tabstop"})
end
local function _5_(_241)
  return _241.return_statement
end
_1_0.processors["returns"] = {build = _4_, when = _5_}
local function _6_(_241)
  return _1_0.__build(" * @function ", _241["get-text"](_241.name))
end
local function _7_(_241)
  return not _241.generator
end
_1_0.processors["function"] = {build = _6_, when = _7_}
local function _8_()
  local filename = vim.fn.expand("%:t:r")
  return _1_0.__build(" * @module ", {content = filename, mark = "tabstop"})
end
_1_0.processors["module"] = {build = _8_}
local function _9_(_241)
  local result = {}
  for generic in _241.iter(_241.generics) do
    local name = _241["get-text"](generic.entry.name)
    table.insert(result, _1_0.__build(" * @template ", name, " ", {content = ("The " .. name .. " type"), mark = "tabstop"}))
  end
  return result
end
local function _10_(_241)
  return _241.generics
end
_1_0.processors["template"] = {build = _9_, when = _10_}
local function _11_(_241)
  return _1_0.__build(" * @extends ", _241["get-text"](_241.extends))
end
local function _12_(_241)
  return _241.extends
end
_1_0.processors["extends"] = {build = _11_, when = _12_}
local function _13_(_241)
  return _1_0.__build(" * @class ", _241["get-text"](_241.name))
end
_1_0.processors["class"] = {build = _13_}
local function _14_(_241)
  return _241.generator
end
_1_0.processors["generator"] = {when = _14_}
local function _15_(_241)
  return _1_0.__build(" * @yields", _1_0.utils["get-marked-type"](_241, ""))
end
local function _16_(_241)
  return _241.yields
end
_1_0.processors["yields"] = {build = _15_, when = _16_}
local function _17_(_241, _242)
  local description = _1_0.__build(" * ", {content = ("The " .. _241["get-text"](_241.name) .. " " .. _242.name), mark = "tabstop"})
  local _18_ = _242
  local index = _18_["index"]
  local processors = _18_["processors"]
  local next_ps = processors[(index + 1)]
  if ((next_ps == "doc-end") or not _241.conf("empty_line_after_description")) then
    return description
  else
    return {description, " *"}
  end
end
_1_0.processors["description"] = {build = _17_, implicit = true}
local function _18_(_241)
  local type_str = _1_0.utils["get-marked-type"](_241, " ")
  return _1_0.__build(" * @type", type_str)
end
local function _19_(_241)
  return _241.type
end
_1_0.processors["type"] = {build = _18_, when = _19_}
local function _20_(_241)
  return _241.export
end
_1_0.processors["export"] = {when = _20_}
local function _21_(_241)
  local result = {}
  for param in _241.iter(_241.parameters) do
    local param_name = _1_0.utils["get-param-name"](_241, param.entry)
    local type_str = _1_0.utils["get-marked-type"](_241, " ")
    local name = _241["get-text"](param.entry.name)
    table.insert(result, _1_0.__build(" * @param ", param_name, type_str, "- ", {content = ("The " .. name .. " param"), mark = "tabstop"}))
  end
  return result
end
local function _22_(_241)
  return (_241.parameters and not _241["empty?"](_241.parameters))
end
_1_0.processors["param"] = {build = _21_, when = _22_}
local function _23_(_241)
  return _1_0.__build(" * @memberof ", _241["get-text"](_241.class))
end
local function _24_(_241)
  return _241.class
end
_1_0.processors["memberof"] = {build = _23_, when = _24_}
local function _25_(_241, _242)
  return _1_0.__build(" * @", _242.name)
end
_1_0.processors["__default"] = {build = _25_}
local function _26_(_24, param)
  if param.default_value then
    return string.format("%s=%s", _24["get-text"](param.name), _24["get-text"](param.default_value))
  else
    return _24["get-text"](param.name)
  end
end
_1_0.utils["get-param-name"] = _26_
local function _27_(_24, not_found_3f)
  if _24.conf("include_types") then
    return " {any} "
  else
    return (not_found_3f or "")
  end
end
_1_0.utils["get-marked-type"] = _27_
return nil