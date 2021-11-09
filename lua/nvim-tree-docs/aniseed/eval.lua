local _2afile_2a = "fnl/aniseed/eval.fnl"
local _0_
do
  local name_0_ = "nvim-tree-docs.aniseed.eval"
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
local function _1_(...)
  return (require("nvim-tree-docs.aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {autoload("nvim-tree-docs.aniseed.core"), autoload("nvim-tree-docs.aniseed.compile"), autoload("nvim-tree-docs.aniseed.fennel"), autoload("nvim-tree-docs.aniseed.fs"), autoload("nvim-tree-docs.aniseed.nvim")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {autoload = {a = "nvim-tree-docs.aniseed.core", compile = "nvim-tree-docs.aniseed.compile", fennel = "nvim-tree-docs.aniseed.fennel", fs = "nvim-tree-docs.aniseed.fs", nvim = "nvim-tree-docs.aniseed.nvim"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local a = _local_0_[1]
local compile = _local_0_[2]
local fennel = _local_0_[3]
local fs = _local_0_[4]
local nvim = _local_0_[5]
local _2amodule_2a = _0_
local _2amodule_name_2a = "nvim-tree-docs.aniseed.eval"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local str
do
  local v_0_
  do
    local v_0_0
    local function str0(code, opts)
      local fnl = fennel.impl()
      local function _3_()
        return fnl.eval(compile["macros-prefix"](code, opts), a.merge({["compiler-env"] = _G}, opts))
      end
      return xpcall(_3_, fnl.traceback)
    end
    v_0_0 = str0
    _0_["str"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["str"] = v_0_
  str = v_0_
end
return nil
