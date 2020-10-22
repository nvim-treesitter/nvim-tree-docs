local _1_0 = nil
do
  local mod_name_0_ = ("typescript" .. "." .. "tsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {__build = template_mod_0_["build-line"], config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {empty_line_after_description = true, include_types = false, slots = {["function"] = {["function"] = false, export = false, generator = false}, class = {class = false, export = false, extends = false}, member = {memberOf = false, type = false}, method = {memberOf = false}, variable = {export = false, type = false}}}), inherits = nil, lang = "typescript", module = mod_name_0_, processors = {}, spec = "tsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "base.base")
  template_mod_0_["extend-spec"](module_0_, "javascript.jsdoc")
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _1_0 = module_0_
end
return nil