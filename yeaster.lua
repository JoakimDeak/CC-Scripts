-- setup:
-- output chest below
-- redstone trigger for sugar dropper to the right
local turtle = require("turtle")

function DropSugar()
    redstone.setOutput("right", true)
    os.sleep(1 / 20)
    redstone.setOutput("right", false)
end

function MakeYeast()
    -- place water
    turtle.place()
    DropSugar()
    while true do
        local _, liquid = turtle.inspect()
        if liquid and liquid.name == "pneumaticcraft:yeast_culture" then
            -- scoop yeast
            turtle.place()
            turtle.dropDown()
            return
        end
    end
end

function Main()
    local item = turtle.getItemDetail(1)

    if item and item.name == "minecraft:water_bucket" then
        MakeYeast()
    else
        os.pullEvent("turtle_inventory");
    end
end

while true do
    Main()
end
