local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global Configuration State
_G.BallPull = false
_G.BallESP = false
_G.PullRange = 16
_G.PullPower = 30

----------------------------------------------------------------
-- 1. CREATE THE SOCCER WORLD GUI
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoccerWorldHubGui"
-- Try to protect the GUI from detection or clear on spawn
pcall(function()
    ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows you to drag it around on your iPad screen
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -15, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚽ Soccer Ball System"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Reusable Button Helper function
local function createButton(name, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -30, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Matches your gray buttons
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSans
    btn.Parent = MainFrame
    
    -- Round corners slightly
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Button 1: Ball Pull Toggle
local PullBtn = createButton("PullToggle", "Ball Pull: OFF", UDim2.new(0, 15, 0, 60), function(btn)
    _G.BallPull = not _G.BallPull
    if _G.BallPull then
        btn.Text = "Ball Pull: ON"
        btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    else
        btn.Text = "Ball Pull: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Button 2: Ball ESP Toggle
local EspBtn = createButton("EspToggle", "Ball ESP: OFF", UDim2.new(0, 15, 0, 110), function(btn)
    _G.BallESP = not _G.BallESP
    if _G.BallESP then
        btn.Text = "Ball ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    else
        btn.Text = "Ball ESP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Range Info Text
local RangeLabel = Instance.new("TextLabel")
RangeLabel.Size = UDim2.new(1, -30, 0, 35)
RangeLabel.Position = UDim2.new(0, 15, 0, 160)
RangeLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RangeLabel.BorderSizePixel = 0
RangeLabel.Text = "Range: " .. tostring(_G.PullRange)
RangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeLabel.TextSize = 15
RangeLabel.Font = Enum.Font.SourceSans
RangeLabel.Parent = MainFrame

-- Footer Text
local FooterText = Instance.new("TextLabel")
FooterText.Size = UDim2.new(1, -30, 0, 30)
FooterText.Position = UDim2.new(0, 15, 0, 210)
FooterText.BackgroundTransparency = 1
FooterText.Text = "MeshPart SoccerBall Supported"
FooterText.TextColor3 = Color3.fromRGB(200, 200, 200)
FooterText.TextSize = 15
FooterText.Font = Enum.Font.SourceSansItalic
FooterText.TextXAlignment = Enum.TextXAlignment.Left
FooterText.Parent = MainFrame


----------------------------------------------------------------
-- 2. BACKEND GAMEPLAY LOGIC
----------------------------------------------------------------
local function getSoccerWorldBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name == "SoccerBall" or obj.Name == "Football") then
            return obj
        end
    end
    return nil
end

local function handleESP(ballPart)
    if not ballPart then return end
    local highlight = ballPart:FindFirstChild("SoccerWorldESP")
    
    if _G.BallESP then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "SoccerWorldESP"
            highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan bright color
            highlight.FillTransparency = 0.4
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = ballPart
        end
    else
        if highlight then highlight:Destroy() end
    end
end

-- Core runtime framework loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getSoccerWorldBall()
    
    if not hrp or not ball then return end
    
    -- Sync visual Highlight state
    handleESP(ball)
    
    -- Handle physical ball pulling calculations
    if _G.BallPull then
        local distance = (ball.Position - hrp.Position).Magnitude
        if distance <= _G.PullRange and distance > 2.5 then
            local direction = ((hrp.Position - Vector3.new(0, 2, 0)) - ball.Position).Unit
            ball.AssemblyLinearVelocity = direction * _G.PullPower
        end
    end
end)



