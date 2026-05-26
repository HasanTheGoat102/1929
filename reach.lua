local Players = game:GetService("Players")
local REACH_DISTANCE = 10

local function setupCharacter(character)
    if character:FindFirstChild("PracticeReach") then return end
    
    local hrp = character:WaitForChild("HumanoidRootPart")

    local reachPart = Instance.new("Part")
    reachPart.Name = "PracticeReach"
    reachPart.Shape = Enum.PartType.Ball
    reachPart.Size = Vector3.new(REACH_DISTANCE, REACH_DISTANCE, REACH_DISTANCE)
    reachPart.Transparency = 0.8
    reachPart.CanCollide = false
    reachPart.Anchored = false
    reachPart.Color = Color3.fromRGB(0, 255, 0)

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = reachPart
    weld.Parent = reachPart

    reachPart.CFrame = hrp.CFrame
    reachPart.Parent = character
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(setupCharacter)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        task.spawn(setupCharacter, player.Character)
    end
end

