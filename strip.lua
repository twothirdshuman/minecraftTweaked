local function checkAndDoFuel() 
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel <= 1 then
        turtle.refuel(1)
    end
end

local toRepeat = {turtle.dig, turtle.up, turtle.dig, turtle.forward, turtle.dig, turtle.down}

for l = 0, 100 do
    checkAndDoFuel()
    toRepeat[(l % #toRepeat) + 1]()
end