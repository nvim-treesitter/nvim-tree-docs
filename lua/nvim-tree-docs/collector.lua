local Collector = {}
local CollectorEntry = {}

local function get_node_id(node)
  local start_row, start_col, end_row, end_column = node:range()

  return string.format([[%d_%d_%d_%d]], start_row, start_col, end_row, end_column)
end

function Collector:add(match, opts)
  if not match then return end

  local opts = opts or {}
  local list_keys = opts.list_keys or {}
  local extract_keys = opts.extract_keys or {}
  local type = opts.type
  local def = match.definition

  if not def then return end

  local def_node = def.node
  local id = get_node_id(def_node)

  if not self[id] then
    self[id] = {
      list_keys = list_keys,
      type = type,
      definition = def
    }
  end

  for _, key in ipairs(extract_keys) do
    self:collect(id, match, key)
  end
end

function Collector.new()
  local instance = {}

  setmetatable(instance, { __index = Collector })

  return instance
end

function Collector:collect(id, match, key)
  if not self[id] then return end

  local entry = self[id]

  if vim.tbl_contains(entry.list_keys, key) then
    if type(entry[key]) ~= 'table' then
      entry[key] = {}
    end

    table.insert(entry[key], match[key])
  elseif not entry[key] then
    entry[key] = match[key]
  end
end

return Collector
