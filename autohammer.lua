-- setup:
-- cobble source behind
-- hammer input below
-- hammer output front
-- sieve input top
local turtle = require("turtle")

local STACK = 64

local gravelCount = 0
local sandCount = 0

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
        gravelCount = gravelCount + 1
        if gravelCount % 3 == 0 then
            gravelCount = 0
            OutputToSieve()
        else
            OutputToHammer()
        end
    elseif hammerOutput.name == "minecraft:sand" then
        sandCount = sandCount + 1
        if sandCount % 2 == 0 then
            sandCount = 0
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

GiveCobble()
while true do
    ProcessOutput()
end
