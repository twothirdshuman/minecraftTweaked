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

local function getStone()
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

local function errOnFalse(func)
    local res = func()
    if res == false then
        error("AAAA")
    end
end

local function doAction(func) 
    getStone()
    errOnFalse(func)
end

local function r(count, func)
    for i = 1, count do
        func()
    end
end

local function back(count) 
    r(count, function ()
        doAction(turtle.back)
        doAction(turtle.place)
    end)
end

local function right(parity) 
    if parity == -1 then
        left(-parity)
    end
    turtle.turnRight()
end

local function left(parity) 
    if parity == -1 then
        right(-parity)
    end
    turtle.turnLeft()
end



local function hilbert_curve(A, parity, n) 
    if n < 1 then
        return
    end
    left(parity)
    hilbert_curve(A, - parity, n - 1)
    back(A)
    right(parity)
    hilbert_curve( A, parity, n - 1)
    back(A)
    hilbert_curve(A, parity, n - 1)
    right(parity)
    back(A)
    hilbert_curve(A, - parity, n - 1)
    left(parity)
end

hilbert_curve(4, 1, 2)