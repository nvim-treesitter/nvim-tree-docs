local _2afile_2a = "fnl/nvim-tree-docs/template.fnl"
local _2amodule_name_2a = "nvim-tree-docs.template"
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
local collectors, core, ts_utils, utils = autoload("nvim-tree-docs.collector"), autoload("nvim-tree-docs.aniseed.core"), autoload("nvim-treesitter.ts_utils"), autoload("nvim-tree-docs.utils")
do end (_2amodule_locals_2a)["collectors"] = collectors
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["ts-utils"] = ts_utils
_2amodule_locals_2a["utils"] = utils
local loaded_specs = {}
_2amodule_2a["loaded-specs"] = loaded_specs
local function get_text(context, node, default, multi)
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
_2amodule_2a["get-text"] = get_text
local function iter(collector)
  if collector then
    return collectors["iterate-collector"](collector)
  else
    local function _6_()
      return nil
    end
    return _6_
  end
end
_2amodule_2a["iter"] = iter
local function conf(context, path, default_3f)
  return utils.get(path, context.config, default_3f)
end
_2amodule_2a["conf"] = conf
local function empty_3f(collector)
  return collectors["is-collector-empty"](collector)
end
_2amodule_2a["empty?"] = empty_3f
local function build_line(...)
  local result = {content = "", marks = {}}
  local add_content
  local function _8_(_241)
    result.content = (result.content .. _241)
    return nil
  end
  add_content = _8_
  for _, value in ipairs({...}) do
    if core["string?"](value) then
      add_content(value)
    elseif (core["table?"](value) and core["string?"](value.content)) then
      if value.mark then
        local start = #result.content
        add_content(value.content)
        table.insert(result.marks, {kind = value.mark, stop = (#value.content + start), start = start})
      else
        add_content(value.content)
      end
    else
    end
  end
  return result
end
_2amodule_2a["build-line"] = build_line
local function new_template_context(collector, options_3f)
  local options = (options_3f or {})
  local context = vim.tbl_extend("keep", {iter = iter, ["empty?"] = empty_3f, build = build_line, config = options.config, kind = options.kind, ["start-line"] = (options["start-line"] or 0), ["start-col"] = (options["start-col"] or 0), content = (options.content or {}), bufnr = utils["get-bufnr"](options.bufnr)}, collector)
  local function _11_(...)
    return get_text(context, ...)
  end
  context["get-text"] = _11_
  local function _12_(...)
    return conf(context, ...)
  end
  context.conf = _12_
  return context
end
_2amodule_2a["new-template-context"] = new_template_context
local function get_spec(lang, spec)
  local key = (lang .. "." .. spec)
  if not loaded_specs[key] then
    require(string.format("nvim-tree-docs.specs.%s.%s", lang, spec))
  else
  end
  return loaded_specs[key]
end
_2amodule_2a["get-spec"] = get_spec
local function normalize_processor(processor)
  if utils["func?"](processor) then
    return {build = processor}
  else
    return processor
  end
end
_2amodule_locals_2a["normalize-processor"] = normalize_processor
local function get_processor(processors, name, aliased_from_3f)
  local processor_config = processors[name]
  if core["string?"](processor_config) then
    return get_processor(processors, processor_config, (aliased_from_3f or name))
  else
    local result = normalize_processor((processor_config or processors.__default))
    return {processor = result, name = name, ["aliased-from"] = aliased_from_3f}
  end
end
_2amodule_locals_2a["get-processor"] = get_processor
local function get_expanded_slots(ps_list, slot_config, processors)
  local result = {unpack(ps_list)}
  local i = 1
  while (i <= #result) do
    local ps_name = result[i]
    local _let_16_ = get_processor(processors, ps_name)
    local processor = _let_16_["processor"]
    if (processor and processor.expand) then
      local expanded = processor.expand(utils["make-inverse-list"](result), slot_config)
      table.remove(result, i)
      for j, expanded_ps in ipairs(expanded) do
        table.insert(result, ((i + j) - 1), expanded_ps)
      end
    else
    end
    i = (i + 1)
  end
  return result
end
_2amodule_2a["get-expanded-slots"] = get_expanded_slots
local function get_filtered_slots(ps_list, processors, slot_config, context)
  local function _18_(_241)
    return (_241 ~= nil)
  end
  local function _19_(_241)
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
  local function _22_(_241)
    return (_241.processor and (_241.processor.implicit or slot_config[(_241["aliased-from"] or _241.name)]))
  end
  local function _23_(_241)
    return get_processor(processors, _241)
  end
  return core.filter(_18_, core.map(_19_, core.filter(_22_, core.map(_23_, ps_list))))
end
_2amodule_2a["get-filtered-slots"] = get_filtered_slots
local function normalize_build_output(output)
  if core["string?"](output) then
    return {{content = output, marks = {}}}
  elseif core["table?"](output) then
    if core["string?"](output.content) then
      return {output}
    else
      local function _24_(_241)
        if core["string?"](_241) then
          return {content = _241, marks = {}}
        else
          return _241
        end
      end
      return core.map(_24_, output)
    end
  else
    return nil
  end
end
_2amodule_2a["normalize-build-output"] = normalize_build_output
local function indent_lines(lines, indenter, context)
  local indentation_amount
  if utils["func?"](indenter) then
    indentation_amount = indenter(lines, context)
  else
    indentation_amount = context["start-col"]
  end
  local function _29_(line)
    local function _30_(_241)
      return vim.tbl_extend("force", _241, {start = (_241.start + indentation_amount), stop = (_241.stop + indentation_amount)})
    end
    return vim.tbl_extend("force", {}, {content = (string.rep(" ", indentation_amount) .. line.content), marks = core.map(_30_, line.marks)})
  end
  return core.map(_29_, lines)
end
_2amodule_2a["indent-lines"] = indent_lines
local function build_slots(ps_list, processors, context)
  local result = {}
  for i, ps_name in ipairs(ps_list) do
    local _let_31_ = get_processor(processors, ps_name)
    local processor = _let_31_["processor"]
    local default_processor = processors.__default
    local build_fn
    local function _32_()
      local _33_ = processor
      if (nil ~= _33_) then
        return (_33_).build
      else
        return _33_
      end
    end
    local function _35_()
      local _36_ = default_processor
      if (nil ~= _36_) then
        return (_36_).build
      else
        return _36_
      end
    end
    build_fn = (_32_() or _35_())
    local indent_fn
    local function _38_()
      local _39_ = processor
      if (nil ~= _39_) then
        return (_39_).indent
      else
        return _39_
      end
    end
    local function _41_()
      local _42_ = default_processor
      if (nil ~= _42_) then
        return (_42_).indent
      else
        return _42_
      end
    end
    indent_fn = (_38_() or _41_())
    local function _44_()
      if utils["func?"](build_fn) then
        return indent_lines(normalize_build_output(build_fn(context, {processors = ps_list, index = i, name = ps_name})), indent_fn, context)
      else
        return {}
      end
    end
    table.insert(result, _44_())
  end
  return result
end
_2amodule_2a["build-slots"] = build_slots
local function output_to_lines(output)
  local function _45_(_241, _242)
    return vim.list_extend(_241, _242)
  end
  return core.reduce(_45_, {}, output)
end
_2amodule_2a["output-to-lines"] = output_to_lines
local function package_build_output(output, context)
  local result = {content = {}, marks = {}}
  for i, entry in ipairs(output) do
    for j, line in ipairs(entry) do
      local lnum = (#result.content + 1)
      table.insert(result.content, line.content)
      local function _46_(_241)
        return vim.tbl_extend("force", {}, _241, {line = (lnum + (context["start-line"] or 0))})
      end
      vim.list_extend(result.marks, core.map(_46_, line.marks))
    end
  end
  return result
end
_2amodule_2a["package-build-output"] = package_build_output
local function process_template(collector, config)
  local _let_47_ = config
  local spec = _let_47_["spec"]
  local kind = _let_47_["kind"]
  local spec_conf = _let_47_["config"]
  local ps_list
  local function _48_()
    local _49_ = spec_conf
    if (nil ~= _49_) then
      local _50_ = (_49_).templates
      if (nil ~= _50_) then
        return (_50_)[kind]
      else
        return _50_
      end
    else
      return _49_
    end
  end
  ps_list = (_48_() or spec.templates[kind])
  local processors = vim.tbl_extend("force", spec.processors, (spec_conf.processors or {}))
  local slot_config
  local function _53_()
    local _54_ = spec_conf.slots
    if (nil ~= _54_) then
      return (_54_)[kind]
    else
      return _54_
    end
  end
  slot_config = (_53_() or {})
  local context = new_template_context(collector, config)
  return package_build_output(build_slots(get_filtered_slots(get_expanded_slots(ps_list, slot_config, processors), processors, slot_config, context), processors, context), context)
end
_2amodule_2a["process-template"] = process_template
local function extend_spec(mod, spec)
  if (spec and (mod.module ~= spec)) then
    require(("nvim-tree-docs.specs." .. spec))
    local inherited_spec = loaded_specs[spec]
    mod["templates"] = vim.tbl_extend("force", mod.templates, loaded_specs[spec].templates)
    do end (mod)["utils"] = vim.tbl_extend("force", mod.utils, loaded_specs[spec].utils)
    do end (mod)["inherits"] = inherited_spec
    mod["processors"] = vim.tbl_extend("force", mod.processors, inherited_spec.processors)
    do end (mod)["config"] = vim.tbl_deep_extend("force", inherited_spec.config, mod.config)
    return nil
  else
    return nil
  end
end
_2amodule_2a["extend-spec"] = extend_spec
return _2amodule_2a