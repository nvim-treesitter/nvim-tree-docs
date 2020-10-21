local _1_0 = nil
do
  local mod_name_0_ = ("base" .. "." .. "base")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {}), inherits = nil, lang = "base", module = mod_name_0_, processors = {}, spec = "base", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "base.base")
  template_mod_0_["extend-spec"](module_0_)
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _1_0 = module_0_
end
local function _2_(slot_indexes, slot_config)
  local expanded = {}
  for ps_name, enabled in pairs(slot_config) do
    if (enabled and not slot_indexes[ps_name]) then
      table.insert(expanded, ps_name)
    end
  end
  return expanded
end
_1_0.processors["%rest%"] = {expand = _2_, implicit = true}
local function _3_(_241)
  return _241.content
end
local function _4_(_241)
  return _241
end
_1_0.processors["%content%"] = {build = _3_, implicit = true, indent = _4_}
return nil