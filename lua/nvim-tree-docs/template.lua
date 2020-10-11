local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.template"
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
    return {require("nvim-tree-docs.collector"), require("aniseed.core")}
  end
  ok_3f_0_, val_0_ = pcall(_3_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {collectors = "nvim-tree-docs.collector", core = "aniseed.core"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _2_ = _3_(...)
local collectors = _2_[1]
local core = _2_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.template"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local loaded_specs = nil
do
  local v_0_ = nil
  do
    local v_0_0 = {}
    _0_0["loaded-specs"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["loaded-specs"] = v_0_
  loaded_specs = v_0_
end
local mark = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function mark0(context, line, start_col, end_col)
      return table.insert(context.marks, {["end-col"] = end_col, ["start-col"] = start_col, line = line})
    end
    v_0_0 = mark0
    _0_0["mark"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["mark"] = v_0_
  mark = v_0_
end
local add_token = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function add_token0(context, token)
      if (type(context.tokens[context["head-ln"]]) ~= "table") then
        context.tokens[context["head-ln"]] = {}
      end
      table.insert(context.tokens[context["head-ln"]], {col = context["head-col"], value = token})
      context["last-token"] = token
      return nil
    end
    v_0_0 = add_token0
    _0_0["add-token"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["add-token"] = v_0_
  add_token = v_0_
end
local next_line = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function next_line0(context)
      context["head-col"] = 0
      context["head-ln"] = (context["head-ln"] + 1)
      return nil
    end
    v_0_0 = next_line0
    _0_0["next-line"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["next-line"] = v_0_
  next_line = v_0_
end
return nil