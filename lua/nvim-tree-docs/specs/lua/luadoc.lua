local _2afile_2a = "fnl/nvim-tree-docs/specs/lua/luadoc.fnl"
local _1_
do
  local mod_name_0_ = ("lua" .. "." .. "luadoc")
  local template_mod_0_ = require("nvim-tree-docs.template")
  local module_0_ = {["doc-lang"] = "nil", __build = template_mod_0_["build-line"], config = vim.tbl_deep_extend("force", {processors = {}, slots = {}}, {slots = {["function"] = {param = true, returns = true}, variable = {}}}), inherits = nil, lang = "lua", module = mod_name_0_, processors = {}, spec = "luadoc", templates = {}, utils = {}}
  template_mod_0_["extend-spec"](module_0_, "base.base")
  template_mod_0_["extend-spec"](module_0_)
  do end ((template_mod_0_)["loaded-specs"])[mod_name_0_] = module_0_
  _1_ = module_0_
end
(_1_).templates["function"] = {"description", "param", "returns"}
(_1_).templates["variable"] = {"description"}
local function _2_()
  return "--- Description"
end
(_1_).processors["description"] = {build = _2_, implicit = true}
local function _3_(_241)
  local result = {}
  for param in _241.iter(_241.parameters) do
    local name = _241["get-text"](param.entry.name)
    table.insert(result, ("-- @param " .. name .. " The " .. name))
  end
  return result
end
local function _4_(_241)
  return (_241.parameters and not _241["empty?"](_241.parameters))
end
(_1_).processors["param"] = {build = _3_, when = _4_}
return nil