local _2afile_2a = "fnl/nvim-tree-docs/template.fnl"
local _0_
do
  local name_0_ = "nvim-tree-docs.template"
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
    return {autoload("nvim-tree-docs.collector"), autoload("nvim-tree-docs.aniseed.core"), autoload("nvim-treesitter.ts_utils"), autoload("nvim-tree-docs.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_3_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {autoload = {["ts-utils"] = "nvim-treesitter.ts_utils", collectors = "nvim-tree-docs.collector", core = "nvim-tree-docs.aniseed.core", utils = "nvim-tree-docs.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _3_(...)
local collectors = _local_0_[1]
local core = _local_0_[2]
local ts_utils = _local_0_[3]
local utils = _local_0_[4]
local _2amodule_2a = _0_
local _2amodule_name_2a = "nvim-tree-docs.template"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local loaded_specs
do
  local v_0_
  do
    local v_0_0 = {}
    _0_["loaded-specs"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["loaded-specs"] = v_0_
  loaded_specs = v_0_
end
local get_text
do
  local v_0_
  do
    local v_0_0
    local function get_text0(context, node, default, multi)
      local default_value = (default or "")
      if (node and (type(node) == "table")) then
        local tsnode
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
    _0_["get-text"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-text"] = v_0_
  get_text = v_0_
end
local iter
do
  local v_0_
  do
    local v_0_0
    local function iter0(collector)
      if collector then
        return collectors["iterate-collector"](collector)
      else
        local function _4_()
          return nil
        end
        return _4_
      end
    end
    v_0_0 = iter0
    _0_["iter"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["iter"] = v_0_
  iter = v_0_
end
local conf
do
  local v_0_
  do
    local v_0_0
    local function conf0(context, path, default_3f)
      return utils.get(path, context.config, default_3f)
    end
    v_0_0 = conf0
    _0_["conf"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["conf"] = v_0_
  conf = v_0_
end
local empty_3f
do
  local v_0_
  do
    local v_0_0
    local function empty_3f0(collector)
      return collectors["is-collector-empty"](collector)
    end
    v_0_0 = empty_3f0
    _0_["empty?"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["empty?"] = v_0_
  empty_3f = v_0_
end
local build_line
do
  local v_0_
  do
    local v_0_0
    local function build_line0(...)
      local result = {content = "", marks = {}}
      local add_content
      local function _4_(_241)
        result.content = (result.content .. _241)
        return nil
      end
      add_content = _4_
      for _, value in ipairs({...}) do
        if core["string?"](value) then
          add_content(value)
        elseif (core["table?"](value) and core["string?"](value.content)) then
          if value.mark then
            local start = #result.content
            add_content(value.content)
            table.insert(result.marks, {kind = value.mark, start = start, stop = (#value.content + start)})
          else
            add_content(value.content)
          end
        end
      end
      return result
    end
    v_0_0 = build_line0
    _0_["build-line"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["build-line"] = v_0_
  build_line = v_0_
end
local new_template_context
do
  local v_0_
  do
    local v_0_0
    local function new_template_context0(collector, options_3f)
      local options = (options_3f or {})
      local context = vim.tbl_extend("keep", {["empty?"] = empty_3f, ["start-col"] = (options["start-col"] or 0), ["start-line"] = (options["start-line"] or 0), bufnr = utils["get-bufnr"](options.bufnr), build = build_line, config = options.config, content = (options.content or {}), iter = iter, kind = options.kind}, collector)
      local function _4_(...)
        return get_text(context, ...)
      end
      context["get-text"] = _4_
      local function _5_(...)
        return conf(context, ...)
      end
      context.conf = _5_
      return context
    end
    v_0_0 = new_template_context0
    _0_["new-template-context"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["new-template-context"] = v_0_
  new_template_context = v_0_
end
local get_spec
do
  local v_0_
  do
    local v_0_0
    local function get_spec0(lang, spec)
      local key = (lang .. "." .. spec)
      if not loaded_specs[key] then
        require(string.format("nvim-tree-docs.specs.%s.%s", lang, spec))
      end
      return loaded_specs[key]
    end
    v_0_0 = get_spec0
    _0_["get-spec"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-spec"] = v_0_
  get_spec = v_0_
end
local normalize_processor
do
  local v_0_
  local function normalize_processor0(processor)
    if utils["func?"](processor) then
      return {build = processor}
    else
      return processor
    end
  end
  v_0_ = normalize_processor0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["normalize-processor"] = v_0_
  normalize_processor = v_0_
end
local get_processor
do
  local v_0_
  local function get_processor0(processors, name, aliased_from_3f)
    local processor_config = processors[name]
    if core["string?"](processor_config) then
      return get_processor0(processors, processor_config, (aliased_from_3f or name))
    else
      local result = normalize_processor((processor_config or processors.__default))
      return {["aliased-from"] = aliased_from_3f, name = name, processor = result}
    end
  end
  v_0_ = get_processor0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-processor"] = v_0_
  get_processor = v_0_
end
local get_expanded_slots
do
  local v_0_
  do
    local v_0_0
    local function get_expanded_slots0(ps_list, slot_config, processors)
      local result = {unpack(ps_list)}
      local i = 1
      while (i <= #result) do
        local ps_name = result[i]
        local _let_0_ = get_processor(processors, ps_name)
        local processor = _let_0_["processor"]
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
    _0_["get-expanded-slots"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-expanded-slots"] = v_0_
  get_expanded_slots = v_0_
end
local get_filtered_slots
do
  local v_0_
  do
    local v_0_0
    local function get_filtered_slots0(ps_list, processors, slot_config, context)
      local function _4_(_241)
        return (_241 ~= nil)
      end
      local function _5_(_241)
        local include_ps
        if utils["method?"](_241.processor, "when") then
          include_ps = _241.processor.when(context)
        else
          include_ps = core["table?"](_241.processor)
        end
        if include_ps then
          return _241.name
        else
          return nil
        end
      end
      local function _6_(_241)
        return (_241.processor and (_241.processor.implicit or slot_config[(_241["aliased-from"] or _241.name)]))
      end
      local function _7_(_241)
        return get_processor(processors, _241)
      end
      return core.filter(_4_, core.map(_5_, core.filter(_6_, core.map(_7_, ps_list))))
    end
    v_0_0 = get_filtered_slots0
    _0_["get-filtered-slots"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get-filtered-slots"] = v_0_
  get_filtered_slots = v_0_
end
local normalize_build_output
do
  local v_0_
  do
    local v_0_0
    local function normalize_build_output0(output)
      if core["string?"](output) then
        return {{content = output, marks = {}}}
      elseif core["table?"](output) then
        if core["string?"](output.content) then
          return {output}
        else
          local function _4_(_241)
            if core["string?"](_241) then
              return {content = _241, marks = {}}
            else
              return _241
            end
          end
          return core.map(_4_, output)
        end
      end
    end
    v_0_0 = normalize_build_output0
    _0_["normalize-build-output"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["normalize-build-output"] = v_0_
  normalize_build_output = v_0_
end
local indent_lines
do
  local v_0_
  do
    local v_0_0
    local function indent_lines0(lines, indenter, context)
      local indentation_amount
      if utils["func?"](indenter) then
        indentation_amount = indenter(lines, context)
      else
        indentation_amount = context["start-col"]
      end
      local function _5_(line)
        local function _6_(_241)
          return vim.tbl_extend("force", _241, {start = (_241.start + indentation_amount), stop = (_241.stop + indentation_amount)})
        end
        return vim.tbl_extend("force", {}, {content = (string.rep(" ", indentation_amount) .. line.content), marks = core.map(_6_, line.marks)})
      end
      return core.map(_5_, lines)
    end
    v_0_0 = indent_lines0
    _0_["indent-lines"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["indent-lines"] = v_0_
  indent_lines = v_0_
end
local build_slots
do
  local v_0_
  do
    local v_0_0
    local function build_slots0(ps_list, processors, context)
      local result = {}
      for i, ps_name in ipairs(ps_list) do
        local _let_0_ = get_processor(processors, ps_name)
        local processor = _let_0_["processor"]
        local default_processor = processors.__default
        local build_fn
        local _5_
        do
          local _4_ = processor
          if _4_ then
            _5_ = (_4_).build
          else
            _5_ = _4_
          end
        end
        local function _7_()
          local _6_ = default_processor
          if _6_ then
            return (_6_).build
          else
            return _6_
          end
        end
        build_fn = (_5_ or _7_())
        local indent_fn
        local _9_
        do
          local _8_ = processor
          if _8_ then
            _9_ = (_8_).indent
          else
            _9_ = _8_
          end
        end
        local function _11_()
          local _10_ = default_processor
          if _10_ then
            return (_10_).indent
          else
            return _10_
          end
        end
        indent_fn = (_9_ or _11_())
        local function _12_()
          if utils["func?"](build_fn) then
            return indent_lines(normalize_build_output(build_fn(context, {index = i, name = ps_name, processors = ps_list})), indent_fn, context)
          else
            return {}
          end
        end
        table.insert(result, _12_())
      end
      return result
    end
    v_0_0 = build_slots0
    _0_["build-slots"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["build-slots"] = v_0_
  build_slots = v_0_
end
local output_to_lines
do
  local v_0_
  do
    local v_0_0
    local function output_to_lines0(output)
      local function _4_(_241, _242)
        return vim.list_extend(_241, _242)
      end
      return core.reduce(_4_, {}, output)
    end
    v_0_0 = output_to_lines0
    _0_["output-to-lines"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["output-to-lines"] = v_0_
  output_to_lines = v_0_
end
local package_build_output
do
  local v_0_
  do
    local v_0_0
    local function package_build_output0(output, context)
      local result = {content = {}, marks = {}}
      for i, entry in ipairs(output) do
        for j, line in ipairs(entry) do
          local lnum = (#result.content + 1)
          table.insert(result.content, line.content)
          local function _4_(_241)
            return vim.tbl_extend("force", {}, _241, {line = (lnum + (context["start-line"] or 0))})
          end
          vim.list_extend(result.marks, core.map(_4_, line.marks))
        end
      end
      return result
    end
    v_0_0 = package_build_output0
    _0_["package-build-output"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["package-build-output"] = v_0_
  package_build_output = v_0_
end
local process_template
do
  local v_0_
  do
    local v_0_0
    local function process_template0(collector, config)
      local _let_0_ = config
      local spec_conf = _let_0_["config"]
      local kind = _let_0_["kind"]
      local spec = _let_0_["spec"]
      local ps_list
      local _5_
      do
        local _4_ = spec_conf
        if _4_ then
          local _6_ = (_4_).templates
          if _6_ then
            _5_ = (_6_)[kind]
          else
            _5_ = _6_
          end
        else
          _5_ = _4_
        end
      end
      ps_list = (_5_ or spec.templates[kind])
      local processors = vim.tbl_extend("force", spec.processors, (spec_conf.processors or {}))
      local slot_config
      local _7_
      do
        local _6_ = spec_conf.slots
        if _6_ then
          _7_ = (_6_)[kind]
        else
          _7_ = _6_
        end
      end
      slot_config = (_7_ or {})
      local context = new_template_context(collector, config)
      return package_build_output(build_slots(get_filtered_slots(get_expanded_slots(ps_list, slot_config, processors), processors, slot_config, context), processors, context), context)
    end
    v_0_0 = process_template0
    _0_["process-template"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["process-template"] = v_0_
  process_template = v_0_
end
local extend_spec
do
  local v_0_
  do
    local v_0_0
    local function extend_spec0(mod, spec)
      if (spec and (mod.module ~= spec)) then
        require(("nvim-tree-docs.specs." .. spec))
        local inherited_spec = loaded_specs[spec]
        mod["templates"] = vim.tbl_extend("force", mod.templates, loaded_specs[spec].templates)
        do end (mod)["utils"] = vim.tbl_extend("force", mod.utils, loaded_specs[spec].utils)
        do end (mod)["inherits"] = inherited_spec
        mod["processors"] = vim.tbl_extend("force", mod.processors, inherited_spec.processors)
        do end (mod)["config"] = vim.tbl_deep_extend("force", inherited_spec.config, mod.config)
        return nil
      end
    end
    v_0_0 = extend_spec0
    _0_["extend-spec"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["extend-spec"] = v_0_
  extend_spec = v_0_
end
return nil