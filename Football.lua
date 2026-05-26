local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- CPS Hub States
_G.ReachEnabled = false
_G.ReachRange = 5.5 -- Slider default matching your screenshot
_G.AimbotEnabled = false
_G.BringBallEnabled = false
_G.BallESPEnabled = false

----------------------------------------------------------------
-- 1. MODERN CPS HUB UI LAYOUT (Dark Blue/Grey Glass Theme)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RealCPSHub"
pcall(function() ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 35) -- Precise dark blue background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Navbar Info
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0, 200, 1, 0)
HubTitle.Position = UDim2.new(0, 15, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "CPS Hub | Soccer World"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.TextSize = 16
HubTitle.Font = Enum.Font.SourceSansBold
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = TopBar

local VersionTag = Instance.new("TextLabel")
VersionTag.Size = UDim2.new(0, 55, 0, 22)
VersionTag.Position = UDim2.new(0, 175, 0.25, 0)
VersionTag.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
VersionTag.Text = "v2.4.0"
VersionTag.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionTag.TextSize = 12
VersionTag.Font = Enum.Font.SourceSansBold
VersionTag.Parent = TopBar
Instance.new("UICorner", VersionTag).CornerRadius = UDim.new(0, 6)

-- Sidebar Navigation Container
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 18, 27)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -140, 1, -45)
ContentFrame.Position = UDim2.new(0, 140, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Tab Frames Container
local Tabs = {
    Main = Instance.new("ScrollingFrame"),
    Reach = Instance.new("ScrollingFrame"),
    Fun = Instance.new("ScrollingFrame")
}

for name, frame in pairs(Tabs) do
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 1, 50)
    frame.ScrollBarThickness = 2
    frame.Visible = (name == "Main")
    frame.Parent = ContentFrame
end

----------------------------------------------------------------
-- UI CONTROLS BUILDER UTILITIES
----------------------------------------------------------------
local function createTabButton(text, yPos, targetTab)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. text
    btn.TextColor3 = (text == "Main") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 135, 150)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    btn.MouseButton1Click:Connect(function()
        for tName, tFrame in pairs(Tabs) do tFrame.Visible = (tName == targetTab) end
        for _, child in ipairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(130, 135, 150) end
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabButton("Main", 10, "Main")
createTabButton("Reach", 50, "Reach")
createTabButton("Fun", 90, "Fun")

-- Component Creator for Rows
local function createToggleRow(parentFrame, title, desc, yPos, globalVarName)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 60)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    row.BorderSizePixel = 0
    row.Parent = parentFrame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 250, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 10)
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = row

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 250, 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 30)
    sub.Text = desc
    sub.TextColor3 = Color3.fromRGB(130, 135, 150)
    sub.Font = Enum.Font.SourceSans
    sub.TextSize = 13
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.BackgroundTransparency = 1
    sub.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 42, 0, 22)
    toggle.Position = UDim2.new(1, -55, 0.3, 0)
    toggle.BackgroundColor3 = _G[globalVarName] and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(45, 50, 70)
    toggle.Text = ""
    toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = _G[globalVarName] and UDim2.new(0, 23, 0, 3) or UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 8)

    toggle.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        TweenService:Create(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = _G[globalVarName] and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(45, 50, 70)
        }):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {
            Position = _G[globalVarName] and UDim2.new(0, 23, 0, 3) or UDim2.new(0, 3, 0, 3)
        }):Play()
    end)
end

-- POPULATING TABS MATCHING CPS HUB
createToggleRow(Tabs.Main, "Aimbot", "Automatically aims the ball into the net.", 10, "AimbotEnabled")
createToggleRow(Tabs.Main, "Ball ESP", "Predicts and highlights ball location.", 80, "BallESPEnabled")

createToggleRow(Tabs.Reach, "Reach", "Allows you to kick the ball from far away.", 10, "ReachEnabled")

