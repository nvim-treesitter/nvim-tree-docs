local _2afile_2a = "fnl/nvim-tree-docs/collector.fnl"
local _2amodule_name_2a = "nvim-tree-docs.collector"
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
local core = autoload("nvim-tree-docs.aniseed.core")
do end (_2amodule_locals_2a)["core"] = core
local collector_metatable
local function _1_(tbl, key)
  if (type(key) == "number") then
    local id = tbl.__order[key]
    if id then
      return tbl.__entries[id]
    else
      return nil
    end
  else
    return rawget(tbl, key)
  end
end
collector_metatable = {__index = _1_}
_2amodule_locals_2a["collector-metatable"] = collector_metatable
local function new_collector()
  return setmetatable({__entries = {}, __order = {}}, collector_metatable)
end
_2amodule_2a["new-collector"] = new_collector
local function is_collector(value)
  return ((type(value) == "table") and (type(value.__entries) == "table"))
end
_2amodule_2a["is-collector"] = is_collector
local function is_collector_empty(collector)
  return (#collector.__order == 0)
end
_2amodule_2a["is-collector-empty"] = is_collector_empty
local function iterate_collector(collector)
  local i = 1
  local function _4_()
    local id = collector.__order[i]
    if id then
      i = (i + 1)
      return {index = (i - 1), entry = collector.__entries[id]}
    else
      return nil
    end
  end
  return _4_
end
_2amodule_2a["iterate-collector"] = iterate_collector
local function get_node_id(node)
  local srow, scol, erow, ecol = node:range()
  return string.format("%d_%d_%d_%d", srow, scol, erow, ecol)
end
_2amodule_2a["get-node-id"] = get_node_id
local function collect_(collector, entry, _match, key, add_fn)
  if _match.definition then
    if not entry[key] then
      entry[key] = new_collector()
    else
    end
    return add_fn(entry[key], key, _match, collect_)
  elseif not entry[key] then
    entry[key] = _match
    return nil
  elseif ((key == "start_point") and _match.node) then
    local _, _0, current_start = (entry[key].node):start()
    local _1, _2, new_start = (_match.node):start()
    if (new_start < current_start) then
      entry[key] = _match
      return nil
    else
      return nil
    end
  elseif ((key == "end_point") and _match.node) then
    local _, _0, current_end = (entry[key].node):end_()
    local _1, _2, new_end = (_match.node):end_()
    if (new_end > current_end) then
      entry[key] = _match
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
_2amodule_2a["collect_"] = collect_
local function add_match(collector, kind, _match)
  if (_match and _match.definition) then
    local _def = _match.definition
    local def_node = _def.node
    local node_id = get_node_id(def_node)
    if not collector.__entries[node_id] then
      local order_index = 1
      local _, _0, def_start_byte = def_node:start()
      local entry_keys = core.keys(collector.__entries)
      local done = false
      local i = 1
      while not done do
        local entry
        do
          local _10_ = entry_keys[i]
          if (_10_ ~= nil) then
            entry = collector.__entries[_10_]
          else
            entry = _10_
          end
        end
        if not entry then
          done = true
        else
          local _1, _2, start_byte = (entry.definition.node):start()
          if (def_start_byte < start_byte) then
            done = true
          else
            order_index = (order_index + 1)
            i = (i + 1)
          end
        end
      end
      table.insert(collector.__order, order_index, node_id)
      do end (collector.__entries)[node_id] = {kind = kind, definition = _def}
    else
    end
    for key, submatch in pairs(_match) do
      if (key ~= "definition") then
        collect_(collector, collector.__entries[node_id], submatch, key, add_match)
      else
      end
    end
    return nil
  else
    return nil
  end
end
_2amodule_2a["add-match"] = add_match
return _2amodule_2a