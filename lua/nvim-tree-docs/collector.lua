--- A collector is a special type of "list" that
-- keeps track of node results and merges entries
-- that share the same definition.
-- This provides us with the ability to match multiple
-- queries against the same "node".
local Collector = {}

local collector_metatable = {
  __index = function(tbl, key)
    --- Allow list lookups `collector[1]`
    if type(key) == 'number' then
      local id = tbl.__order[key]

      return id and tbl.__entries[id] or nil
    end

    -- Everything else falls to the collector table.
    return Collector[key]
  end
}

local function get_node_id(node)
  local start_row, start_col, end_row, end_column = node:range()

  return string.format([[%d_%d_%d_%d]], start_row, start_col, end_row, end_column)
end

function Collector:add(kind, match)
  if not match then return end

  local def = match.definition

  if not def then return end

  local def_node = def.node
  local node_id = get_node_id(def_node)

  if not self.__entries[node_id] then
    local order_index = 1
    local _, _, def_start_byte = def_node:start()

    for id, entry in pairs(self.__entries) do
      local _, _, start_byte = entry.definition.node:start()

      if def_start_byte < start_byte then
        break
      end

      order_index = order_index + 1
    end

    table.insert(self.__order, order_index, node_id)

    self.__entries[node_id] = {
      kind = kind,
      definition = def
    }
  end

  for key, submatch in pairs(match) do
    if key ~= 'definition' then
      self:collect(self.__entries[node_id], submatch, key)
    end
  end
end

function Collector:collect(entry, match, key)
  if match.definition then
    if not entry[key] then
      entry[key] = Collector.new()
    end

    entry[key]:add(key, match)
  elseif not entry[key] then
    entry[key] = match
  elseif key == 'root' and match.node then
    -- Always take the furthest root node
    local _, _, current_root = entry[key].node:start()
    local _, _, new_root = match.node:start()

    if new_root < current_root then
      entry[key] = match
    end
  end
end

function Collector:iterate()
  local i = 1

  return function()
    local id = self.__order[i]

    if not id then return nil end

    i = i + 1

    return i - 1, self.__entries[id]
  end
end

function Collector.new()
  local instance = {
    __entries = {},
    __order = {}
  }

  return setmetatable(instance, collector_metatable)
end

return Collector
