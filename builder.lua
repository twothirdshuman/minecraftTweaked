function errOnFalse(func)
    local res = func()
    if res == false then
        error("AAAA")
    end
end

function doLine()
    for x = 1, 10 do
        errOnFalse(turtle.back)
        errOnFalse(turtle.place)
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