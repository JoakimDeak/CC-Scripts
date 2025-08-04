-- setup:
-- generator input above
-- macerator input front
-- condenser output below
-- overflow input right
local turtle = require("turtle")

while true do
    repeat
        turtle.suckDown()
    until turtle.getItemCount(1) > 0

    if not turtle.drop() then
        if not turtle.dropUp() then
            turtle.turnRight()
            turtle.drop()
            turtle.turnLeft()
        end
    end
end
