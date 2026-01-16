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
local function Break3High() 
    local has, _ = turtle.inspectUp()
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
end

-----------------------------------------------------
-- NEW MAIN LOOP: mines a 5-wide × 4-tall tunnel
-----------------------------------------------------

local TUNNEL_WIDTH = 5     -- left ↔ right
local TUNNEL_HEIGHT = 4    -- floor ↕ ceiling

while true do
    -- Dig one forward slice of the tunnel
    -- For width: move left→right, digging each column
    for col = 1, TUNNEL_WIDTH do
        -- Dig a full column (height)
        for h = 1, TUNNEL_HEIGHT do
            Break3High()
            if h < TUNNEL_HEIGHT then forward() end
        end

        -- Return to ground level at the start of this column
        for h = 1, (TUNNEL_HEIGHT - 1) do back() end

        -- Move to next column horizontally
        if col < TUNNEL_WIDTH then
            turnRight()
            Break()
            forward()
            turnLeft()
        end
    end

    -- Return horizontally to the left side
    for i = 1, (TUNNEL_WIDTH - 1) do
        turnLeft()
        back()
        turnRight()
    end

    -- Advance to the next slice forward
    forward()
end
