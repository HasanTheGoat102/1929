local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- 1. SPAWN THE SOCCER BALL
local template = ReplicatedStorage:WaitForChild("SoccerBall")
local ball = template:Clone()
ball.Parent = workspace

-- Set up ball physics based on type
local ballPart = nil
if ball:IsA("BasePart") then
    ballPart = ball
    ball.Position = Vector3.new(0, 5, 0)
    ball.Anchored = false
    ball.CanCollide = true
    ball.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
elseif ball:IsA("Model") then
    ballPart = ball.PrimaryPart or ball:FindFirstChildWhichIsA("BasePart")
    if ballPart then
        ballPart.Position = Vector3.new(0, 5, 0)
        for _, v in pairs(ball:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
                v.CanCollide = true
            end
        end
    end
end

-- 2. CONFIGURATION VARIABLES (Controlled by your UI)
_G.BallPullEnabled = true   -- Change to false to turn off
_G.BallESPEnabled = true    -- Change to false to turn off
_G.PullRange = 16           -- Maximum distance to pull
_G.PullPower = 30           -- How fast the ball moves to you

-- 3. BALL ESP SYSTEM
local function applyESP(targetBall)
    if not targetBall then return end
    -- Remove old highlight if it exists
    local oldHighlight = targetBall:FindFirstChild("BallHighlight")
    if oldHighlight then oldHighlight:Destroy() end
    
    -- Create new visual highlight box
    local highlight = Instance.new("Highlight")
    highlight.Name = "BallHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan glow
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = targetBall
    highlight.Enabled = _G.BallESPEnabled
    highlight.Parent = targetBall
end

applyESP(ball)

-- 4. MAIN LOOP (Handles Ball Pulling and ESP toggles)
RunService.Heartbeat:Connect(function()
    -- Update ESP visibility dynamically
    if ball then
        local hl = ball:FindFirstChild("BallHighlight")
        if hl then hl.Enabled = _G.BallESPEnabled end
    end

    -- Run Ball Pull logic
    if _G.BallPullEnabled and ballPart then
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Check the distance between the player and the ball
                local distance = (ballPart.Position - hrp.Position).Magnitude
                
                if distance <= _G.PullRange and distance > 3 then
                    -- Calculate directional push vector toward player
                    local direction = (hrp.Position - ballPart.Position).Unit
                    ballPart.AssemblyLinearVelocity = direction * _G.PullPower
                end
            end
        end
    end
end)