-- Custom Reach Slider Box Row (5 to 10 studs)
local SliderRow = Instance.new("Frame")
SliderRow.Size = UDim2.new(1, -20, 0, 60)
SliderRow.Position = UDim2.new(0, 10, 0, 80)
SliderRow.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
SliderRow.Parent = Tabs.Reach
Instance.new("UICorner", SliderRow).CornerRadius = UDim.new(0, 6)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(0, 120, 1, 0)
SliderLabel.Position = UDim2.new(0, 12, 0, 0)
SliderLabel.Text = "Reach Range"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1
SliderLabel.Parent = SliderRow

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Size = UDim2.new(0, 40, 1, 0)
ValueLabel.Position = UDim2.new(0, 180, 0, 0)
ValueLabel.Text = string.format("%.1f", _G.ReachRange)
ValueLabel.TextColor3 = Color3.fromRGB(130, 135, 150)
ValueLabel.Font = Enum.Font.SourceSans
ValueLabel.TextSize = 14
ValueLabel.BackgroundTransparency = 1
ValueLabel.Parent = SliderRow

-- Slider Track
local SliderTrack = Instance.new("TextButton")
SliderTrack.Size = UDim2.new(0, 120, 0, 4)
SliderTrack.Position = UDim2.new(1, -140, 0.45, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
SliderTrack.Text = ""
SliderTrack.Parent = SliderRow

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.2, 0, 1, 0) -- map to default 5.5
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local SliderCircle = Instance.new("Frame")
SliderCircle.Size = UDim2.new(0, 12, 0, 12)
SliderCircle.Position = UDim2.new(0.2, -6, 0.5, -6)
SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderCircle.Parent = SliderTrack
Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(0, 6)

-- Handle Slider Math (Constrained from 5 to 10 studs)
local function updateSlider(input)
    local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.Width, 0, 1)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderCircle.Position = UDim2.new(percentage, -6, 0.5, -6)
    
    -- Remap 0-1 percentage to 5 - 10 scale
    _G.ReachRange = 5 + (percentage * 5)
    ValueLabel.Text = string.format("%.1f", _G.ReachRange)
end

local dragging = false
SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider(input)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

createToggleRow(Tabs.Fun, "Bring Ball", "Brings the ball smoothly to your character.", 10, "BringBallEnabled")

----------------------------------------------------------------
-- 2. SOCCER WORLD BACKEND ENGINE LOOPS
----------------------------------------------------------------
local function getBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name == "SoccerBall" or obj.Name == "Football") then
            return obj
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    
    if not hrp or not ball then return end
    
    -- Handle Visual ESP Highlight
    local hl = ball:FindFirstChild("CPSHighlight")
    if _G.BallESPEnabled then
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "CPSHighlight"
            hl.FillColor = Color3.fromRGB(0, 220, 100)
            hl.FillTransparency = 0.4
            hl.Parent = ball
        end
    else
        if hl then hl:Destroy() end
    end
    
    -- Handle Bring Ball Logic
    if _G.BringBallEnabled then
        ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        ball.CFrame = hrp.CFrame * CFrame.new(0, -2, -3)
    end
    
    -- Handle Dynamic Reach Engine (Uses slider values 5 to 10 studs)
    if _G.ReachEnabled and not _G.BringBallEnabled then
        local distance = (ball.Position - hrp.Position).Magnitude
        if distance <= _G.ReachRange and distance > 2.5 then
            -- Smoothly pushes toward player feet trajectory framework style
            local direction = ((hrp.Position - Vector3.new(0, 2, 0)) - ball.Position).Unit
            ball.AssemblyLinearVelocity = direction * 35
        end
    end
    
    -- Handle Aimbot Net Vectors
    if _G.AimbotEnabled and not _G.BringBallEnabled then
        local distance = (ball.Position - hrp.Position).Magnitude
        if distance <= 4 then -- Active when dribbling
            local enemyGoal = workspace:FindFirstChild("LeftGoal") or workspace:FindFirstChild("RightGoal")
            if enemyGoal then
                local goalPart = enemyGoal:FindFirstChildWhichIsA("BasePart") or enemyGoal
                local targetDir = (goalPart.Position - ball.Position).Unit
                ball.AssemblyLinearVelocity = targetDir * 55
            end
        end
    end
end)




