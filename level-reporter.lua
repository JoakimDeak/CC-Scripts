if not fs.exists("label") then
    print("label: ")
    local label = read()
    local file = fs.open("label", "w")
    file.write(label:sub(1, 1))
    file.close()
end

local file = fs.open("label", "r")
local label = file.read()
file.close()

peripheral.find("modem", rednet.open)
while true do
    local level = redstone.getAnalogInput("back")
    rednet.broadcast({
        ["label"] = label,
        ["level"] = level
    }, "storage-level")
    sleep(60)
end
