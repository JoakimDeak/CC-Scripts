local turtle = require("turtle")

function Place()
    for slot = 1, 16, 1 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)
            turtle.place()
            return
        end
    end
end

while true do
    if not turtle.detect() then
        Place()
    end
end
