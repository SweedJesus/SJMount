
--------------------------------------------------------------------------------
-- Global Variables
--------------------------------------------------------------------------------
SJMOUNT_CONSTS = {
	-- Mount levels
	["MOUNTLEVEL1"] = "EPIC_GROUND",
	["MOUNTLEVEL2"] = "REGULAR_GROUND",
	["MOUNTLEVEL3"] = "EPIC_FLYING",
	["MOUNTLEVEL4"] = "REGULAR_FLYING",
	["MOUNTLEVEL5"] = "WATER",
	-- Riding skill level spell
	["APPRENTICE"] 	= 33388,		-- Apprentice Riding
	["JOURNEYMAN"] 	= 33391,		-- Journeyman Riding
	["EXPERT"] = 34090,				-- Expert Riding
	["ARTISAN"] = 34091,			-- Artisan Riding
	["MASTER"] = 90265,				-- Master Riding
	["NORTHREND_FLYING"] = 54197,	-- Cold Weather Flying
	["AZEROTH_FLYING"] = 90267		-- Flight Master's License
}
SJMount_numMounts = GetNumCompanions(MOUNT)
SJMount_savedVariables = {
	-- Config variables
	["usingBlacklist"] = false,
	["usingWhitelist"] = false,
	-- Riding skill variables
	["hasApprentice"] 	= nil,		-- Apprentice Riding
	["hasJourneyman"] 	= nil,		-- Journeyman Riding
	["hasExpert"] = nil,			-- Expert Riding
	["hasArtisan"] = nil,			-- Artisan Riding
	["hasMaster"] = nil,			-- Master Riding
	["hasNorthrendFlying"] = nil,	-- Cold Weather Flying
	["hasAzerothFlying"] = nil,		-- Flight Master's License
	-- Mount list tables
	["mountList"] = {
		[SJMOUNT_CONSTS.MOUNTLEVEL1] = {},
		[SJMOUNT_CONSTS.MOUNTLEVEL2] = {},
		[SJMOUNT_CONSTS.MOUNTLEVEL3] = {},
		[SJMOUNT_CONSTS.MOUNTLEVEL4] = {},
		[SJMOUNT_CONSTS.MOUNTLEVEL5] = {}
	}
}
SJMount_tempVariables = {
}

function SJMount_Update()

end

function SJMount_UseRandomBestMount()
	if SJMount_savedVariables.ridingLevel ~= nil then
		local mountLevel
		if SJMount_IsFlyableArea() then
			if SJMount_savedVariables.ridingLevel
			local randomTable, index = {}, 1
			for k, v in pairs(SJMount_savedVariables) do
				randomTable[index] = v
				index = index + 1
			end
			print(randomTable[random(1, #randomTable)])
			end
		end
	end
end

function SJMount_UseRandomLevel1Mount()
end

function SJMount_UpdateRidingSkill()
	-- Check known riding level
	-- Apprentice Riding
	if IsSpellKnown(SJMOUNT_CONSTS.APPRENTICE) then
		SJMount_savedVariables.hasApprentice = true
		SJMount_savedVariables.hasJourneyman = false
		SJMount_savedVariables.hasExpert = false
		SJMount_savedVariables.hasArtisan = false
		SJMount_savedVariables.hasMaster = false
	-- Journeyman Riding
	elseif IsSpellKnown(SJMOUNT_CONSTS.JOURNEYMAN) then
		SJMount_savedVariables.hasApprentice = true
		SJMount_savedVariables.hasJourneyman = true
		SJMount_savedVariables.hasExpert = false
		SJMount_savedVariables.hasArtisan = false
		SJMount_savedVariables.hasMaster = false
	-- Expert Riding
	elseif IsSpellKnown(SJMOUNT_CONSTS.EXPERT) then
		SJMount_savedVariables.hasApprentice = true
		SJMount_savedVariables.hasJourneyman = true
		SJMount_savedVariables.hasExpert = true
		SJMount_savedVariables.hasArtisan = false
		SJMount_savedVariables.hasMaster = false
	-- Artisan Riding
	elseif IsSpellKnown(SJMOUNT_CONSTS.ARTISAN) then
		SJMount_savedVariables.hasApprentice = true
		SJMount_savedVariables.hasJourneyman = true
		SJMount_savedVariables.hasExpert = true
		SJMount_savedVariables.hasArtisan = true
		SJMount_savedVariables.hasMaster = false
	-- Master Riding
	elseif IsSpellKnown(SJMOUNT_CONSTS.MASTER) then
		SJMount_savedVariables.hasApprentice = true
		SJMount_savedVariables.hasJourneyman = true
		SJMount_savedVariables.hasExpert = true
		SJMount_savedVariables.hasArtisan = true
		SJMount_savedVariables.hasMaster = true
	-- No riding skill
	else
		SJMount_savedVariables.hasApprentice = false
		SJMount_savedVariables.hasJourneyman = false
		SJMount_savedVariables.hasExpert = false
		SJMount_savedVariables.hasArtisan = false
		SJMount_savedVariables.hasMaster = false
	end
	-- Check if Cold Weather Flying
	if IsSpellKnown(SJMOUNT_CONSTS.NORTHREND_FLYING) then
		SJMount_savedVariables.hasNorthrendFlying = true
	else
		SJMount_savedVariables.hasNorthrendFlying = false
	end
	-- Check if Flight Master's License
	if IsSpellKnown(SJMOUNT_CONSTS.AZEROTH_FLYING) then
		SJMount_savedVariables.hasAzerothFlying = true
	else
		SJMount_savedVariables.hasAzerothFlying = false
	end
end

function SJMount_HasMountListChanged()
	local listCount = SJMount_GetMountListCount()
	if listCount == SJMount_numMounts then
		return false
	else
		return true
	end
end

function SJMount_GetMountListCount()
	local listCount = 0
	for v, k in pairs(SJMount_savedVariables.mountList) do
		listCount = listCount + #k
	end
	return listCount
end

function SJMount_UpdateMountList()
	if SJMount_HasMountListChanged() then
		for i = 1, SJMount_numMounts do
			local _, _, mountSpellID, _, _, _ = GetCompanionInfo(MOUNT, i)
			local mountLevel = SJMount_staticMountList[mountSpellID]
			if SJMount_savedVariables.mountList[mountLevel][mountSpellID] == nil then
				SJMount_savedVariables.mountList[mountLevel][mountSpellID] = true
			end
		end
	end
end

function SJMount_IsFlyableArea()
	if IsFlyableArea() then
		if "Wintergrasp" == GetRealZoneText() then
			local _, _, isActive, _, _, _ = GetWorldPVPAreaInfo(1)
			if isActive then
				return false
			end
		elseif "Tol Barad" == GetRealZoneText() then
			local _, _, isActive, _, _, _ = GetWorldPVPAreaInfo(2)
			if isActive then
				return false
			end
		else
			return true
		end
	end
end

function SJMount_SlashCommand()

end