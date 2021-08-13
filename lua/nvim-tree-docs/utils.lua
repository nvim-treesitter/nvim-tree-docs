local _2afile_2a = "fnl/nvim-tree-docs/utils.fnl"
local _0_
do
  local name_0_ = "nvim-tree-docs.utils"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _2_(...)
  return (require("nvim-tree-docs.aniseed.autoload")).autoload(...)
end
autoload = _2_
local function _3_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _3_()
    return {require("nvim-tree-docs.aniseed.core")}
  end
  ok_3f_0_, val_0_ = pcall(_3_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {core = "nvim-tree-docs.aniseed.core"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _3_(...)
local core = _local_0_[1]
local _2amodule_2a = _0_
local _2amodule_name_2a = "nvim-tree-docs.utils"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local ns
do
  local v_0_
  do
    local v_0_0 = vim.api.nvim_create_namespace("blorg")
    do end (_0_)["ns"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["ns"] = v_0_
  ns = v_0_
end
local get_start_node
do
  local v_0_
  do
    local v_0_0
    local function get_start_node0(entry)
      local _5_
      do
        local _4_ = entry
        if _4_ then
          local _6_ = (_4_).start_point
          if _6_ then
            _5_ = (_6_).node
          else
            _5_ = _6_
          end
        else
          _5_ = _4_
        end
      end
      local function _7_()
        local _6_ = entry
        if _6_ then
          local _8_ = (_6_).definition
          if _8_ then
            return (_8_).node
          else
            return _8_
          end
        else
          return _6_
        end
      end
      return (_5_ or _7_())
    end
    v_0_0 = get_start_node0
    _0_["get-start-node"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-start-node"] = v_0_
  get_start_node = v_0_
end
local get_end_node
do
  local v_0_
  do
    local v_0_0
    local function get_end_node0(entry)
      local _5_
      do
        local _4_ = entry
        if _4_ then
          local _6_ = (_4_).end_point
          if _6_ then
            _5_ = (_6_).node
          else
            _5_ = _6_
          end
        else
          _5_ = _4_
        end
      end
      local function _7_()
        local _6_ = entry
        if _6_ then
          local _8_ = (_6_).definition
          if _8_ then
            return (_8_).node
          else
            return _8_
          end
        else
          return _6_
        end
      end
      return (_5_ or _7_())
    end
    v_0_0 = get_end_node0
    _0_["get-end-node"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-end-node"] = v_0_
  get_end_node = v_0_
end
local get_position
do
  local v_0_
  do
    local v_0_0
    local function get_position0(keys, default_position, entry)
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
          end
        end
        i = core.inc(i)
      end
      return unpack(result)
    end
    v_0_0 = get_position0
    _0_["get-position"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-position"] = v_0_
  get_position = v_0_
end
local get_start_position
do
  local v_0_
  do
    local v_0_0
    local function _4_(...)
      return get_position({"start_point", "definition"}, "start", ...)
    end
    v_0_0 = _4_
    _0_["get-start-position"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-start-position"] = v_0_
  get_start_position = v_0_
end
local get_end_position
do
  local v_0_
  do
    local v_0_0
    local function _4_(...)
      return get_position({"end_point", "definition"}, "end", ...)
    end
    v_0_0 = _4_
    _0_["get-end-position"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-end-position"] = v_0_
  get_end_position = v_0_
end
local get_edit_start_position
do
  local v_0_
  do
    local v_0_0
    local function _4_(...)
      return get_position({"edit_start_point", "start_point", "definition"}, "start", ...)
    end
    v_0_0 = _4_
    _0_["get-edit-start-position"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-edit-start-position"] = v_0_
  get_edit_start_position = v_0_
end
local get_edit_end_position
do
  local v_0_
  do
    local v_0_0
    local function _4_(...)
      return get_position({"edit_end_point", "end_point", "definition"}, "end", ...)
    end
    v_0_0 = _4_
    _0_["get-edit-end-position"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-edit-end-position"] = v_0_
  get_edit_end_position = v_0_
end
local get_bufnr
do
  local v_0_
  do
    local v_0_0
    local function get_bufnr0(bufnr)
      return (bufnr or vim.api.nvim_get_current_buf())
    end
    v_0_0 = get_bufnr0
    _0_["get-bufnr"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-bufnr"] = v_0_
  get_bufnr = v_0_
end
local get_buf_content
do
  local v_0_
  do
    local v_0_0
    local function get_buf_content0(start_row, start_col, end_row, end_col, bufnr)
      return vim.api.nvim_buf_get_lines(bufnr, start_row, (end_row + 1), false)
    end
    v_0_0 = get_buf_content0
    _0_["get-buf-content"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-buf-content"] = v_0_
  get_buf_content = v_0_
end
local get
do
  local v_0_
  do
    local v_0_0
    local function get0(path, tbl, default_3f)
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
    v_0_0 = get0
    _0_["get"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get"] = v_0_
  get = v_0_
end
local make_inverse_list
do
  local v_0_
  do
    local v_0_0
    local function make_inverse_list0(tbl)
      local result = {}
      for i, v in ipairs(tbl) do
        result[v] = i
      end
      return result
    end
    v_0_0 = make_inverse_list0
    _0_["make-inverse-list"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["make-inverse-list"] = v_0_
  make_inverse_list = v_0_
end
local get_all_truthy_keys
do
  local v_0_
  do
    local v_0_0
    local function get_all_truthy_keys0(tbl)
      local result = {}
      for k, v in pairs(tbl) do
        if v then
          table.insert(result, k)
        end
      end
      return result
    end
    v_0_0 = get_all_truthy_keys0
    _0_["get-all-truthy-keys"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-all-truthy-keys"] = v_0_
  get_all_truthy_keys = v_0_
end
local func_3f
do
  local v_0_
  do
    local v_0_0
    local function func_3f0(v)
      return (type(v) == "function")
    end
    v_0_0 = func_3f0
    _0_["func?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["func?"] = v_0_
  func_3f = v_0_
end
local method_3f
do
  local v_0_
  do
    local v_0_0
    local function method_3f0(v, key)
      return ((type(v) == "table") and (type(v[key]) == "function"))
    end
    v_0_0 = method_3f0
    _0_["method?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["method?"] = v_0_
  method_3f = v_0_
end
local highlight_marks
do
  local v_0_
  do
    local v_0_0
    local function highlight_marks0(marks, bufnr)
      for _, mark in ipairs(marks) do
        local line = (mark.line - 1)
        vim.highlight.range(bufnr, ns, "Visual", {line, mark.start}, {line, mark.stop})
      end
      return nil
    end
    v_0_0 = highlight_marks0
    _0_["highlight-marks"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["highlight-marks"] = v_0_
  highlight_marks = v_0_
end
return nil