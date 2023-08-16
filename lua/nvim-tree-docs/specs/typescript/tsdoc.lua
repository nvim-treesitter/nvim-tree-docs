local _2afile_2a = "fnl/nvim-tree-docs/specs/typescript/tsdoc.fnl"
local _1_
do
  local mod_name_1_auto = ("typescript" .. "." .. "tsdoc")
  local template_mod_2_auto = require("nvim-tree-docs.template")
  local module_3_auto = {__build = template_mod_2_auto["build-line"], config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {empty_line_after_description = true, slots = {["function"] = {["function"] = false, generator = false, export = false}, variable = {type = false, export = false}, class = {class = false, extends = false, export = false}, member = {type = false, memberof = false}, method = {memberof = false}}, include_types = false}), ["doc-lang"] = "nil", inherits = nil, lang = "typescript", module = mod_name_1_auto, processors = {}, spec = "tsdoc", templates = {}, utils = {}}
  template_mod_2_auto["extend-spec"](module_3_auto, "base.base")
  template_mod_2_auto["extend-spec"](module_3_auto, "javascript.jsdoc")
  do end ((template_mod_2_auto)["loaded-specs"])[mod_name_1_auto] = module_3_auto
  _1_ = module_3_auto
end
return nil