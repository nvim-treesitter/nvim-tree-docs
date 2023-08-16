local _2afile_2a = "fnl/nvim-tree-docs/main.fnl"
local _2amodule_name_2a = "nvim-tree-docs.main"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("nvim-tree-docs.aniseed.autoload")).autoload
local queries, ts = autoload("nvim-treesitter.query"), autoload("nvim-treesitter")
do end (_2amodule_locals_2a)["queries"] = queries
_2amodule_locals_2a["ts"] = ts
local function init()
  local function _1_(_241)
    return (queries.get_query(_241, "docs") ~= nil)
  end
  return ts.define_modules({tree_docs = {module_path = "nvim-tree-docs.internal", keymaps = {doc_node_at_cursor = "gdd", doc_all_in_range = "gdd", edit_doc_at_cursor = "gde"}, is_supported = _1_}})
end
_2amodule_2a["init"] = init
return _2amodule_2a