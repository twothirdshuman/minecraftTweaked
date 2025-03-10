local function tableAsJson(t) 
    local result = {}

    for key, value in pairs(t) do
        -- prepare json key-value pairs and save them in separate table
        table.insert(result, string.format("\"%s\":%s", key, value))
    end

    -- get simple json string
    local ret = "{" .. table.concat(result, ",") .. "}"
    return ret
end

local function checkAndDoFuel() 
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel <= 1 then
        local result = turtle.refuel(1)
        if (result ~= true) then
            error("Out of fuel")
        end
    end
end

local function dig()
    checkAndDoFuel()
    turtle.dig()
end

local function up()
    checkAndDoFuel()
    turtle.up()
end

local function down()
    checkAndDoFuel()
    turtle.down()
end

local function forward()
    checkAndDoFuel()
    turtle.forward()
end

local function turnRight()
    checkAndDoFuel()
    turtle.turnRight()
end

local function turnLeft()
    checkAndDoFuel()
    turtle.turnLeft()
end

local function Break()
    local _hasBlock, data = turtle.inspect()
    dig()
    while (data["name"] == "minecraft:gravel") do 
        sleep(5)
        dig()
        _hasBlock, data = turtle.inspect()
    end
    -- print(tableAsJson(data))
end



local function Break3High() 
    
    local hasBlock, _data = turtle.inspectUp()
    if (hasBlock) then
        error("unexpected block")
    end
    Break()
    up()

    local hasBlock, _data = turtle.inspectUp()
    if (hasBlock) then
        error("unexpected block")
    end
    Break()
    up()
    Break()

    down()
    down()
end

while true do
    local blockForward = turtle.inspect()
    turnRight()
    local blockRight = turtle.inspect()
    turnRight()
    local blockBack = turtle.inspect()
    turnRight()
    local blockLeft = turtle.inspect()
    turnRight()
    if (blockLeft ~= true) then
        error("Not at edge")
    end

    if (blockForward == false) then
        turnLeft()
    end

    if (blockRight == true) then
        turnRight()
    end

    Break3High()
    forward()
    
end
