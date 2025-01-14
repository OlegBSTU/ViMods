---@diagnostic disable: undefined-global
if CLIENT then return end

local Path = table.pack(...)[1]
dofile(Path .. "/Lua/Scripts/helperfunctions.lua")
dofile(Path .. "/Lua/Scripts/Server/ondamaged.lua")
dofile(Path .. "/Lua/Scripts/Server/thhumanupdate.lua")
local characterID = "ThalamusHuman"
local jobID = "ThalamusJob"

local function MoveInvSlot(oldCharacter, newCharacter, invSlot)
	local item = oldCharacter.Inventory.GetItemInLimbSlot(invSlot)
	if item then
		item.Drop()
		local index = newCharacter.Inventory.FindLimbSlot(invSlot)
		if index then
			newCharacter.Inventory.TryPutItem(item, index, true, false)
		end
	end
end


local function RespawnCharacter(character)
	print(string.format("Respawning %s as %s", character.Name, jobID))

	Entity.Spawner.AddCharacterToSpawnQueue(characterID, character.WorldPosition, function(newCharacter)
		local client = nil
		for _, value in pairs(Client.ClientList) do
			if value.Character == character then
				client = value
			end
		end

		if client == nil then
			return
		end

		-- Transfer items
		MoveInvSlot(character, newCharacter, InvSlotType.Card)
		MoveInvSlot(character, newCharacter, InvSlotType.Headset)
		MoveInvSlot(character, newCharacter, InvSlotType.Head)

		-- Set TeamID to prevent guards kill our «vessel»
		newCharacter.TeamID = character.TeamID
		client.SetClientCharacter(newCharacter)

		-- Change character information
		local info = CharacterInfo(characterID, client.Name)
		newCharacter.Info = info
		info.Job = Job(JobPrefab.Get(jobID), false)

		-- Remove the old character
		Entity.Spawner.AddEntityToRemoveQueue(character)
	end)
end


Hook.Add("character.created", "convertJobs", function(character)
	Timer.Wait(function()
		if character.HasJob(jobID) and character.IsHuman then
			RespawnCharacter(character)
		elseif not character.IsHuman and character.Name == characterID then
			print(string.format("Deleted duplicate character %s", character.Name))

			if character.Inventory then
				for _, items in pairs(character.Inventory.FindAllItems()) do
					Entity.Spawner.AddItemToRemoveQueue(items)
				end
			end
			Entity.Spawner.AddEntityToRemoveQueue(character)
		end
	end, 1000)
end)