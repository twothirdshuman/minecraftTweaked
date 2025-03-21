local MAX_ITEM_SLOT = 1
while true do
    local status, err = pcall(function ()
        turtle.getItemDetail(MAX_ITEM_SLOT)
    end)
    if err ~= nil then
        MAX_ITEM_SLOT = MAX_ITEM_SLOT - 1
        break
    end
    MAX_ITEM_SLOT = MAX_ITEM_SLOT + 1
end

function doAction(func) 
    getStone()
    errOnFalse(func)
end

function errOnFalse(func)
    local res = func()
    if res == false then
        error("AAAA")
    end
end

function getStone()
    local block = turtle.getItemDetail()
    if block ~= nil then
        return
    end

    local hasStone = 0
    for i = 1, MAX_ITEM_SLOT do
        (function ()
            local b = turtle.getItemDetail(i)
    
            if b == nil then
                return
            end
    
            local name = b["name"]
            if string.find(name, "stone") then
                hasStone = i
            end
        end)()
    end

    if hasStone == 0 then
        error("could not find stone")
    end

    turtle.select(hasStone)
    turtle.transferTo(1, 64)
    turtle.select(1)
end

function doLine()
    for x = 1, 10 do
        doAction(turtle.back)
        doAction(turtle.place)
    end
end

function turn()
    turtle.turnRight()
    local has_bloc, _data = turtle.inspect()
    if (has_bloc) then
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
        return
    end
    turtle.forward()
    turtle.turnRight()
end

local blocks = {}

for layer = 1, 10, 1 do
    for x = 1, 10, 1 do
        doLine()
        turn()
    end
    turtle.up()
end

local startpos = {0, 0, 0}