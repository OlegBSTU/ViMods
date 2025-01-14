-- Neurotrauma human update functions
-- Hooks Lua event "think" to update and use for applying NT specific character data (its called 'c') with
-- values/functions defined here in NT.UpdateHuman, NT.LimbAfflictions and NT.Afflictions
local NT = {}
NT.UpdateCooldown = 0
NT.UpdateInterval = 120
NT.Deltatime = NT.UpdateInterval / 60 -- Time in seconds that transpires between updates

Hook.Add("think", "NT.update", function()
	if HF.GameIsPaused() then
		return
	end

	NT.UpdateCooldown = NT.UpdateCooldown - 1
	if NT.UpdateCooldown <= 0 then
		NT.UpdateCooldown = NT.UpdateInterval
		NT.Update()
	end
end)

-- gets run once every two seconds
function NT.Update()
	local updateTHHumans = {}
	local amountTHHumans = 0

	-- fetchcharacters to update
	for key, character in pairs(Character.CharacterList) do
		if not character.IsDead then
			if character.HasJob("ThalamusJob") then
				table.insert(updateTHHumans, character)
				amountTHHumans = amountTHHumans + 1
			end
		end
	end

	-- we spread the characters out over the duration of an update so that the load isnt done all at once
	for key, value in pairs(updateTHHumans) do
		-- make sure theyre still alive and human
		if value ~= nil and not value.Removed and value.HasJob("ThalamusJob") and not value.IsDead then
			Timer.Wait(function()
				if value ~= nil and not value.Removed and value.HasJob("ThalamusJob") and not value.IsDead then
					NT.UpdateTHHuman(value)
				end
			end, ((key + 1) / amountTHHumans) * NT.Deltatime * 1000)
		end
	end
end

function NT.UpdateTHHuman(character)
	--local velocity = 0
	--if
	--	character ~= nil
	--	and character.AnimController ~= nil
	--	and character.AnimController.MainLimb ~= nil
	--	and character.AnimController.MainLimb.body ~= nil
	--	and character.AnimController.MainLimb.body.LinearVelocity ~= nil
	--then
	--	velocity = character.AnimController.MainLimb.body.LinearVelocity.Length()
	--end

	local function updateLimb(character, limbtype)
		THConvertDamageTypes(character, limbtype)

		--local limb = character.AnimController.GetLimb(limbtype)

		-- cyber stats
		--local loosescrews = HF.GetAfflictionStrengthLimb(character, limbtype, "ntc_loosescrews", 0)
		--local damagedelectronics = HF.GetAfflictionStrengthLimb(character, limbtype, "ntc_damagedelectronics", 0)
		--local bentmetal = HF.GetAfflictionStrengthLimb(character, limbtype, "ntc_bentmetal", 0)
		--local materialloss = HF.GetAfflictionStrengthLimb(character, limbtype, "ntc_materialloss", 0)
		--
		---- water damage if unprotected
		--if NTConfig.Get("NTCyb_waterDamage", 0) > 0 and character.PressureProtection <= 1000 then
		--	-- in water?
		--	local inwater = false
		--	if limb ~= nil and limb.InWater then
		--		inwater = true
		--	end
		--	if inwater then
		--		-- add damaged electronics
		--		Timer.Wait(function(limb)
		--			if limb ~= nil then
		--				local spawnpos = limb.WorldPosition
		--				HF.SpawnItemAt("ntcvfx_malfunction", spawnpos)
		--			end
		--		end, math.random(1, 500))
		--		HF.AddAfflictionLimb(
		--			character,
		--			"ntc_damagedelectronics",
		--			limbtype,
		--			2 * (1 + loosescrews / 100) * (1 + materialloss / 100) * NT.Config.NTCybWaterDamage * NT.Deltatime
		--		)
		--	end
		--end

		---- moving around damages if loose screws high enough
		--if loosescrews > 30 and velocity > 1 then
		--	HF.AddAfflictionLimb(
		--		character,
		--		"ntc_materialloss",
		--		limbtype,
		--		HF.Clamp(velocity, 0, 5) * (loosescrews / 500) * NT.Deltatime
		--	)
		--	HF.AddAfflictionLimb(character, "ntc_loosescrews", limbtype, HF.Clamp(velocity, 0, 5) / 50 * NT.Deltatime)
		--end
		--
		---- losing the limb
		--if materialloss >= 99 then
		--	NTCyb.UncyberifyLimb(character, limbtype)
		--	NT.TraumamputateLimbMinusItem(character, limbtype)
		--	HF.GiveItem(character, "ntcsfx_cyberdeath")
		--	HF.AddAfflictionLimb(character, "internaldamage", limbtype, HF.RandomRange(30, 60))
		--	HF.AddAfflictionLimb(character, "foreignbody", limbtype, HF.RandomRange(10, 25))
		--	return
		--end
		--
		---- limb malfunction due to damaged electronics
		--local malfunction = (damagedelectronics > 20 and HF.Chance((damagedelectronics / 120) ^ 4))
		--if malfunction then
		--	HF.SpawnItemAt("ntcvfx_malfunction", limb.WorldPosition)
		--end
		--local locklimb = damagedelectronics >= 99 or bentmetal >= 99 or malfunction
		--
		--local function lockLimb()
		--	local limbIdentifierLookup = {}
		--	limbIdentifierLookup[LimbType.LeftArm] = "lockleftarm"
		--	limbIdentifierLookup[LimbType.RightArm] = "lockrightarm"
		--	limbIdentifierLookup[LimbType.LeftLeg] = "lockleftleg"
		--	limbIdentifierLookup[LimbType.RightLeg] = "lockrightleg"
		--	if limbIdentifierLookup[limbtype] == nil then
		--		return
		--	end
		--	NTC.SetSymptomTrue(character, limbIdentifierLookup[limbtype])
		--end
		--
		--if locklimb then
		--	lockLimb()
		--end
		--
		---- slowdown due to bent metal
		--if bentmetal > 5 and (limbtype == LimbType.LeftLeg or limbtype == LimbType.RightLeg) then
		--	NTC.MultiplySpeed(character, 1 - (bentmetal / 100) * 0.5)
		--end
	end

	updateLimb(character, LimbType.Torso)
	updateLimb(character, LimbType.Head)
	updateLimb(character, LimbType.LeftLeg)
	updateLimb(character, LimbType.RightLeg)
	updateLimb(character, LimbType.LeftArm)
	updateLimb(character, LimbType.RightArm)
end
