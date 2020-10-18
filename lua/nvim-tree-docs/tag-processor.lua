local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.tag-processor"
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
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {require("aniseed.core")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {core = "aniseed.core"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _1_ = _2_(...)
local core = _1_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.tag-processor"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local iterate = nil
do
  local v_0_ = nil
  local function iterate0(tag_ps, context)
    local i = 1
    local function _3_()
      local tag = tag_ps.tags[i]
      local processor = nil
      if tag then
        processor = (processors[tag] or __fnl_global__default_2dprocessor)
      else
      processor = nil
      end
      if (tag and processor) then
        return {lines = processor(context, tag), tag = tag}
      else
        return nil
      end
    end
    return _3_
  end
  v_0_ = iterate0
  _0_0["aniseed/locals"]["iterate"] = v_0_
  iterate = v_0_
end
local to_lines = nil
do
  local v_0_ = nil
  local function to_lines0(tag_ps, context)
    local lines = {}
    for processed in iterate(tag_ps, context) do
      lines[processed.tag] = processed.lines
    end
    return lines
  end
  v_0_ = to_lines0
  _0_0["aniseed/locals"]["to-lines"] = v_0_
  to_lines = v_0_
end
local new = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function new0(processors, tag_config)
      local tags = nil
      do
        local res = {}
        for tag, included in pairs(tag_config) do
          if included then
            table.insert(res, tag)
          end
        end
        tags = res
      end
      local default_processor = processors.__default
      local tag_ps = {["default-processor"] = default_processor, tags = tags}
      local function _3_(...)
        return iterate(tag_ps, ...)
      end
      tag_ps.iterate = _3_
      tag_ps["to-lines"] = partian(iterate, tag_ps)
      return tag_ps
    end
    v_0_0 = new0
    _0_0["new"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["new"] = v_0_
  new = v_0_
end
return nil