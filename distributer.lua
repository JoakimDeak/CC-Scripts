local ratioA = 3
local ratioB = 320

local function getError()
    local file = fs.open("error", "r")
    if not file then
        return ratioA + ratioB
    end
    local error = tonumber(file.read())
    file.close()
    return error
end

local function setError(error)
    local file = fs.open("error", "w")
    file.write(error)
    file.close()
end

local function selectItem()
    for slot = 1, 16, 1 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)
            return true
        end
    end
    return false
end

local function main()
    if turtle.getItemCount() == 0 and not selectItem() then
        os.pullEvent("turtle_inventory")
    else
        local error = getError()
        error = error + ratioA
        if error >= ratioA + ratioB then
            turtle.dropUp(1)
            error = error - (ratioA + ratioB)
        else
            turtle.drop(1)
        end
        setError(error)
    end
end

while true do
    main()
end

