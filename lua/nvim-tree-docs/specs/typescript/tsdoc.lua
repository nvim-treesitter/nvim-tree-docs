local _3_ = nil
do
  local mod_name_0_ = ("typescript" .. "." .. "tsdoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {config = {include_types = false}, inherits = nil, lang = "typescript", spec = "tsdoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "javascript.jsdoc")
  template_mod_0_["loaded-specs"][mod_name_0_] = module_0_
  _3_ = module_0_
end
return nil