local convertedDamageTypes = {
	--"bleeding",
	"blunttrauma",
	"lacerations",
	"burn",
	"gunshotwound",
	"bitewounds",
	"explosiondamage",
	"internaldamage",
	--"foreignbody",
}

local damageTypeSFXDict = {}
--damageTypeSFXDict["blunttrauma"] = "ntcsfx_cyberblunt"
--damageTypeSFXDict["lacerations"] = "ntcsfx_cyberblunt"
--damageTypeSFXDict["burn"] = "ntcsfx_welding"
--damageTypeSFXDict["gunshotwound"] = "ntcsfx_cyberblunt"
--damageTypeSFXDict["bitewounds"] = "ntcsfx_cyberbite"
--damageTypeSFXDict["explosiondamage"] = "ntcsfx_cyberblunt"
--damageTypeSFXDict["internaldamage"] = "ntcsfx_cyberblunt"
--damageTypeSFXDict["foreignbody"] = "ntcsfx_cyberblunt"

local function ConvertDamageTypes(character, limbtype)
	-- local function isExtremity()
	--     return not limbtype==LimbType.Torso and not limbtype==LimbType.Head
	-- end
	-- /// fetch stats ///

	-- physical damage types
	--local bleeding = HF.GetAfflictionStrengthLimb(character, limbtype, "bleeding", 0)
	local burn = HF.GetAfflictionStrengthLimb(character, limbtype, "burn", 0)
	local lacerations = HF.GetAfflictionStrengthLimb(character, limbtype, "lacerations", 0)
	local gunshotwound = HF.GetAfflictionStrengthLimb(character, limbtype, "gunshotwound", 0)
	local bitewounds = HF.GetAfflictionStrengthLimb(character, limbtype, "bitewounds", 0)
	local explosiondamage = HF.GetAfflictionStrengthLimb(character, limbtype, "explosiondamage", 0)
	local blunttrauma = HF.GetAfflictionStrengthLimb(character, limbtype, "blunttrauma", 0)
	local internaldamage = HF.GetAfflictionStrengthLimb(character, limbtype, "internaldamage", 0)
	--local foreignbody = HF.GetAfflictionStrengthLimb(character, limbtype, "foreignbody", 0)

	-- cyber stats
	local scorchedtissue = HF.GetAfflictionStrengthLimb(character, limbtype, "scorchedtissue", 0)
	local prevscorchedtissue = scorchedtissue
	local cuts = HF.GetAfflictionStrengthLimb(character, limbtype, "cuts", 0)
	local prevcuts = cuts
	local gunshotwound_thalamis = HF.GetAfflictionStrengthLimb(character, limbtype, "gunshotwound_thalamis", 0)
	local prevgunshotwound_thalamis = gunshotwound_thalamis
	local gnawed = HF.GetAfflictionStrengthLimb(character, limbtype, "gnawed", 0)
	local prevgnawed = gnawed
	local explosiondamage_thalamis = HF.GetAfflictionStrengthLimb(character, limbtype, "explosiondamage_thalamis", 0)
	local prevexplosiondamage_thalamis = explosiondamage_thalamis
	local organisdamage = HF.GetAfflictionStrengthLimb(character, limbtype, "ntc_bentmetal", 0)
	local prevorganisdamage = organisdamage
	local bruisedtissue = HF.GetAfflictionStrengthLimb(character, limbtype, "bruisedtissue", 0)
	local prevbruisedtissue = bruisedtissue

	-- calculate damage conversion

	--local function damageChance(val, chance)
	--	if val > 0.01 and HF.Chance(chance) then
	--		return val
	--	end
	--	return 0
	--end

	scorchedtissue = scorchedtissue + burn
	--	+ 1
	--		* (0.25 * damageChance(lacerations, 0.75) + 1 * damageChance(explosiondamage, 0.8) + 0.5 * damageChance(
	--			blunttrauma,
	--			0.5
	--		) + 1 * damageChance(internaldamage, 0.75) + 0.5 * damageChance(bitewounds, 0.5) + 0.75 * damageChance(
	--			foreignbody,
	--			0.75
	--		))

	explosiondamage_thalamis = explosiondamage_thalamis + explosiondamage
	--	+ 0.5
	--		* (1 + prevmaterialloss / 50)
	--		* (2 * damageChance(burn, 0.75) + 0.75 * damageChance(gunshotwound, 0.85) + 0.25 * damageChance(
	--			bitewounds,
	--			0.5
	--		) + 0.5 * damageChance(explosiondamage, 0.5) + 1 * damageChance(blunttrauma, 0.5) + 1 * damageChance(
	--			internaldamage,
	--			0.75
	--		) + 0.75 * damageChance(foreignbody, 0.75))

	organisdamage = organisdamage + internaldamage
	--	+ 1
	--		* (0.25 * damageChance(burn, 0.85) + 0.25 * damageChance(lacerations, 0.5) + 0.5 * damageChance(
	--			bitewounds,
	--			0.5
	--		) + 1 * damageChance(explosiondamage, 0.85) + 2 * damageChance(blunttrauma, 0.75))

	gunshotwound_thalamis = gunshotwound_thalamis + gunshotwound
	--	+ (1 + prevloosescrews / 50)
	--		* (0.5 * damageChance(lacerations, 0.75) + 0.8 * damageChance(gunshotwound, 0.8) + 0.6 * damageChance(
	--			bitewounds,
	--			0.75
	--		) + 1 * explosiondamage + 0.5 * damageChance(foreignbody, 0.8))

	gnawed = gnawed + bitewounds
	--	+ (1 + prevloosescrews / 50)
	--		* (0.5 * damageChance(lacerations, 0.75) + 0.8 * damageChance(gunshotwound, 0.8) + 0.6 * damageChance(
	--			bitewounds,
	--			0.75
	--		) + 1 * explosiondamage + 0.5 * damageChance(foreignbody, 0.8))

	bruisedtissue = bruisedtissue + blunttrauma
	--	+ (1 + prevloosescrews / 50)
	--		* (0.5 * damageChance(lacerations, 0.75) + 0.8 * damageChance(gunshotwound, 0.8) + 0.6 * damageChance(
	--			bitewounds,
	--			0.75
	--		) + 1 * explosiondamage + 0.5 * damageChance(foreignbody, 0.8))

	cuts = cuts + lacerations
	--	+ (1 + prevloosescrews / 50)
	--		* (0.5 * damageChance(lacerations, 0.75) + 0.8 * damageChance(gunshotwound, 0.8) + 0.6 * damageChance(
	--			bitewounds,
	--			0.75
	--		) + 1 * explosiondamage + 0.5 * damageChance(foreignbody, 0.8))

	-- /// apply changes ///

	HF.ApplyAfflictionChangeLimb(character, limbtype, "burn", 0, burn, 0, 200)
	--HF.ApplyAfflictionChangeLimb(character, limbtype, "bleeding", 0, bleeding, 0, 100)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "lacerations", 0, lacerations, 0, 200)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "gunshotwound", 0, gunshotwound, 0, 200)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "bitewounds", 0, bitewounds, 0, 200)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "explosiondamage", 0, explosiondamage, 0, 200)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "blunttrauma", 0, blunttrauma, 0, 200)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "internaldamage", 0, internaldamage, 0, 200)
	--HF.ApplyAfflictionChangeLimb(character, limbtype, "foreignbody", 0, foreignbody, 0, 100)

	HF.ApplyAfflictionChangeLimb(character, limbtype, "scorchedtissue", scorchedtissue, prevscorchedtissue, 0, 100)
	HF.ApplyAfflictionChangeLimb(
		character,
		limbtype,
		"explosiondamage_thalamis",
		explosiondamage_thalamis,
		prevexplosiondamage_thalamis,
		0,
		100
	)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "organisdamage", organisdamage, prevorganisdamage, 0, 100)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "cuts", cuts, prevcuts, 0, 100)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "bruisedtissue", bruisedtissue, prevbruisedtissue, 0, 100)
	HF.ApplyAfflictionChangeLimb(
		character,
		limbtype,
		"gunshotwound_thalamis",
		gunshotwound_thalamis,
		prevgunshotwound_thalamis,
		0,
		100
	)
	HF.ApplyAfflictionChangeLimb(character, limbtype, "gnawed", gnawed, prevgnawed, 0, 100)

	--NT.DislocateLimb(character, limbtype, -1000)
	--NT.BreakLimb(character, limbtype, -1000)
	--NT.ArteryCutLimb(character, limbtype, -1000)

	--HF.SetAfflictionLimb(character, "arteriesclamp", limbtype, 0)
	--HF.SetAfflictionLimb(character, "surgeryincision", limbtype, 0)
	--HF.SetAfflictionLimb(character, "clampedbleeders", limbtype, 0)
	--HF.SetAfflictionLimb(character, "drilledbones", limbtype, 0)
	--HF.SetAfflictionLimb(character, "retractedskin", limbtype, 0)
	--HF.SetAfflictionLimb(character, "suturedi", limbtype, 0)
	--HF.SetAfflictionLimb(character, "suturedw", limbtype, 0)
	--
	--if limbtype == LimbType.LeftLeg then
	--	HF.SetAffliction(character, "tll_amputation", 0)
	--	HF.SetAffliction(character, "sll_amputation", 0)
	--end
	--if limbtype == LimbType.RightLeg then
	--	HF.SetAffliction(character, "trl_amputation", 0)
	--	HF.SetAffliction(character, "srl_amputation", 0)
	--end
	--if limbtype == LimbType.LeftArm then
	--	HF.SetAffliction(character, "tla_amputation", 0)
	--	HF.SetAffliction(character, "sla_amputation", 0)
	--end
	--if limbtype == LimbType.RightArm then
	--	HF.SetAffliction(character, "tra_amputation", 0)
	--	HF.SetAffliction(character, "sra_amputation", 0)
	--end
