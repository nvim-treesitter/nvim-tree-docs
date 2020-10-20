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
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {require("nvim-tree-docs.collector"), require("aniseed.core"), require("nvim-tree-docs.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {collectors = "nvim-tree-docs.collector", core = "aniseed.core", utils = "nvim-tree-docs.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _1_ = _2_(...)
local collectors = _1_[1]
local core = _1_[2]
local utils = _1_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.template"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local ts_utils = require("nvim-treesitter.ts_utils")
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
local get_text = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_text0(context, node, default, multi)
      local default_value = (default or "")
      if (node and (type(node) == "table")) then
        local tsnode = nil
        if node.node then
          tsnode = node.node
        else
          tsnode = node
        end
        local lines = ts_utils.get_node_text(tsnode)
        if multi then
          return lines
        else
          local line = lines[1]
          if (line ~= "") then
            return line
          else
            return default_value
          end
        end
      else
        return default_value
      end
    end
    v_0_0 = get_text0
    _0_0["get-text"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-text"] = v_0_
  get_text = v_0_
end
local iter = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function iter0(collector)
      if collector then
        return collectors["iterate-collector"](collector)
      else
        local function _3_()
          return nil
        end
        return _3_
      end
    end
    v_0_0 = iter0
    _0_0["iter"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["iter"] = v_0_
  iter = v_0_
end
local conf = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function conf0(context, path, default_3f)
      return utils.get(path, context.config, default_3f)
    end
    v_0_0 = conf0
    _0_0["conf"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["conf"] = v_0_
  conf = v_0_
end
local empty_3f = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function empty_3f0(collector)
      return collectors["is-collector-empty"](collector)
    end
    v_0_0 = empty_3f0
    _0_0["empty?"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["empty?"] = v_0_
  empty_3f = v_0_
end
local new_template_context = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function new_template_context0(collector, options_3f)
      local options = (options_3f or {})
      local context = vim.tbl_extend("keep", {["empty?"] = empty_3f, ["start-col"] = (options["start-col"] or 0), ["start-line"] = (options["start-line"] or 0), bufnr = utils["get-bufnr"](options.bufnr), config = options.config, content = (options.content or {}), iter = iter, kind = options.kind}, collector)
      local function _3_(...)
        return get_text(context, ...)
      end
      context["get-text"] = _3_
      local function _4_(...)
        return conf(context, ...)
      end
      context.conf = _4_
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
    local function get_spec0(lang, spec)
      local key = (lang .. "." .. spec)
      if not loaded_specs[key] then
        require(string.format("nvim-tree-docs.specs.%s.%s", lang, spec))
      end
      return loaded_specs[key]
    end
    v_0_0 = get_spec0
    _0_0["get-spec"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-spec"] = v_0_
  get_spec = v_0_
end
local get_processor = nil
do
  local v_0_ = nil
  local function get_processor0(processors, name)
    return (processors[name] or processors.__default)
  end
  v_0_ = get_processor0
  _0_0["aniseed/locals"]["get-processor"] = v_0_
  get_processor = v_0_
end
local get_expanded_slots = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_expanded_slots0(ps_list, slot_config, processors)
      local filter_from_conf = nil
      local function _3_(_241)
        local ps = get_processor(processors, _241)
        return (ps and (ps.implicit or slot_config[_241]))
      end
      filter_from_conf = core.filter(_3_, ps_list)
      local result = {unpack(filter_from_conf)}
      local i = 1
      while (i <= #result) do
        local ps_name = result[i]
        local processor = get_processor(processors, ps_name)
        if (processor and processor.expand) then
          local expanded = processor.expand(utils["make-inverse-list"](result), slot_config)
          table.remove(result, i)
          for j, expanded_ps in ipairs(expanded) do
            table.insert(result, ((i + j) - 1), expanded_ps)
          end
        end
        i = (i + 1)
      end
      return result
    end
    v_0_0 = get_expanded_slots0
    _0_0["get-expanded-slots"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-expanded-slots"] = v_0_
  get_expanded_slots = v_0_
end
local get_filtered_slots = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_filtered_slots0(ps_list, processors, context)
      local function _3_(_241)
        local ps = get_processor(processors, _241)
        if utils["method?"](ps, "when") then
          return ps.when(context, ps_list)
        else
          return core["table?"](ps)
        end
      end
      return core.filter(_3_, ps_list)
    end
    v_0_0 = get_filtered_slots0
    _0_0["get-filtered-slots"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-filtered-slots"] = v_0_
  get_filtered_slots = v_0_
end
local normalize_build_output = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function normalize_build_output0(output)
      if core["string?"](output) then
        return {output}
      elseif core["table?"](output) then
        return output
      else
        return {}
      end
    end
    v_0_0 = normalize_build_output0
    _0_0["normalize-build-output"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["normalize-build-output"] = v_0_
  normalize_build_output = v_0_
end
local indent_with_processor = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function indent_with_processor0(lines, processor, context, ignore_first_3f)
      if utils["method?"](processor, "indent") then
        return processor.indent(lines, context)
      else
        local result = {}
        for i, line in ipairs(lines) do
          local function _3_()
            if ((i == 1) and ignore_first_3f) then
              return line
            else
              return (string.rep(" ", context["start-col"]) .. line)
            end
          end
          table.insert(result, _3_())
        end
        return result
      end
    end
    v_0_0 = indent_with_processor0
    _0_0["indent-with-processor"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["indent-with-processor"] = v_0_
  indent_with_processor = v_0_
end
local build_slots = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function build_slots0(ps_list, processors, context)
      local result = {}
      for i, ps_name in ipairs(ps_list) do
        local processor = get_processor(processors, ps_name)
        local default_processor = processors.__default
        local build_fn = nil
        local function _4_()
          local _3_0 = processor
          if _3_0 then
            return _3_0.build
          else
            return _3_0
          end
        end
        local function _6_()
          local _5_0 = default_processor
          if _5_0 then
            return _5_0.build
          else
            return _5_0
          end
        end
        build_fn = (_4_() or _6_())
        local function _7_()
          if utils["func?"](build_fn) then
            return indent_with_processor(normalize_build_output(build_fn(context, {index = i, name = ps_name, processors = ps_list})), processor, context, false)
          else
            return {}
          end
        end
        table.insert(result, _7_())
      end
      return result
    end
    v_0_0 = build_slots0
    _0_0["build-slots"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["build-slots"] = v_0_
  build_slots = v_0_
end
local output_to_lines = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function output_to_lines0(output)
      local function _3_(_241, _242)
        return vim.list_extend(_241, _242)
      end
      return core.reduce(_3_, {}, output)
    end
    v_0_0 = output_to_lines0
    _0_0["output-to-lines"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["output-to-lines"] = v_0_
  output_to_lines = v_0_
end
local post_process_output = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function post_process_output0(output, processors, context)
      return {lines = output_to_lines(output), marks = {}}
    end
    v_0_0 = post_process_output0
    _0_0["post-process-output"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["post-process-output"] = v_0_
  post_process_output = v_0_
end
local process_template = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function process_template0(collector, config)
      local _3_ = config
      local spec_conf = _3_["config"]
      local kind = _3_["kind"]
      local spec = _3_["spec"]
      local ps_list = spec.templates[kind]
      local processors = vim.tbl_extend("force", spec.processors, (spec_conf.processors or {}))
      local slot_config = nil
      local function _5_()
        local _4_0 = spec_conf.slots
        if _4_0 then
          return _4_0[kind]
        else
          return _4_0
        end
      end
      slot_config = (_5_() or {})
      local context = new_template_context(collector, config)
      return post_process_output(build_slots(get_filtered_slots(get_expanded_slots(spec.templates[kind], slot_config, processors), processors, context), processors, context), processors, context)
    end
    v_0_0 = process_template0
    _0_0["process-template"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["process-template"] = v_0_
  process_template = v_0_
end
local extend_spec = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function extend_spec0(mod, spec)
      if (spec and (mod.module ~= spec)) then
        require(("nvim-tree-docs.specs." .. spec))
        local inherited_spec = loaded_specs[spec]
        mod["templates"] = vim.tbl_extend("force", mod.templates, loaded_specs[spec].templates)
        mod["utils"] = vim.tbl_extend("force", mod.utils, loaded_specs[spec].utils)
        mod["inherits"] = inherited_spec
        mod["processors"] = vim.tbl_extend("force", mod.processors, inherited_spec.processors)
        mod["config"] = vim.tbl_deep_extend("force", inherited_spec.config, mod.config)
        return nil
      end
    end
    v_0_0 = extend_spec0
    _0_0["extend-spec"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["extend-spec"] = v_0_
  extend_spec = v_0_
end
return nil