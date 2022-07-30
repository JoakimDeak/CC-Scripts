local turtle = {};
function turtle.dig()
    print("dig");
end
function turtle.digUp()
    print("digUp");
end
function turtle.detectDown()
    print("detectDown");
    local num = math.random() - 0.5;
    if num >= 0 then
        return true;
    else
        return false;
    end
end
function turtle.placeDown()
    print("placeDown");
end
function turtle.getItemDetail(slot)
    if slot > 16 then
        print("slot number " .. slot .. " out of range");
        return;
    end
    if slot == 3 then
        return {
            count = 9,
            name = "minecraft:cobblestone"
        }
    else
        return nil
    end
end
function turtle.getFuelLevel()
    print('fuel level is 80')
    return 80
end
function turtle.refuel(count)
    print('refueled ' .. count)
end
function turtle.select(slot)
    print('select slot ' .. slot)
end
function turtle.drop()
    print('dropping item')
end
function turtle.forward()
    print("forward");
end
function turtle.turnLeft()
    print("turnLeft");
end
function turtle.turnRight()
    print("turnRight");
end

return turtle
