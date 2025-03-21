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

function r(count, func)
    for i = 1, count do
        func()
    end
end

function back(count) 
    r(count, function ()
        doAction(turtle.back)
        doAction(turtle.place)
    end)
end

function forward(count) 
    turtle.turnLeft()
    turtle.turnLeft()
    r(count, function ()
        doAction(turtle.back)
        doAction(turtle.place)
    end)
    turtle.turnLeft()
    turtle.turnLeft()
end

function right(count) 
    turtle.turnLeft()
    r(count, function ()
        doAction(turtle.back)
        doAction(turtle.place)
    end)
    turtle.turnRight()
end

function left(count) 
    turtle.turnRight()
    r(count, function ()
        doAction(turtle.back)
        doAction(turtle.place)
    end)
    turtle.turnLeft()
end

function down(count)
    r(count, function ()
        doAction(turtle.down)
        doAction(turtle.place)
    end)
end

function up(count)
    r(count, function ()
        doAction(turtle.down)
        doAction(turtle.place)
    end)
end

local funcs = {down, up, right, left, forward, back}

while true do
    local funcI = math.floor(math.random() * #funcs) + 1
    local times = math.ceil(math.random() * 15)
    if funcI == 0 then
        times = math.ceil(times / 2)
    end

    funcs[funcI](times)
end