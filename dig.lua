local turtle = require("turtle")

function Forward(times)
    for _ = 1, times, 1 do
        turtle.forward()
    end
end

function HasEmptySlot()
    for slot = 1, 16, 1 do
        local item = turtle.getItemDetail(slot)
        if not item then
            return true
        end
    end
    return false
end

function Unload(j, i, depth, width)
    if j % 2 == 0 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    Forward(j)
    turtle.turnLeft()
    local currentDepth
    if j % 2 == 0 then
        currentDepth = depth - i
    else
        currentDepth = i
    end
    currentDepth = currentDepth + 1
    Forward(currentDepth)
    EmptyInventory()
    turtle.turnLeft()
    turtle.turnLeft()
    Forward(currentDepth)
    turtle.turnRight()
    Forward(j - 1)
    if j % 2 == 0 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
end

function EmptyInventory()
    for slot = 1, 16, 1 do
        turtle.select(slot)
        turtle.drop()
    end
    turtle.select(1)
end

function Refuel(requiredCoal)
    local usedCoal = 0
    for slot = 1, 16, 1 do
        local item = turtle.getItemDetail(slot)
        if item then
            if item.name == "minecraft:coal" then
                turtle.select(slot)
                if item.count >= requiredCoal - usedCoal then
                    turtle.refuel(requiredCoal - usedCoal)
                    return
                else
                    usedCoal = usedCoal + item.count
                    turtle.refuel(item.count)
                end
            end
        end
    end
end

function HasEnoughFuel(depth, width)
    local returnMoves
    if width % 2 == 0 then
        returnMoves = width
    else
        returnMoves = width - 1 + depth
    end
    local totalMoves = returnMoves + depth * width
    local fuelLevel = turtle.getFuelLevel()
    if totalMoves > fuelLevel then
        local requiredCoal = math.ceil((totalMoves - fuelLevel) / 80)
        local storedCoal = 0
        for slot = 1, 16, 1 do
            local item = turtle.getItemDetail(slot)
            if item then
                if item.name == "minecraft:coal" then
                    storedCoal = storedCoal + item.count
                end
            end
        end
        if requiredCoal <= storedCoal then
            Refuel(requiredCoal)
            return true
        else
            print('An additional ' .. requiredCoal - storedCoal .. ' coal is required for this operation')
            return false
        end
    else
        return true
    end
end

function SelectFiller()
    local fillerMaterials = {"minecraft:cobblestone", "minecraft:cobbled_deepslate", "minecraft:dirt",
                             "minecraft:granite", "minecraft:tuff", "minecraft:andesite", "minecraft:diorite"};
    for slot = 1, 16, 1 do
        for j = 1, #fillerMaterials, 1 do
            local item = turtle.getItemDetail(slot)
            if item then
                if fillerMaterials[j] == item.name then
                    turtle.select(slot)
                    return true
                end
            end
        end
    end
    return false
end

function FixFloor()
end
function ForwardSafe()
    turtle.forward();
    local floorIsSolid = turtle.detectDown();
    if not floorIsSolid then
        local hasFiller = SelectFiller()
        if hasFiller then
            turtle.placeDown()
        end
    end
end

function Turn(turnDirection)
    if turnDirection == 1 then
        turtle.turnRight();
    else
        turtle.turnLeft();
    end
end

function Return(depth, width, turnDirection)
    if width % 2 == 0 then
        turtle.turnRight();
    else
        turtle.turnLeft();
    end
    Forward(width - 1)
    turtle.turnLeft();
    local movesRequired;
    if turnDirection == 1 then
        movesRequired = depth;
    else
        movesRequired = 1;
    end
    Forward(movesRequired)
    EmptyInventory()
    turtle.turnRight();
    turtle.turnRight();
end

function Excavate(depth, width)
    local turnDirection = 1;
    for j = 1, width, 1 do
        local actualDepth = depth;
        if j > 1 then
            actualDepth = depth - 1;
        end
        for i = 1, actualDepth, 1 do
            turtle.dig();
            ForwardSafe();
            turtle.digUp();
            if not HasEmptySlot() then
                Unload(j, i, actualDepth, width)
            end
        end
        if j == tonumber(width) then
            break
        end
        Turn(turnDirection);
        turtle.dig();
        ForwardSafe();
        turtle.digUp();
        Turn(turnDirection);
        turnDirection = turnDirection * (-1);
    end
    Return(depth, width, turnDirection);
end

if not arg[1] or (not arg[2]) then
    print("Dig <depth> <width>");
else
    if HasEnoughFuel(arg[1], arg[2]) then
        Excavate(arg[1], arg[2])
    end
end