end

Hook.Add("character.applyDamage", "ThalamusJob.ondamaged", function(characterHealth, attackResult, hitLimb)
	--print(hitLimb.HealthIndex or hitLimb ~= nil)

	if -- invalid attack data, don't do anything
		characterHealth == nil
		or characterHealth.Character == nil
		or characterHealth.Character.IsDead
		or not characterHealth.Character.HasJob("ThalamusJob")
		or attackResult == nil
		or attackResult.Afflictions == nil
		or #attackResult.Afflictions <= 0
		or hitLimb == nil
		or hitLimb.IsSevered
	then
		return
	end

	print("hit")
	-- automatically convert damage types
	local targetChar = characterHealth.Character
	local causeDamageTypeConversion = false
	local identifier = ""
	local sfxidentifier = nil

	for index, value in ipairs(attackResult.Afflictions) do
		if value.Strength > 1 then
			identifier = value.Prefab.Identifier.Value

			if HF.TableContains(convertedDamageTypes, identifier) then
				causeDamageTypeConversion = true
				if damageTypeSFXDict[identifier] ~= nil then
					sfxidentifier = damageTypeSFXDict[identifier]
				end
			end
		end
	end

	--if causeDamageTypeConversion and NTCyb.HF.LimbIsCyber(targetChar, hitLimb.type) then
	if causeDamageTypeConversion then
		if sfxidentifier ~= nil then
			HF.GiveItem(targetChar, sfxidentifier)
		end
		Timer.Wait(function()
			ConvertDamageTypes(targetChar, hitLimb.type)
		end, 1)
	end
end)
