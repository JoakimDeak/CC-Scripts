local levels = {}
peripheral.find("modem", rednet.open)
local monitor = peripheral.wrap("top")

local function listen()
    local id, message = rednet.receive("storage-level")
    levels["id:" .. id] = {
        ["label"] = message.label,
        ["level"] = message.level
    }
end

local function display()
    monitor.clear()
    local i = 1
    for _, v in pairs(levels) do
        monitor.setTextColor(colors.white)
        monitor.setCursorPos(1, i)
        monitor.write(v.label)
        if v.level > 0 then
            monitor.setTextColor(colors.green)
            monitor.write("#")
        end
        if v.level > 3 then
            monitor.write("#")
        end
        if v.level > 6 then
            monitor.setTextColor(colors.orange)
            monitor.write("#")
        end
        if v.level > 8 then
            monitor.write("#")
        end
        if v.level > 11 then
            monitor.setTextColor(colors.red)
            monitor.write("#")
        end
        if v.level == 15 then
            monitor.write("#")
        end
        i = i + 1
    end
    sleep(60)
end

while true do
    parallel.waitForAny(listen, display)
end

