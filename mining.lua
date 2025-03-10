local function tableAsJson(t) 
    local result

    for key, value in ipairs(t) do
        -- prepare json key-value pairs and save them in separate table
        table.insert(result, string.format("\"%s\":%s", key, value))
    end

    -- get simple json string
    result = "{" .. table.concat(result, ",") .. "}"
    return result
end

local function checkAndDoFuel() 
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel <= 1 then
        turtle.refuel(1)
    end
end

local function Break()
    local hasBlock, data = turtle.inspect()
    print(tableAsJson(data))
end

--[[
    local toRepeat = {turtle.dig, turtle.up, turtle.dig, turtle.forward, 
    turtle.dig, turtle.down, turtle.dig, turtle.forward}
    
    for l = 0, 100 do
        checkAndDoFuel()
        toRepeat[(l % #toRepeat) + 1]()
    end
]]

Break()