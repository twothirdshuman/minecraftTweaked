local function checkAndDoFuel() 
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel <= 1 then
        local result = false
        local i = 0
        while (not result) do 
            result = turtle.refuel(1)
            if (result ~= true) then
                print("Out of fuel for "..(i / 12).." minutes")
                sleep(5)
            end
            i = i + 1
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

local function Break()
    while true do
        local hasBlock, data = turtle.inspect()
        if not hasBlock then
            break
        end

        dig()

        -- If the block is gravel, keep checking until it's gone
        while data.name == "minecraft:gravel" do
            sleep(0.5)  -- short delay so gravel has time to fall
            dig()
            hasBlock, data = turtle.inspect()
            if not hasBlock then
                break
            end
        end
    end
end


--- Coal grid
--- -----#----------#-----
--- -----#----------#-----
--- -----#----------#-----
--- -----#----------#-----
--- ----###--------###----
--- ######################
--- ----###--------###----
--- -----#----------#-----
--- -----#----------#-----
--- -----#----------#----- 
--- -----#----------#-----
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----   
--- ----###--------###----
--- ######################   
--- ----###--------###----   
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----   
--- -----#----------#-----   

--- -----#----- 
--- -----#-----
--- -----#-----
--- -----#-----
--- ----###----
--- ###########
--- ----###----
--- -----#-----
--- -----#-----
--- -----#----- 
--- -----#-----
--- -----#----- 
--- -----#-----
--- -----#-----
--- -----#-----
--- ----###----
--- ###########
--- ----###----
--- -----#-----
--- -----#-----
--- -----#----- 
--- -----#-----

local function doArm() 
    Break()
    forward()

    turnLeft()
    local hasBlock, data = turtle.inspect()
    if hasBlock then
        Break()
    end

    turnLeft()
    turnLeft()

    local hasBlock, data = turtle.inspect()
    if hasBlock then
        Break()
    end

    turnLeft()

    for i = 1, 8, 1 do
        Break()
        forward()
    end

    Break()
    forward()

    turnLeft()
    local hasBlock, data = turtle.inspect()
    if hasBlock then
        Break()
    end

    turnLeft()
    turnLeft()

    local hasBlock, data = turtle.inspect()
    if hasBlock then
        Break()
    end

    turnLeft()

    Break()
    forward()
end

local function fillingLogic(isBacking)
    -- if nothing go right
    -- if can't go right go forward
    -- if only one direction go there
    -- if all directions blocked go back

    local isForward, _ = turtle.inspect()
    turnRight() 
    local isRight, _ = turtle.inspect()

    if (isRight) then
        doArm()
        return
    end

    if (isForward) then
        turnLeft()
        doArm()
        return
    end

    turnLeft()
    turnLeft()
    local isLeft, _ = turtle.inspect()

    if (isLeft) then
        doArm()
        return
    end

    if (isBacking) then
        turnRight()
        doArm()
        fillingLogic(true)
        return
    end

    turnLeft()
    doArm()
    fillingLogic(true)
end

while (true) do
    fillingLogic(false)
end