local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

-- Objects to track with their respective label colors
local objects = {
    {Name = "Fireaxe", Label = "Fireaxe", Color = Color3.new(1, 0, 0)},         -- Red
    {Name = "Sledgehammer", Label = "Sledgehammer", Color = Color3.new(0, 1, 0)}, -- Green
    {Name = "MP5", Label = "MP5", Color = Color3.new(1, 1, 0)},                  -- Yellow
    {Name = "Mossberg", Label = "Mossberg", Color = Color3.new(1, 0, 1)},        -- Magenta
    {Name = "P9", Label = "P9", Color = Color3.new(0, 1, 1)},                    -- Cyan
    {Name = "Howa", Label = "Howa", Color = Color3.new(1, 0.5, 0)},              -- Orange
    {Name = "Nambu", Label = "Nambu", Color = Color3.new(1, 1, 0)}               -- Yellow
}

local espStates = {}
local espLabels = {} -- store active ESPs

local function isPickupable(model)
    return model:IsA("Model") and model:FindFirstChildWhichIsA("BasePart")
end

local function removeESP(object)
    if espLabels[object] then
        espLabels[object]:Destroy()
        espLabels[object] = nil
    end
end

local function createESPLabel(object, label, color)
    removeESP(object) -- clear old ESP if exists

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
    if not billboardGui.Adornee then return end
    billboardGui.Size = UDim2.new(10, 0, 5, 0)
    billboardGui.StudsOffset = Vector3.new(0, 5, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1.5, 0, 1.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = label
    textLabel.TextColor3 = color
    textLabel.TextSize = 40
    textLabel.Font = Enum.Font.Oswald
    textLabel.Parent = billboardGui

    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.AspectRatio = 2
    aspectRatio.Parent = textLabel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = textLabel

    espLabels[object] = billboardGui
end

local function refreshESP()
    for _, obj in ipairs(Workspace:GetChildren()) do
        for _, tracked in ipairs(objects) do
            if obj.Name == tracked.Name and isPickupable(obj) then
                createESPLabel(obj, tracked.Label, tracked.Color)
            end
        end
    end
end

-- Remove ESP if tool is picked up (parented away)
Workspace.ChildRemoved:Connect(function(obj)
    if espLabels[obj] then
        removeESP(obj)
    end
end)

-- When new items spawn
Workspace.ChildAdded:Connect(function(child)
    for _, tracked in ipairs(objects) do
        if child.Name == tracked.Name and isPickupable(child) then
            wait(0.1) -- slight delay to ensure parts load
            createESPLabel(child, tracked.Label, tracked.Color)
        end
    end
end)

-- GUI creation for toggle
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 0
titleText.BackgroundColor3 = Color3.new(0, 0, 0)
titleText.Text = "Shinjuku Item ESP"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.Oswald
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -5, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.Oswald
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #objects * 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

for _, obj in ipairs(objects) do
    espStates[obj.Name] = true

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = obj.Label .. " ESP (On)"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Oswald
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        espStates[obj.Name] = not espStates[obj.Name]
        button.Text = obj.Label .. " ESP (" .. (espStates[obj.Name] and "On" or "Off") .. ")"
        button.BackgroundColor3 = espStates[obj.Name] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)

        -- Enable/Disable existing ESP
        for tool, label in pairs(espLabels) do
            if tool.Name == obj.Name then
                label.Enabled = espStates[obj.Name]
            end
        end
    end)
end

-- Initial ESP refresh
refreshESP()
