local Collector = {}

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
    type_defs = type_defs or {},
    items = {}
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
  end

  if not key then return end

  if is_list then
    if type(entry[key]) ~= 'table' then
      entry[key] = {}
    end

    table.insert(entry[key], match[key])
  elseif not entry[key] then
    entry[key] = match[key]
  end
end

return Collector
