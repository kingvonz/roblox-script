--// Low FPS + Ping Helper (Shinjuku 1988 Style) //--
-- Warning: Cannot actually change ping or FPS directly, but can reduce resource load.

pcall(function()
    -- Remove Terrain
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace:FindFirstChildOfClass("Terrain"):Clear()
    end

    -- Remove All Decals
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end

    -- Lower Particle Count
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Rate = 1
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Trail") then
            v.Lifetime = 0
        end
    end

    -- Disable Shadows on Lighting
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9 -- no fog

    -- Lower Quality Materials
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 -- Low

    -- Remove Post Effects
    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("PostEffect") then
            v:Destroy()
        end
    end

    -- Reduce Network Traffic: Stop Streaming
    if game:GetService("Workspace"):FindFirstChildOfClass("StreamingEnabled") then
        game:GetService("Workspace").StreamingEnabled = false
    end

    -- Optionally: Reduce humanoid states that eat network updates
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") then
            v:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            v:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            v.BreakJointsOnDeath = false
        end
    end
end)

-- Ping Display (Optional)
local Stats = Instance.new("TextLabel", game:GetService("CoreGui"))
Stats.Text = "Ping: Calculating..."
Stats.Size = UDim2.new(0, 200, 0, 50)
Stats.Position = UDim2.new(0, 10, 0, 10)
Stats.BackgroundTransparency = 0.5
Stats.BackgroundColor3 = Color3.new(0,0,0)
Stats.TextColor3 = Color3.new(0,255,0)
Stats.TextSize = 20

-- Ping Reader
spawn(function()
    while wait(1) do
        local ping = math.floor(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())
        Stats.Tex
