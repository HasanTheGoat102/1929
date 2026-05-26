local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Notification to confirm the script loaded in Soccer World
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚽ Soccer World HUB",
    Text = "Script Activated Successfully!",
    Duration = 5
})

-- CONFIGURATION (Adjust these values to change how strong it is)
_G.BallPull = true     -- Set to true to pull the ball toward you, false to turn off
_G.BallESP = true      -- Set to true to highlight the ball, false to turn off
_G.PullRange = 16       -- Distance from your player before the ball starts pulling
_G.PullPower = 32       -- Velocity power pushing the ball toward your character

-- Function to find the soccer ball across different Soccer World systems
local function getSoccerWorldBall()
    -- Check common places and names used in Soccer World maps
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name == "SoccerBall" or obj.Name == "Football") then
            return obj
        end
    end
    return nil
end

-- Manage the Visual ESP Highlight
local function updateESP(ballPart)
    if not ballPart then return end
    
    local highlight = ballPart:FindFirstChild("SoccerWorldESP")
    if _G.BallESP then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "SoccerWorldESP"
            highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow glow for visibility
            highlight.FillTransparency = 0.4
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = ballPart
        end
    else
        if highlight then highlight:Destroy() end
    end
end

-- Main Execution Loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getSoccerWorldBall()
    
    if not hrp or not ball then return end
    
    -- Update ESP Status
    updateESP(ball)
    
    -- Run Ball Pull Functionality
    if _G.BallPull then
        local distance = (ball.Position - hrp.Position).Magnitude
        
        -- If the ball is within your Range but not already perfectly glued to you
        if distance <= _G.PullRange and distance > 3 then
            -- Calculate direction from ball to player's torso feet
            local direction = ((hrp.Position - Vector3.new(0, 2, 0)) - ball.Position).Unit
            
            -- Push the ball toward you smoothly using physics velocity
            ball.AssemblyLinearVelocity = direction * _G.PullPower
        end
    end
end)

