local config = {} -- my "table" stdlib

--- Merge all the given tables into a single one and return it.
function config.merge_all(...)
  local ret = {}
  for _, tbl in ipairs({...}) do
    for k, v in pairs(tbl) do
      ret[k] = v
    end
  end
  return ret
end

--- Deep clone the given table.
function config.deepclone(original)
  local clone = {}
  for k, v in pairs(original) do
    if type(v) == "table" then
      clone[k] = config.deepclone(v)
    else
      clone[k] = v
    end
  end
  return clone
end

local is_list = function(t)
  if type(t) ~= "table" then
    return false
  end
  -- a list has list indices, an object does not
  return ipairs(t)(t, 0) and true or false
end

--- Flatten the given list of (item or (list of (item or ...)) to a list of item.
-- (nested lists are supported)
function config.flatten_list(list)
  local flattened_list = {}
  for _, item in ipairs(list) do
    if is_list(item) then
      for _, sub_item in ipairs(config.flatten_list(item)) do
        table.insert(flattened_list, sub_item)
      end
    else
      table.insert(flattened_list, item)
    end
  end
  return flattened_list
end

return {
  config = config
}
