-- classes
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- fling players
local function added(player : Player)
	local character = player.Character

	player.CharacterAdded:Connect(function(new) 
		character = new
		while not character do
			character = new
			task.wait()
		end
	end)

	RunService.Heartbeat:Connect(function() 
		if character and (character.PrimaryPart and character.PrimaryPart:IsDescendantOf(character)) then
			if character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
				for i, v in character:GetDescendants() do
					if v:IsA("BasePart") then
						v.CanCollide = false
						v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
						v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
					end
				end

				character.PrimaryPart.CanCollide = false
				character.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				character.PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
			end
		end
	end)
end

-- init
local player = Players.LocalPlayer
for i, v in Players:GetPlayers() do
	if v ~= player then
		added(v)
	end
end

Players.PlayerAdded:Connect(added)

-- fling client
local last
local character = player.Character
player.CharacterAdded:Connect(function(c) character = c end)
RunService.Heartbeat:Connect(function()
	pcall(function()
		local primary = character and character.PrimaryPart

		if primary and primary.AssemblyLinearVelocity.Magnitude > 250 or primary.AssemblyAngularVelocity.Magnitude > 250 then
			primary.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			primary.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			character:SetPrimaryPartCFrame(last)
			print("fling coco neutralizado")
		elseif primary.AssemblyLinearVelocity.Magnitude < 50 or primary.AssemblyAngularVelocity.Magnitude > 50 then
			last = primary.CFrame
		end
	end)
end)