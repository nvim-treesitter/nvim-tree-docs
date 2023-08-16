local _2afile_2a = "fnl/nvim-tree-docs/internal.fnl"
local _2amodule_name_2a = "nvim-tree-docs.internal"
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
local collectors, configs, core, editing, queries, templates, ts_utils, utils = autoload("nvim-tree-docs.collector"), autoload("nvim-treesitter.configs"), autoload("nvim-tree-docs.aniseed.core"), autoload("nvim-tree-docs.editing"), autoload("nvim-treesitter.query"), autoload("nvim-tree-docs.template"), autoload("nvim-treesitter.ts_utils"), autoload("nvim-tree-docs.utils")
do end (_2amodule_locals_2a)["collectors"] = collectors
_2amodule_locals_2a["configs"] = configs
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["editing"] = editing
_2amodule_locals_2a["queries"] = queries
_2amodule_locals_2a["templates"] = templates
_2amodule_locals_2a["ts-utils"] = ts_utils
_2amodule_locals_2a["utils"] = utils
local language_specs = {javascript = "jsdoc", lua = "luadoc", typescript = "tsdoc"}
_2amodule_locals_2a["language-specs"] = language_specs
local doc_cache = {}
_2amodule_locals_2a["doc-cache"] = doc_cache
local function get_spec_for_lang(lang)
  local spec = language_specs[lang]
  if not spec then
    error(string.format("No language spec configured for %s", lang))
  else
  end
  return spec
end
_2amodule_2a["get-spec-for-lang"] = get_spec_for_lang
local function get_spec_config(lang, spec)
  local spec_def = templates["get-spec"](lang, spec)
  local module_config = configs.get_module("tree_docs")
  local spec_default_config = spec_def.config
  local lang_config = utils.get({"lang_config", lang, spec}, module_config, {})
  local spec_config = utils.get({"spec_config", spec}, module_config, {})
  return vim.tbl_deep_extend("force", spec_default_config, spec_config, lang_config)
end
_2amodule_2a["get-spec-config"] = get_spec_config
local function get_spec_for_buf(bufnr_3f)
  local bufnr = (bufnr_3f or vim.api.nvim_get_current_buf())
  return get_spec_for_lang(vim.api.nvim_buf_get_option(bufnr, "ft"))
