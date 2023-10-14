-- setup:
-- cobble source behind
-- hammer input below
-- hammer output front
-- sieve input top
local turtle = require("turtle")

local STACK = 64

function GetSandCount()
    local file = fs.open("sandCount", "r")
    local count = tonumber(file.read())
    file.close()
    return count
end
function SetSandCount(count)
    local file = fs.open("sandCount", "w")
    file.write(count)
    file.close()
end

function GetGravelCount()
    local file = fs.open("gravelCount", "r")
    local count = tonumber(file.read())
    file.close()
    return count
end
function SetGravelCount(count)
    local file = fs.open("gravelCount", "w")
    file.write(count)
    file.close()
end

function RefillCobble()
    turtle.turnRight()
    turtle.turnRight()
    for slot = 2, 16, 1 do
        turtle.select(slot)
        turtle.suck(STACK)
    end
    turtle.turnRight()
    turtle.turnRight()
    turtle.select(1)
end

function GiveCobble()
    for slot = 2, 16, 1 do
        local item = turtle.getItemDetail(slot)
        if item then
            turtle.select(slot)
            turtle.dropDown()
            turtle.select(1)
            return
        end
    end
    RefillCobble()
    GiveCobble()
end

function SuckHammerOutput()
    turtle.select(1)
    while turtle.getItemCount(1) < 64 do
        turtle.suck()
    end
end

function OutputToSieve()
    turtle.select(1)
    turtle.dropUp()
    GiveCobble()
end

function OutputToHammer()
    turtle.select(1)
    turtle.dropDown()
end

function ProcessOutput()
    SuckHammerOutput()
    local hammerOutput = turtle.getItemDetail(1)

    if not hammerOutput then
        print("ProcessOutput failed due to nil item")
        return
    end

    if hammerOutput.name == "minecraft:gravel" then
        local gravelCount = GetGravelCount()
        SetGravelCount(gravelCount + 1)
        if (gravelCount + 1) % 3 == 0 then
            SetGravelCount(0)
            OutputToSieve()
        else
            OutputToHammer()
        end
    elseif hammerOutput.name == "minecraft:sand" then
        local sandCount = GetSandCount()
        SetSandCount(sandCount + 1)
        if (sandCount + 1) % 2 == 0 then
            SetSandCount(0)
            OutputToSieve()
        else
            OutputToHammer()
        end
    elseif hammerOutput.name == "exnihilosequentia:dust" then
        OutputToSieve()
    else
        print("Unexpected hammer output")
    end
end

turtle.select(1)
turtle.suck(STACK)
if not turtle.getItemDetail(1) then
    GiveCobble()
end
while true do
    ProcessOutput()
end
