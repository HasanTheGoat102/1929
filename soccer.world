-- Put this inside StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- SETTINGS
------------------------------------------------
local PULL_ENABLED = false
local ESP_ENABLED = false

local PULL_RANGE = 16
local PULL_POWER = 30

------------------------------------------------
-- SPAWN BALL FROM REPLICATED STORAGE
------------------------------------------------
local template =
	ReplicatedStorage:WaitForChild("SoccerBall")

local ball =
	workspace:FindFirstChild("SoccerBall")

if not ball then

	ball = template:Clone()

	ball.Parent = workspace

	if ball:IsA("BasePart") then

		ball.Position = Vector3.new(0,5,0)

		ball.Anchored = false
		ball.CanCollide = true
		ball.Massless = false

		ball.CustomPhysicalProperties =
			PhysicalProperties.new(
				0.7,
				0.3,
				0.5
			)
	end
end

------------------------------------------------
-- FIND BALL
------------------------------------------------
local function getBall()

	for _, v in pairs(workspace:GetDescendants()) do

		if v.Name == "SoccerBall"
		and v:IsA("BasePart") then

			return v
		end
	end
end

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SoccerAssistGUI"

gui.Parent =
	player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0,270,0,310)
frame.Position = UDim2.new(0,20,0.4,0)

frame.BackgroundColor3 =
	Color3.fromRGB(25,25,25)

frame.Active = true
frame.Draggable = true

frame.Parent = gui

------------------------------------------------
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel")

title.Size = UDim2.new(1,0,0,35)

title.Text = "⚽ Soccer Ball System"

title.TextScaled = true

title.BackgroundTransparency = 1

title.TextColor3 =
	Color3.fromRGB(255,255,255)

title.Parent = frame

------------------------------------------------
-- PULL BUTTON
------------------------------------------------
local pullBtn = Instance.new("TextButton")

pullBtn.Size = UDim2.new(1,-10,0,45)
pullBtn.Position = UDim2.new(0,5,0,50)

pullBtn.Text = "Ball Pull: OFF"

pullBtn.Parent = frame

------------------------------------------------
-- ESP BUTTON
------------------------------------------------
local espBtn = Instance.new("TextButton")

espBtn.Size = UDim2.new(1,-10,0,45)
espBtn.Position = UDim2.new(0,5,0,105)

espBtn.Text = "Ball ESP: OFF"

espBtn.Parent = frame

------------------------------------------------
-- RANGE BOX
------------------------------------------------
local rangeBox = Instance.new("TextBox")

rangeBox.Size = UDim2.new(1,-10,0,40)
rangeBox.Position = UDim2.new(0,5,0,165)

rangeBox.Text = "Range: 16"

rangeBox.Parent = frame

------------------------------------------------
-- POWER BOX
------------------------------------------------
local powerBox = Instance.new("TextBox")

powerBox.Size = UDim2.new(1,-10,0,40)
powerBox.Position = UDim2.new(0,5,0,215)

powerBox.Text = "Power: 30"

powerBox.Parent = frame

------------------------------------------------
-- INFO
------------------------------------------------
local info = Instance.new("TextLabel")

info.Size = UDim2.new(1,-10,0,35)
info.Position = UDim2.new(0,5,0,265)

info.Text = "MeshPart SoccerBall Supported"

info.TextScaled = true

info.BackgroundTransparency = 1

info.TextColor3 =
	Color3.fromRGB(255,255,255)

info.Parent = frame

------------------------------------------------
-- TOGGLES
------------------------------------------------
pullBtn.MouseButton1Click:Connect(function()

	PULL_ENABLED = not PULL_ENABLED

	pullBtn.Text =
		PULL_ENABLED and "Ball Pull: ON"
		or "Ball Pull: OFF"
end)

espBtn.MouseButton1Click:Connect(function()

	ESP_ENABLED = not ESP_ENABLED

	espBtn.Text =
		ESP_ENABLED and "Ball ESP: ON"
		or "Ball ESP: OFF"
end)

------------------------------------------------
-- RANGE EDIT
------------------------------------------------
rangeBox.FocusLost:Connect(function()

	local num =
		tonumber(string.match(rangeBox.Text,"%d+"))

	if num then

		PULL_RANGE =
			math.clamp(num,5,40)
	end

	rangeBox.Text =
		"Range: "..PULL_RANGE
end)

------------------------------------------------
-- POWER EDIT
------------------------------------------------
powerBox.FocusLost:Connect(function()

	local num =
		tonumber(string.match(powerBox.Text,"%d+"))

	if num then

		PULL_POWER =
			math.clamp(num,5,100)
	end

	powerBox.Text =
		"Power: "..PULL_POWER
end)

------------------------------------------------
-- MAIN LOOP
------------------------------------------------
RunService.RenderStepped:Connect(function()

	local char = player.Character
	if not char then return end

	local hrp =
		char:FindFirstChild("HumanoidRootPart")

	if not hrp then return end

	local ball = getBall()
	if not ball then return end

	------------------------------------------------
	-- BALL ESP
	------------------------------------------------
	if ESP_ENABLED then

		if not ball:FindFirstChild("ESP") then

			local h = Instance.new("Highlight")

			h.Name = "ESP"

			h.FillColor =
				Color3.fromRGB(0,255,0)

			h.OutlineColor =
				Color3.fromRGB(255,255,255)

			h.DepthMode =
				Enum.HighlightDepthMode.AlwaysOnTop

			h.Parent = ball
		end

	else

		local h =
			ball:FindFirstChild("ESP")

		if h then
			h:Destroy()
		end
	end

	------------------------------------------------
	-- BALL PULL
	------------------------------------------------
	if PULL_ENABLED then

		local dist =
			(hrp.Position - ball.Position).Magnitude

		if dist <= PULL_RANGE then

			local target =
				hrp.Position
				+ hrp.CFrame.LookVector * 2
			local dir =
				(target - ball.Position)

			ball.AssemblyLinearVelocity =
				dir * PULL_POWER
		end
	end
end)
