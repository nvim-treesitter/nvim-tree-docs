local _3_ = nil
do
  local mod_name_0_ = ("javascript" .. "." .. "jsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {empty_line_after_description = false, include_types = true, slots = {["function"] = {["function"] = true, example = false, export = true, generator = true, param = true, returns = true, yields = true}, class = {class = true, example = false, export = true, extends = true}, member = {memberOf = true, type = true}, method = {example = false, memberOf = true, param = true, returns = true}, module = {module = true}, variable = {export = true, type = true}}}), inherits = nil, lang = "javascript", module = mod_name_0_, processors = {}, spec = "jsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "base.base")
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _3_ = module_0_
end
_3_.templates["function"] = {"doc-start", "description", "%rest%", "generator", "yields", "param", "returns", "example", "doc-end", "%content%"}
_3_.templates["variable"] = {"doc-start", "description", "%rest%", "doc-end", "%content%"}
_3_.templates["method"] = {"doc-start", "description", "%rest%", "memberOf", "param", "returns", "example", "doc-end", "%content%"}
_3_.templates["class"] = {"doc-start", "description", "%rest%", "class", "extends", "example", "doc-end", "%content%"}
_3_.templates["member"] = {"doc-start", "description", "%rest%", "class", "extends", "doc-end", "%content%"}
_3_.templates["module"] = {"doc-start", "description", "module", "%rest%", "doc-end"}
local function _1_()
  return "/**"
end
_3_.processors["doc-start"] = {build = _1_, implicit = true}
local function _2_()
  return " */"
end
_3_.processors["doc-end"] = {build = _2_, implicit = true}
local function _4_(_241)
  local type_str = _3_.utils["get-marked-type"](_241, " ")
  return (" * @returns" .. type_str .. "The result")
end
local function _5_(_241)
  return _241.return_statement
end
_3_.processors["returns"] = {build = _4_, when = _5_}
local function _6_(_241)
  return not _241.generator
end
_3_.processors["function"] = {when = _6_}
local function _7_()
  return " * @module <moduleName>"
end
_3_.processors["module"] = {build = _7_}
local function _8_(_241)
  return _241.generator
end
_3_.processors["generator"] = {when = _8_}
local function _9_(_241)
  return (" * @yields" .. _3_.utils["get-marked-type"](_241, ""))
end
local function _10_(_241)
  return _241.yields
end
_3_.processors["yields"] = {build = _9_, when = _10_}
local function _11_(_241, _242)
  local description = (" * The " .. _241["get-text"](_241.name) .. " " .. _242.name)
  local _12_ = _242
  local index = _12_["index"]
  local processors = _12_["processors"]
  local next_ps = processors[(index + 1)]
  if ((next_ps == "doc-end") or not _241.conf("empty_line_after_description")) then
    return description
  else
    return {description, " *"}
  end
end
_3_.processors["description"] = {build = _11_, implicit = true}
local function _12_(_241)
  local type_str = _3_.utils["get-marked-type"](_241, " ")
  return (" * @type" .. type_str)
end
local function _13_(_241)
  return _241.type
end
_3_.processors["type"] = {build = _12_, when = _13_}
local function _14_(_241)
  return _241.export
end
_3_.processors["export"] = {when = _14_}
local function _15_(_241)
  local result = {}
  for param in _241.iter(_241.parameters) do
    local param_name = _3_.utils["get-param-name"](_241, param.entry)
    local type_str = _3_.utils["get-marked-type"](_241, " ")
    local name = _241["get-text"](param.entry.name)
    table.insert(result, (" * @param " .. param_name .. type_str .. "- The " .. name))
  end
  return result
end
local function _16_(_241)
  return (_241.parameters and not _241["empty?"](_241.parameters))
end
_3_.processors["param"] = {build = _15_, when = _16_}
local function _17_(_241)
  return (" * @memberOf " .. _241["get-text"](_241.class))
end
local function _18_(_241)
  return _241.class
end
_3_.processors["memberOf"] = {build = _17_, when = _18_}
local function _19_(_241, _242)
  return (" * @" .. _242.name)
end
_3_.processors["__default"] = {build = _19_}
local function _20_(_24, param)
  if param.default_value then
    return string.format("%s=%s", _24["get-text"](param.name), _24["get-text"](param.default_value))
  else
    return _24["get-text"](param.name)
  end
end
_3_.utils["get-param-name"] = _20_
local function _21_(_24, not_found_3f)
  if _24.conf("include_types") then
    return " {any} "
  else
    return (not_found_3f or "")
  end
end
_3_.utils["get-marked-type"] = _21_
return nil