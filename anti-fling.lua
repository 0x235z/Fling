-- classes
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function get_player_fling(character)
	local assembly_angular = character.PrimaryPart.AssemblyAngularVelocity
	local assembly_linear = character.PrimaryPart.AssemblyLinearVelocity

	if assembly_angular.Magnitude > 50 or assembly_linear.Magnitude > 100 then
		for i, v in character:GetDescendants() do
			if v:IsA("BasePart") then
				v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
			end
		end
		
		character.PrimaryPart.CanCollide = false
		character.PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
		assembly_angular = Vector3.new(0, 0, 0)
		assembly_linear = Vector3.new(0, 0, 0)
	end
end

local function added(player)
	player.CharacterAdded:Connect(function(character)
		while character do
			get_player_fling(character)
			task.wait()
		end
	end)
	
	if player.Character then
		while player.Character do
			get_player_fling(player.Character)
			task.wait()
		end
	end
end

-- init
local player = Players.LocalPlayer
for i, v in Players:GetPlayers() do
	if v ~= player then
		added(v)
	end
end

Players.PlayerAdded:Connect(added)

local last
local function fling_player(character : Model)
	local primary = character and character.PrimaryPart
	
	if primary and primary.AssemblyLinearVelocity.Magnitude > 250 or primary.AssemblyAngularVelocity.Magnitude > 250 then
		primary.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		primary.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		character:SetPrimaryPartCFrame(last)
	else
		last = character.PrimaryPart.CFrame
	end
end

player.CharacterAdded:Connect(function(character : Model)
	while true do
		pcall(fling_player, character)
		task.wait()
	end
end)
