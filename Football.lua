-- Touch Football CPS Hub Recreation
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Notification to show the script loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "CPS HUB CRACKED",
    Text = "Touch Football Script Loaded!",
    Duration = 5
})

-- CONFIGURATION
_G.AutoGoal = false      -- Teleports the ball into the net
_G.ReachEnabled = true   -- Gives you a massive reach/hitbox for the ball
_G.BallMagnet = false    -- Attaches the ball to you permanently
_G.ReachSize = 15

-- Function to find the active football in Workspace
local function getFootball()
    -- Look for common Touch Football ball names
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name:lower():match("ball") or v.Name:lower():match("football") or v:FindFirstChild("BallScript") then
            if v:IsA("BasePart") then
                return v
            elseif v:IsA("Model") and v.PrimaryPart then
                return v.PrimaryPart
            end
        end
    end
    return nil
end

-- MAIN LOOPS
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getFootball()
    
    if not hrp or not ball then return end
    
    -- 1. BALL MAGNET (Brings ball directly to your feet)
    if _G.BallMagnet then
        ball.AssemblyLinearVelocity = Vector3.new(0,0,0)
        ball.CFrame = hrp.CFrame * CFrame.new(0, -2, -3) -- Places ball right in front of you
    end
    
    -- 2. REACH / BIG HITBOX
    if _G.ReachEnabled then
        local distance = (ball.Position - hrp.Position).Magnitude
        if distance <= _G.ReachSize then
            -- Mimics a player touch/kick by applying force toward where you look
            ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * 45
        end
    end
    
    -- 3. AUTO GOAL (Teleports ball to enemy goal)
    if _G.AutoGoal then
        -- Searches workspace for the goals
        local enemyGoal = workspace:FindFirstChild("LeftGoal") or workspace:FindFirstChild("RightGoal") -- Change based on map
        if enemyGoal then
            local goalPart = enemyGoal:FindFirstChildWhichIsA("BasePart") or enemyGoal
            ball.CFrame = goalPart.CFrame
        end
    end
end)


