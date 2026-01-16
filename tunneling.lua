local function tableAsJson(t) 
    local result = {}
    for key, value in pairs(t) do
        table.insert(result, string.format("\"%s\":%s", key, value))
    end
    return "{" .. table.concat(result, ",") .. "}"
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

local function back()
    checkAndDoFuel()
    turtle.back()
end

-- Break 1 block, handling gravel
local function Break()
    local _has, data = turtle.inspect()
    dig()
    while (data["name"] == "minecraft:gravel") do 
        sleep(5)
        dig()
        _has, data = turtle.inspect()
    end
end

-- Break a 3-high vertical section
local function Break4High() 
    local has, _ = turtle.inspectUp()
    if has then error("unexpected block") end
    Break()
    up()

    has, _ = turtle.inspectUp()
    if has then error("unexpected block") end
    Break()
    up()

    has, _ = turtle.inspectUp()
    if has then error("unexpected block") end
    Break()
    up()

    Break()

    down()
    down()
    down()
end

-----------------------------------------------------
-- NEW MAIN LOOP: mines a 5-wide × 4-tall tunnel
-----------------------------------------------------

local TUNNEL_WIDTH = 5     -- left ↔ right
local TUNNEL_HEIGHT = 4    -- floor ↕ ceiling

while true do
    -- Dig one forward slice of the tunnel
    -- For width: move left→right, digging each column

    Break4High()
    turnRight()
    forward()
    turnLeft()

    Break4High()
    turnRight()
    forward()
    turnLeft()

    Break4High()
    turnRight()
    forward()
    turnLeft()

    Break4High()
    turnRight()
    forward()
    turnLeft()

    Break4High()
    
    forward()
    turnLeft()
    forward()
    forward()
    forward()
    forward()
    turnRight()
end
