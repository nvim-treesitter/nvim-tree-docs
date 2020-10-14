local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.utils"
  local loaded_0_ = package.loaded[name_0_]
  local module_0_ = nil
  if ("table" == type(loaded_0_)) then
    module_0_ = loaded_0_
  else
    module_0_ = {}
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = (module_0_["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = (module_0_["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _3_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _3_()
    return {require("aniseed.core")}
  end
  ok_3f_0_, val_0_ = pcall(_3_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {core = "aniseed.core"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _2_ = _3_(...)
local core = _2_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.utils"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local ns = nil
do
  local v_0_ = nil
  do
    local v_0_0 = vim.api.nvim_create_namespace("blorg")
    _0_0["ns"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["ns"] = v_0_
  ns = v_0_
end
local get_start_node = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_start_node0(entry)
      local function _5_()
        local _4_0 = entry
        if _4_0 then
          local _6_0 = _4_0.start_point
          if _6_0 then
            return _6_0.node
          else
            return _6_0
          end
        else
          return _4_0
        end
      end
      local function _7_()
        local _6_0 = entry
        if _6_0 then
          local _8_0 = _6_0.definition
          if _8_0 then
            return _8_0.node
          else
            return _8_0
          end
        else
          return _6_0
        end
      end
      return (_5_() or _7_())
    end
    v_0_0 = get_start_node0
    _0_0["get-start-node"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-start-node"] = v_0_
  get_start_node = v_0_
end
local get_end_node = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_end_node0(entry)
      local function _5_()
        local _4_0 = entry
        if _4_0 then
          local _6_0 = _4_0.end_point
          if _6_0 then
            return _6_0.node
          else
            return _6_0
          end
        else
          return _4_0
        end
      end
      local function _7_()
        local _6_0 = entry
        if _6_0 then
          local _8_0 = _6_0.definition
          if _8_0 then
            return _8_0.node
          else
            return _8_0
          end
        else
          return _6_0
        end
      end
      return (_5_() or _7_())
    end
    v_0_0 = get_end_node0
    _0_0["get-end-node"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-end-node"] = v_0_
  get_end_node = v_0_
end
local get_position = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_position0(key, default_position, entry)
      local explicit_entry = entry[key]
      local function _5_()
        if ((type(explicit_entry) == "table") and explicit_entry.node) then
          return {node = explicit_entry.node, position = (explicit_entry.position or default_position)}
        else
          return {node = entry.definition.node, position = default_position}
        end
      end
      local _4_ = _5_()
      local node = _4_["node"]
      local position = _4_["position"]
      if (position == "start") then
        return node:start()
      else
        return node:end_()
      end
    end
    v_0_0 = get_position0
    _0_0["get-position"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-position"] = v_0_
  get_position = v_0_
end
local get_start_position = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function _4_(...)
      return get_position("start_point", "start", ...)
    end
    v_0_0 = _4_
    _0_0["get-start-position"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-start-position"] = v_0_
  get_start_position = v_0_
end
local get_end_position = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function _4_(...)
      return get_position("end_point", "end", ...)
    end
    v_0_0 = _4_
    _0_0["get-end-position"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-end-position"] = v_0_
  get_end_position = v_0_
end
local get_bufnr = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_bufnr0(bufnr)
      return (bufnr or vim.api.nvim_get_current_buf())
    end
    v_0_0 = get_bufnr0
    _0_0["get-bufnr"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-bufnr"] = v_0_
  get_bufnr = v_0_
end
local get_buf_content = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_buf_content0(start_row, start_col, end_row, end_col, bufnr)
      local result = vim.api.nvim_buf_get_lines(bufnr, start_row, (end_row + 1), false)
      if (#result > 0) then
        if (start_col ~= 0) then
          result[1] = string.sub(result[1], (start_col + 1))
        end
        if (end_col ~= 0) then
          result[#result] = string.sub(result[#result], 1, (end_col + 1))
        end
      end
      return result
    end
    v_0_0 = get_buf_content0
    _0_0["get-buf-content"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-buf-content"] = v_0_
  get_buf_content = v_0_
end
local highlight_marks = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function highlight_marks0(marks, bufnr)
      for _, mark in ipairs(marks) do
        local start_line = ((mark.line - 1) + mark["line-offset"])
        local end_line = ((mark["end-line"] - 1) + mark["line-offset"])
        vim.highlight.range(bufnr, ns, "Visual", {start_line, mark["start-col"]}, {end_line, mark["end-col"]})
      end
      return nil
    end
    v_0_0 = highlight_marks0
    _0_0["highlight-marks"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["highlight-marks"] = v_0_
  highlight_marks = v_0_
end
return nil