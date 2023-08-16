local _2afile_2a = "fnl/nvim-tree-docs/utils.fnl"
local _2amodule_name_2a = "nvim-tree-docs.utils"
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
local core = autoload("nvim-tree-docs.aniseed.core")
do end (_2amodule_locals_2a)["core"] = core
local ns = vim.api.nvim_create_namespace("blorg")
do end (_2amodule_2a)["ns"] = ns
local function get_start_node(entry)
  local function _2_()
    local _3_ = entry
    if (nil ~= _3_) then
      local _4_ = (_3_).start_point
      if (nil ~= _4_) then
        return (_4_).node
      else
        return _4_
      end
    else
      return _3_
    end
  end
  local function _7_()
    local _8_ = entry
    if (nil ~= _8_) then
      local _9_ = (_8_).definition
      if (nil ~= _9_) then
        return (_9_).node
      else
        return _9_
      end
    else
      return _8_
    end
  end
  return (_2_() or _7_())
end
_2amodule_2a["get-start-node"] = get_start_node
local function get_end_node(entry)
  local function _12_()
    local _13_ = entry
    if (nil ~= _13_) then
      local _14_ = (_13_).end_point
      if (nil ~= _14_) then
        return (_14_).node
      else
        return _14_
      end
    else
      return _13_
    end
  end
  local function _17_()
    local _18_ = entry
    if (nil ~= _18_) then
      local _19_ = (_18_).definition
      if (nil ~= _19_) then
        return (_19_).node
      else
        return _19_
      end
    else
      return _18_
    end
  end
  return (_12_() or _17_())
end
_2amodule_2a["get-end-node"] = get_end_node
local function get_position(keys, default_position, entry)
  local i = 1
  local result = nil
  while (not result and (i <= #keys)) do
    do
      local key = keys[i]
      local match_3f = entry[key]
      local has_match_3f = (core["table?"](match_3f) and match_3f.node)
      local position_3f
      if has_match_3f then
        position_3f = (match_3f.position or default_position)
      else
        position_3f = nil
      end
      if has_match_3f then
        if (position_3f == "start") then
          result = {(match_3f.node):start()}
        else
          result = {(match_3f.node):end_()}
        end
      else
      end
    end
    i = core.inc(i)
  end
  return unpack(result)
end
_2amodule_2a["get-position"] = get_position
local get_start_position
do
  local _25_ = {"start_point", "definition"}
  local function _26_(...)
    return get_position(_25_, "start", ...)
  end
  get_start_position = _26_
end
_2amodule_2a["get-start-position"] = get_start_position
local get_end_position
do
  local _27_ = {"end_point", "definition"}
  local function _28_(...)
    return get_position(_27_, "end", ...)
  end
  get_end_position = _28_
end
_2amodule_2a["get-end-position"] = get_end_position
local get_edit_start_position
do
  local _29_ = {"edit_start_point", "start_point", "definition"}
  local function _30_(...)
    return get_position(_29_, "start", ...)
  end
  get_edit_start_position = _30_
end
_2amodule_2a["get-edit-start-position"] = get_edit_start_position
local get_edit_end_position
do
  local _31_ = {"edit_end_point", "end_point", "definition"}
  local function _32_(...)
    return get_position(_31_, "end", ...)
  end
  get_edit_end_position = _32_
end
_2amodule_2a["get-edit-end-position"] = get_edit_end_position
local function get_bufnr(bufnr)
  return (bufnr or vim.api.nvim_get_current_buf())
end
_2amodule_2a["get-bufnr"] = get_bufnr
local function get_buf_content(start_row, start_col, end_row, end_col, bufnr)
  return vim.api.nvim_buf_get_lines(bufnr, start_row, (end_row + 1), false)
end
_2amodule_2a["get-buf-content"] = get_buf_content
local function get(path, tbl, default_3f)
  local segments
  if (type(path) == "string") then
    segments = vim.split(path, "%.")
  else
    segments = path
  end
  local result = tbl
  for _, segment in ipairs(segments) do
    if (type(result) == "table") then
      result = result[segment]
    else
      result = nil
    end
  end
  if (result == nil) then
    return default_3f
  else
    return result
  end
end
_2amodule_2a["get"] = get
local function make_inverse_list(tbl)
  local result = {}
  for i, v in ipairs(tbl) do
    result[v] = i
  end
  return result
end
_2amodule_2a["make-inverse-list"] = make_inverse_list
local function get_all_truthy_keys(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    if v then
      table.insert(result, k)
    else
    end
  end
  return result
end
_2amodule_2a["get-all-truthy-keys"] = get_all_truthy_keys
local function func_3f(v)
  return (type(v) == "function")
end
_2amodule_2a["func?"] = func_3f
local function method_3f(v, key)
  return ((type(v) == "table") and (type(v[key]) == "function"))
end
_2amodule_2a["method?"] = method_3f
local function highlight_marks(marks, bufnr)
  for _, mark in ipairs(marks) do
    local line = (mark.line - 1)
    vim.highlight.range(bufnr, ns, "Visual", {line, mark.start}, {line, mark.stop})
  end
  return nil
end
_2amodule_2a["highlight-marks"] = highlight_marks
return _2amodule_2a