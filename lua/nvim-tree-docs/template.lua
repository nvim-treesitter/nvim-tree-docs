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
    return {require("nvim-tree-docs.collector"), require("aniseed.core"), require("nvim-tree-docs.utils")}
  end
  ok_3f_0_, val_0_ = pcall(_3_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {collectors = "nvim-tree-docs.collector", core = "aniseed.core", utils = "nvim-tree-docs.utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _2_ = _3_(...)
local collectors = _2_[1]
local core = _2_[2]
local utils = _2_[3]
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
local mark = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function mark0(context, line, start_col, end_line, end_col, tag_3f)
      return table.insert(context.marks, {["end-col"] = end_col, ["end-line"] = end_line, ["line-offset"] = context["start-line"], ["start-col"] = start_col, line = line, tag = tag_3f})
    end
    v_0_0 = mark0
    _0_0["mark"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["mark"] = v_0_
  mark = v_0_
end
local eval_content = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_content0(context, content, ignore_col_3f)
      local _type = type(content)
      if (_type == "string") then
        return context["add-token"](content, ignore_col_3f)
      elseif (_type == "table") then
        for _, v in ipairs(content) do
          eval_content0(context, v, ignore_col_3f)
        end
        return nil
      elseif (_type == "function") then
        return eval_content0(context, content(context), ignore_col_3f)
      end
    end
    v_0_0 = eval_content0
    _0_0["eval-content"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["eval-content"] = v_0_
  eval_content = v_0_
end
local eval_and_mark = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_and_mark0(context, content, tag_3f)
      local line = context["head-ln"]
      local start_col = context["head-col"]
      eval_content(context, content)
      return mark(context, line, start_col, context["head-ln"], context["head-col"], tag_3f)
    end
    v_0_0 = eval_and_mark0
    _0_0["eval-and-mark"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["eval-and-mark"] = v_0_
  eval_and_mark = v_0_
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
        local function _4_()
          return nil
        end
        return _4_
      end
    end
    v_0_0 = iter0
    _0_0["iter"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["iter"] = v_0_
  iter = v_0_
end
local any = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function any0(matches)
      local function _4_(_241, _242)
        if _241 then
          return true
        else
          local is_collector = collectors["is-collector"](_242)
          return ((is_collector and not collectors["is-collector-empty"](_242)) or (not is_collector and _242))
        end
      end
      return core.reduce(_4_, false, matches)
    end
    v_0_0 = any0
    _0_0["any"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["any"] = v_0_
  any = v_0_
end
local has_tokens_at_line = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function has_tokens_at_line0(context, line)
      return (type(context.tokens[line]) == "table")
    end
    v_0_0 = has_tokens_at_line0
    _0_0["has-tokens-at-line"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["has-tokens-at-line"] = v_0_
  has_tokens_at_line = v_0_
end
local has_tokens_at_head = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function has_tokens_at_head0(context)
      return has_tokens_at_line(context, context["head-ln"])
    end
    v_0_0 = has_tokens_at_head0
    _0_0["has-tokens-at-head"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["has-tokens-at-head"] = v_0_
  has_tokens_at_head = v_0_
end
local add_token = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function add_token0(context, token, ignore_col_3f)
      if not has_tokens_at_head(context) then
        if ignore_col_3f then
          context.tokens[context["head-ln"]] = {}
        else
          add_token0(context, string.rep(" ", context["start-col"]), true)
        end
      end
      table.insert(context.tokens[context["head-ln"]], {col = context["head-col"], value = token})
      context["head-col"] = (context["head-col"] + #token)
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
      if has_tokens_at_head(context) then
        context["head-col"] = context["start-col"]
        context["head-ln"] = (context["head-ln"] + 1)
        return nil
      end
    end
    v_0_0 = next_line0
    _0_0["next-line"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["next-line"] = v_0_
  next_line = v_0_
end
local expand_content_lines = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function expand_content_lines0(context)
      local head = core.first(context.content)
      local rest = core.rest(context.content)
      if head then
        eval_content(context, head)
      end
      for _, line in ipairs(rest) do
        next_line(context)
        eval_content(context, line, true)
      end
      return nil
    end
    v_0_0 = expand_content_lines0
    _0_0["expand-content-lines"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["expand-content-lines"] = v_0_
  expand_content_lines = v_0_
end
local new_template_context = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function new_template_context0(collector, options_3f)
      local options = (options_3f or {})
      local context = vim.tbl_extend("keep", {["head-col"] = 0, ["head-ln"] = 1, ["start-col"] = (options["start-col"] or 0), ["start-line"] = (options["start-line"] or 1), bufnr = utils["get-bufnr"](options.bufnr), content = (options.content or {}), marks = {}, tokens = {}}, collector)
      context.iter = iter
      local function _4_(...)
        return get_text(context, ...)
      end
      context["get-text"] = _4_
      local function _5_(...)
        return eval_and_mark(context, ...)
      end
      context["eval-and-mark"] = _5_
      local function _6_(...)
        return eval_content(context, ...)
      end
      context["eval-content"] = _6_
      local function _7_(...)
        return mark(context, ...)
      end
      context.mark = _7_
      local function _8_(...)
        return next_line(context, ...)
      end
      context["next-line"] = _8_
      local function _9_(...)
        return expand_content_lines(context, ...)
      end
      context["expand-content-lines"] = _9_
      local function _10_(...)
        return add_token(context, ...)
      end
      context["add-token"] = _10_
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
      local key = (lang .. "_" .. spec)
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
local get_content_mark = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_content_mark0(context)
      local function _4_(_241, _242)
        return (_242.tag == "%content")
      end
      return core.some(_4_, context.marks)
    end
    v_0_0 = get_content_mark0
    _0_0["get-content-mark"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-content-mark"] = v_0_
  get_content_mark = v_0_
end
local execute_template = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function execute_template0(collector, template_fn, options_3f)
      local context = new_template_context(collector, options_3f)
      template_fn(context)
      return context
    end
    v_0_0 = execute_template0
    _0_0["execute-template"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["execute-template"] = v_0_
  execute_template = v_0_
end
local context_to_lines = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function context_to_lines0(context, col_3f)
      local col = (col_3f or 0)
      local function _4_(tokens)
        local function _5_(_241, _242)
          return (_241 .. _242.value)
        end
        return core.reduce(_5_, "", tokens)
      end
      return core.map(_4_, context.tokens)
    end
    v_0_0 = context_to_lines0
    _0_0["context-to-lines"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["context-to-lines"] = v_0_
  context_to_lines = v_0_
end
return nil