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
local eval_content = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_content0(context, content)
      local _type = type(content)
      if (_type == "string") then
        return content
      elseif (_type == "table") then
        local function _4_(_241, _242)
          local function _5_()
            if (_241 == "") then
              return ""
            else
              return " "
            end
          end
          return (_241 .. _5_() .. eval_content0(context, _242))
        end
        return core.reduce(_4_, "", content)
      elseif (_type == "function") then
        return eval_content0(context, content(context))
      else
        return ""
      end
    end
    v_0_0 = eval_content0
    _0_0["eval-content"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["eval-content"] = v_0_
  eval_content = v_0_
end
local new_template_context = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function new_template_context0()
      local context = {}
      return context
    end
    v_0_0 = new_template_context0
    _0_0["new-template-context"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["new-template-context"] = v_0_
  new_template_context = v_0_
end
local get_spec = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_spec0()
    end
    v_0_0 = get_spec0
    _0_0["get-spec"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-spec"] = v_0_
  get_spec = v_0_
end
return nil