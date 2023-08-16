local _2afile_2a = "fnl/nvim-tree-docs/specs/base/base.fnl"
local _1_
do
  local mod_name_1_auto = ("base" .. "." .. "base")
  local template_mod_2_auto = require("nvim-tree-docs.template")
  local module_3_auto = {__build = template_mod_2_auto["build-line"], config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {}), ["doc-lang"] = "nil", inherits = nil, lang = "base", module = mod_name_1_auto, processors = {}, spec = "base", templates = {}, utils = {}}
  template_mod_2_auto["extend-spec"](module_3_auto, "base.base")
  template_mod_2_auto["extend-spec"](module_3_auto)
  do end ((template_mod_2_auto)["loaded-specs"])[mod_name_1_auto] = module_3_auto
  _1_ = module_3_auto
end
local function _2_(slot_indexes, slot_config)
  local expanded = {}
  for ps_name, enabled in pairs(slot_config) do
    if (enabled and not slot_indexes[ps_name]) then
      table.insert(expanded, ps_name)
    else
    end
  end
  return expanded
end
(_1_).processors["%rest%"] = {expand = _2_, implicit = true}
local function _4_(_241)
  return _241.content
end
local function _5_()
  return 0
end
(_1_).processors["%content%"] = {build = _4_, implicit = true, indent = _5_}
return nil