-- NapoleonHook.lua - FPS, Ping, and Region Display (Estimated)

local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatsDisplay"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 300, 0, 60)
StatsLabel.Position = UDim2.new(0, 10, 0, 10)
StatsLabel.BackgroundTransparency = 0.5
StatsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 14
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.Parent = ScreenGui

local fps = 60
local lastTime = tick()

local function getPing()
    local pingStats = StatsService:FindFirstChild("PerformanceStats")
    if pingStats then
        local ping = pingStats:FindFirstChild("Ping")
        if ping then
            return math.floor(ping:GetValue())
        end
    end
    return -1
end

local function guessRegion(ping)
    if ping == -1 then
        return "Unknown"
    elseif ping <= 70 then
        return "Asia (SG/JP)"
    elseif ping <= 150 then
        return "Europe"
    elseif ping <= 250 then
        return "US West/East"
    else
        return "Far Region"
    end
end

RunService.RenderStepped:Connect(function()
    local now = tick()
    fps = math.floor(1 / (now - lastTime))
    lastTime = now

    local ping = getPing()
    local regionGuess = guessRegion(ping)

    StatsLabel.Text = string.format("FPS: %d\nPing: %sms\nRegion: %s", fps, ping, regionGuess)
end)
