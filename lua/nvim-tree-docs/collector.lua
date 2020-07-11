local Collector = {}

local default_type_defs = {
  ['function'] = {
    keys = {
      'root',
      'name',
      'return',
      'doc',
      { key = 'parameters', is_list = true },
    }
  },
  variable = {
    keys = { 'name', 'var_type', 'initial_value', 'doc' }
  },
  method = {
    keys = {
      'root',
      'name',
      'return',
      'doc',
      'class',
      'visibility',
      { key = 'parameters', is_list = true },
    }
  },
  class = {
    keys = {
      'doc',
      'root',
      'name',
      { key = 'extensions', is_list = true },
      { key = 'implementations', is_list = true }
    }
  },
  member = {
    keys = {
      'root',
      'class',
      'doc',
      'name',
      'visibility',
      'member_type'
    }
  }
}

local function get_node_id(node)
  local start_row, start_col, end_row, end_column = node:range()

  return string.format([[%d_%d_%d_%d]], start_row, start_col, end_row, end_column)
end

function Collector:add(type, match)
  if not match then return end

  local type_def = self.type_defs[type] or {}
  local key_defs = type_def.keys or {}
  local def = match.definition

  if not def then return end

  local def_node = def.node
  local id = get_node_id(def_node)

  if not self:get(id) then
    self.items[id] = {
      type = type,
      definition = def
    }
  end

  for _, key in ipairs(key_defs) do
    self:collect(id, match, key)
  end
end

function Collector:get(id)
  return self.items[id]
end

function Collector.new(type_defs)
  local instance = {
    type_defs = vim.tbl_extend('force', default_type_defs, type_defs or {}),
    items = {},
    lists = {}
  }

  setmetatable(instance, { __index = Collector })

  return instance
end

function Collector:collect_all(matches)
  for _, match in ipairs(matches) do
    for type, _ in pairs(self.type_defs) do
      self:add(type, match[type])
    end
  end

  self:sort()
end

function Collector:get_items()
  return self.items
end

function Collector:collect(id, match, key_def)
  if not self:get(id) then return end

  local entry = self.items[id]
  local is_list = false
  local key = key_def

  if type(key_def) == 'table' then
    is_list = key_def.is_list or false
    key = key_def.key
    sorter = key_def.sorter or Collector.sort_by_name_node_comp
  end

  if not key then return end

  if is_list then
    if type(entry[key]) ~= 'table' then
      entry[key] = {}
      -- Track lists so they can be sorted after collection
      table.insert(self.lists, { list = entry[key], sorter = sorter, nodes = {} })
    end

    -- Entries will be merged for lists with definition tags.
    if (match[key].definition) then
      local node_id = get_node_id(match[key].definition.node)
      local list_entry_for_node = nil

      for _, list_entry in ipairs(self.lists) do
        if list_entry.list == entry[key] then
          list_entry_for_node = list_entry
          break
        end
      end

      if list_entry_for_node then
        if vim.tbl_contains(list_entry_for_node.nodes, node_id) then
          return
        end

        table.insert(list_entry_for_node.nodes, node_id)
      end
    end

    table.insert(entry[key], match[key])
  elseif not entry[key] then
    entry[key] = match[key]
  end
end

function Collector:sort()
  for _, list_entry in ipairs(self.lists) do
    if type(list_entry.sorter) == 'function' then
      table.sort(list_entry.list, list_entry.sorter)
    end
  end
end

function Collector.sort_by_name_node_comp(a, b)
  if not a.name
    or not a.name.node
    or not b.name
    or not b.name.node then return false end

  local _, _, a_pos = a.name.node:start()
  local _, _, b_pos = b.name.node:start()

  return a_pos < b_pos
end

return Collector