end
_2amodule_2a["get-spec-for-buf"] = get_spec_for_buf
local function generate_docs(data_list, bufnr_3f, lang_3f)
  local bufnr = utils["get-bufnr"](bufnr_3f)
  local lang = (lang_3f or vim.api.nvim_buf_get_option(bufnr, "ft"))
  local spec_name = get_spec_for_lang(lang)
  local spec = templates["get-spec"](lang, spec_name)
  local spec_config = get_spec_config(lang, spec_name)
  local edits = {}
  local marks = {}
  local function _2_(_241, _242)
    local _, _0, start_byte_a = utils["get-start-position"](_241)
    local _1, _2, start_byte_b = utils["get-start-position"](_242)
    return (start_byte_a < start_byte_b)
  end
  table.sort(data_list, _2_)
  local line_offset = 0
  for _, doc_data in ipairs(data_list) do
    local node_sr, node_sc = utils["get-start-position"](doc_data)
    local node_er, node_ec = utils["get-end-position"](doc_data)
    local content_lines = utils["get-buf-content"](node_sr, node_sc, node_er, node_ec, bufnr)
    local replaced_count = ((node_er + 1) - node_sr)
    local result = templates["process-template"](doc_data, {spec = spec, bufnr = bufnr, config = spec_config, ["start-line"] = (node_sr + line_offset), ["start-col"] = node_sc, kind = doc_data.kind, content = content_lines})
    table.insert(edits, {newText = (table.concat(result.content, "\n") .. "\n"), range = {start = {line = node_sr, character = 0}, ["end"] = {line = (node_er + 1), character = 0}}})
    vim.list_extend(marks, result.marks)
    line_offset = ((line_offset + #result.content) - replaced_count)
  end
  return vim.lsp.util.apply_text_edits(edits, bufnr, "utf-16")
end
_2amodule_2a["generate-docs"] = generate_docs
local function collect_docs(bufnr_3f)
  local bufnr = utils["get-bufnr"](bufnr_3f)
  if (utils.get({bufnr, "tick"}, doc_cache) == vim.api.nvim_buf_get_changedtick(bufnr)) then
    return utils.get({bufnr, "docs"}, doc_cache)
  else
    local collector = collectors["new-collector"]()
    local doc_matches = queries.collect_group_results(bufnr, "docs")
    for _, item in ipairs(doc_matches) do
      for kind, _match in pairs(item) do
        collectors["add-match"](collector, kind, _match)
      end
    end
    doc_cache[bufnr] = {tick = vim.api.nvim_buf_get_changedtick(bufnr), docs = collector}
    return collector
  end
end
_2amodule_2a["collect-docs"] = collect_docs
local function get_doc_data_for_node(node, bufnr_3f)
  local current = nil
  local last_start = nil
  local last_end = nil
  local doc_data = collect_docs(bufnr_3f)
  local _, _0, node_start = node:start()
  for iter_item in collectors["iterate-collector"](doc_data) do
    local is_more_specific = true
    local _let_4_ = iter_item
    local doc_def = _let_4_["entry"]
    local _1, _2, start = utils["get-start-position"](doc_def)
    local _3, _4, _end = utils["get-end-position"](doc_def)
    local is_in_range = ((node_start >= start) and (node_start < _end))
    if (last_start and last_end) then
      is_more_specific = ((start >= last_start) and (_end <= last_end))
    else
    end
    if (is_in_range and is_more_specific) then
      last_start = start
      last_end = _end
      current = doc_def
    else
    end
  end
  return current
end
_2amodule_2a["get-doc-data-for-node"] = get_doc_data_for_node
local function doc_node(node, bufnr_3f, lang_3f)
  if node then
    local doc_data = get_doc_data_for_node(node, bufnr_3f)
    return generate_docs({doc_data}, bufnr_3f, lang_3f)
  else
    return nil
  end
end
_2amodule_2a["doc-node"] = doc_node
local function doc_node_at_cursor()
  return doc_node(ts_utils.get_node_at_cursor())
end
_2amodule_2a["doc-node-at-cursor"] = doc_node_at_cursor
local function get_docs_from_position(args)
  local _let_8_ = args
  local start_line = _let_8_["start-line"]
  local end_line = _let_8_["end-line"]
  local position = _let_8_["position"]
  local inclusion_3f = _let_8_["inclusion"]
  local bufnr_3f = _let_8_["bufnr"]
  local is_edit_type_3f = (position == "edit")
  local doc_data = collect_docs(bufnr_3f)
  local result = {}
  for item in collectors["iterate-collector"](doc_data) do
    local _let_9_ = item
    local _def = _let_9_["entry"]
    local start_r
    if is_edit_type_3f then
      start_r = utils["get-edit-start-position"](_def)
    else
      start_r = utils["get-start-position"](_def)
    end
    local end_r
    if is_edit_type_3f then
      end_r = utils["get-edit-end-position"](_def)
    else
      end_r = utils["get-end-position"](_def)
    end
    local _12_
    if inclusion_3f then
      _12_ = ((start_line >= start_r) and (end_line <= end_r))
    else
      _12_ = ((start_r >= start_line) and (end_r <= end_line))
    end
    if _12_ then
      table.insert(result, _def)
    else
    end
  end
  return result
end
_2amodule_2a["get-docs-from-position"] = get_docs_from_position
local function get_docs_in_range(args)
  return get_docs_from_position(vim.tbl_extend("force", args, {position = nil, inclusion = false}))
end
_2amodule_2a["get-docs-in-range"] = get_docs_in_range
local function get_docs_at_range(args)
  return get_docs_from_position(vim.tbl_extend("force", args, {inclusion = true, position = "edit"}))
end
_2amodule_2a["get-docs-at-range"] = get_docs_at_range
local function get_docs_from_selection()
  local _, start, _0, _1 = unpack(vim.fn.getpos("'<"))
  local _2, _end, _3, _4 = unpack(vim.fn.getpos("'>"))
  return get_docs_in_range({["start-line"] = (start - 1), ["end-line"] = (_end - 1)})
end
_2amodule_2a["get-docs-from-selection"] = get_docs_from_selection
local function doc_all_in_range()
  return generate_docs(get_docs_from_selection())
end
_2amodule_2a["doc-all-in-range"] = doc_all_in_range
local function edit_doc_at_cursor()
  local _let_15_ = vim.api.nvim_win_get_cursor(0)
  local row = _let_15_[1]
  local doc_data = get_docs_at_range({["start-line"] = (row - 1), ["end-line"] = (row - 1)})
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.api.nvim_buf_get_option(bufnr, "ft")
  local spec_name = get_spec_for_lang(lang)
  local spec = templates["get-spec"](lang, spec_name)
  local doc_lang = spec["doc-lang"]
  local doc_entry
  do
    local _16_ = doc_data
    if (nil ~= _16_) then
      local _17_ = (_16_)[1]
      if (nil ~= _17_) then
        doc_entry = (_17_).doc
      else
        doc_entry = _17_
      end
    else
      doc_entry = _16_
    end
  end
  if (core["table?"](doc_entry) and doc_entry.node and doc_lang) then
    return editing["edit-doc"]({lang = lang, ["spec-name"] = spec_name, bufnr = bufnr, ["doc-lang"] = doc_lang, node = doc_entry.node})
  else
    return nil
  end
end
_2amodule_2a["edit-doc-at-cursor"] = edit_doc_at_cursor
local function attach(bufnr_3f)
  local bufnr = utils["get-bufnr"](bufnr_3f)
  local config = configs.get_module("tree_docs")
  for _fn, mapping in pairs(config.keymaps) do
    local mode = "n"
    if (_fn == "doc_all_in_range") then
      mode = "v"
    else
    end
    if mapping then
      vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, string.format(":lua require 'nvim-tree-docs.internal'.%s()<CR>", _fn), {silent = true})
    else
    end
  end
  return nil
end
_2amodule_2a["attach"] = attach
local function detach(bufnr_3f)
  local bufnr = utils["get-bufnr"](bufnr_3f)
  local config = configs.get_module("tree_docs")
  for _fn, mapping in pairs(config.keymaps) do
    local mode = "n"
    if (_fn == "doc_all_in_range") then
      mode = "v"
    else
    end
    if mapping then
      vim.api.nvim_buf_del_keymap(bufnr, mode, mapping)
    else
    end
  end
  return nil
end
_2amodule_2a["detach"] = detach
local doc_node_at_cursor0 = doc_node_at_cursor
_2amodule_2a["doc_node_at_cursor"] = doc_node_at_cursor0
local doc_node0 = doc_node
_2amodule_2a["doc_node"] = doc_node0
local doc_all_in_range0 = doc_all_in_range
_2amodule_2a["doc_all_in_range"] = doc_all_in_range0
local edit_doc_at_cursor0 = edit_doc_at_cursor
_2amodule_2a["edit_doc_at_cursor"] = edit_doc_at_cursor0
return _2amodule_2a