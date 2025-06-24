--// Shinjuku 1988 - Low FPS + Ping Helper //--
--// Improves performance and displays Ping + FPS //--

pcall(function()
    -- Terrain Removal
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace:FindFirstChildOfClass("Terrain"):Clear()
    end

    -- Remove Decals & Textures
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Reduce Particles and Trails
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Rate = 1
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Trail") then
            v.Lifetime = 0
        end
    end

    -- Lighting Optimization
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 1e9
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v:Destroy()
        end
    end

    -- Lower Rendering Quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- HUD Display
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PingFPSDisplay"

local TextLabel = Instance.new("TextLabel", ScreenGui)
TextLabel.Size = UDim2.new(0, 300, 0, 60)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.BackgroundTransparency = 0.5
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TextLabel.TextSize = 20
TextLabel.Font = Enum.Font.Code
TextLabel.Text = "Loading Ping/FPS..."

-- FPS + Ping Calculation
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local fps = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    fps = fps + 1
    if tick() - lastTime >= 1 then
        local pingValue = StatsService:FindFirstChild("PerformanceStats").Ping:GetValue()
        TextLabel.Text = string.format("FPS: %d | Ping: %d ms", fps, math.floor(pingValue))
        fps = 0
        lastTime = tick()
    end
end)
