
--[[
    data{
        parents[]
        table{}
        name
        data
    }
]]
local states = {}

states.value = function(c, data)
    if c == " " or c == "," or c == "=" then
        return states.value
    elseif c == '"' then
        data.name = data.name or #data.table + 1
        data.data = ""
        return states.close_string
    -- elseif c == "," then
        -- data.table[data.name] = data.data
    elseif c == '{' then
        table.insert(data.parents, {table = data.table, name = data.name or #data.table + 1})
        data.table = {}
        data.name = nil
        return states.value
    elseif c == '}' then
        local parent = table.remove(data.parents)
        parent.table[parent.name] = data.table
        data.table = parent.table
        return states.value
    end

    data.name = c
    return states.name
end

states.name = function(c, data)
    if c == " " or c == "=" then
        return states.value
    end

    data.name = data.name .. c
    return states.name
end

states.close_string = function (c, data)
    if c == '"' then
        data.table[data.name] = data.data
        data.name = nil
        data.data = nil
        return states.value
    end

    data.data = data.data .. c
    return states.close_string
end


---@param str string
---@return table
function into_table(str)
    local state = states.value
    local data = {parents = {}, table={}}

    for c in str:gmatch(".") do
        state = state(c, data)
    end

    return data.table[1] or {}
end

-- local function dump(o)
--     if type(o) == 'table' then
--         local s = '{ '
--         for k,v in pairs(o) do
--             if type(k) ~= 'number' then k = '"'..k..'"' end
--             s = s .. '['..k..'] = ' .. dump(v) .. ','
--         end
--         return s .. '} '
--     else
--         return tostring(o)
--     end
-- end
 

-- print(dump(into_table('{{u = "hello"}}')))