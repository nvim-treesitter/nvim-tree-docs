local _0_0 = nil
do
  local name_0_ = "nvim-tree-docs.collector"
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
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _1_ = _2_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "nvim-tree-docs.collector"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local collector_metatable = nil
local function _3_(tbl, key)
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
collector_metatable = {__index = _3_}
local new_collector = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function new_collector0()
      return setmetatable({__entries = {}, __order = {}}, collector_metatable)
    end
    v_0_0 = new_collector0
    _0_0["new-collector"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["new-collector"] = v_0_
  new_collector = v_0_
end
local is_collector = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function is_collector0(value)
      return ((type(value) == "table") and (type(value.__entries) == "table"))
    end
    v_0_0 = is_collector0
    _0_0["is-collector"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["is-collector"] = v_0_
  is_collector = v_0_
end
local is_collector_empty = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function is_collector_empty0(collector)
      return (#collector.__order == 0)
    end
    v_0_0 = is_collector_empty0
    _0_0["is-collector-empty"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["is-collector-empty"] = v_0_
  is_collector_empty = v_0_
end
local iterate_collector = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function iterate_collector0(collector)
      local i = 1
      local function _4_()
        local id = collector.__order[i]
        if id then
          i = (i + 1)
          return {entry = collector.__entries[id], index = (i - 1)}
        else
          return nil
        end
      end
      return _4_
    end
    v_0_0 = iterate_collector0
    _0_0["iterate-collector"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["iterate-collector"] = v_0_
  iterate_collector = v_0_
end
local get_node_id = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function get_node_id0(node)
      local srow, scol, erow, ecol = node:range()
      return string.format("%d_%d_%d_%d", srow, scol, erow, ecol)
    end
    v_0_0 = get_node_id0
    _0_0["get-node-id"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["get-node-id"] = v_0_
  get_node_id = v_0_
end
local collect = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function collect0(collector, entry, _match, key, add_fn)
      if _match.definition then
        if not entry[key] then
          entry[key] = new_collector()
        end
        return add_fn(entry[key], key, _match, collect0)
      elseif not entry[key] then
        entry[key] = _match
        return nil
      elseif ((key == "start_point") and _match.node) then
        local _, _0, current_start = (entry[key].node):start()
        local _1, _2, new_start = (_match.node):start()
        if (new_start < current_start) then
          entry[key] = _match
          return nil
        end
      elseif ((key == "end_point") and _match.node) then
        local _, _0, current_end = (entry[key].node):end_()
        local _1, _2, new_end = (_match.node):end_()
        if (new_end > current_end) then
          entry[key] = _match
          return nil
        end
      end
    end
    v_0_0 = collect0
    _0_0["collect"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["collect"] = v_0_
  collect = v_0_
end
local add_match = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function add_match0(collector, kind, _match)
      if (_match and _match.definition) then
        local _def = _match.definition
        local def_node = _def.node
        local node_id = get_node_id(def_node)
        if not collector.__entries[node_id] then
          local order_index = 1
          local _, _0, def_start_byte = def_node:start()
          local done = false
          local i = 1
          while not done do
            local entry = collector.__entries[i]
            if not entry then
              done = true
            else
              local _1, _2, start_byte = (entry.defintion.node):start()
              if (def_start_byte < start_byte) then
                done = true
              else
                order_index = (order_index + 1)
              end
            end
          end
          table.insert(collector.__order, order_index, node_id)
          collector.__entries[node_id] = {definition = _def, kind = kind}
        end
        for key, submatch in pairs(_match) do
          if (key ~= "definition") then
            collect(collector, collector.__entries[node_id], submatch, key, add_match0)
          end
        end
        return nil
      end
    end
    v_0_0 = add_match0
    _0_0["add-match"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["add-match"] = v_0_
  add_match = v_0_
end
return nil