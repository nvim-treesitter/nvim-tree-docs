local _3_ = nil
do
  local mod_name_0_ = ("javascript" .. "." .. "jsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = {author = "", empty_line_after_description = true, include_types = true, processors = {}, tags = {["function"] = {export = true, param = true, returns = true}, class = {class = true, export = true, extends = true}, member = {memberOf = true, type = true}, method = {memberOf = true, param = true, returns = true}, variable = {export = true, type = true}}}, inherits = nil, lang = "javascript", spec = "jsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _3_ = module_0_
end
local function _1_(_241)
  local type_str = _3_.utils["get-marked-type"](_241, " ")
  return (" * @returns" .. type_str .. "The result")
end
local function _2_(_241)
  return _241.returns()
end
_3_.processors["returns"] = {build = _1_, when = _2_}
_3_.processors["description"] = {configurable = build}
local function _4_(_241)
  local type_str = _3_.utils["get-marked-type"](_241, " ")
  return (" * @type" .. type_str)
end
local function _5_(_241)
  return _241.type()
end
_3_.processors["type"] = {build = _4_, when = _5_}
local function _6_(_241)
  local result = {}
  for param in _241.iter(_241.parameters) do
    local param_name = _3_.utils["get-param-name"](_241, param.entry)
    local type_str = _3_.utils["get-marked-type"](_241, " ")
    local name = nil
    local function _7_(_2410)
      return _2410["get-text"](param.entry.name)
    end
    name = _7_
    table.insert(result, (" * @param " .. param_name .. type_str .. "- The " .. name))
  end
  return nil
end
local function _7_(_241)
  return (_241.parameters and not _241["is-empty"](_241.parameters))
end
_3_.processors["param"] = {build = _6_, when = _7_}
local function _8_(_241, _242)
  return (" * @" .. _242)
end
_3_.processors["__default"] = {build = _8_}
return nil