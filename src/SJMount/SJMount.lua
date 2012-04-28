
-- -----------------------------------------------------------------------------
-- Global Variables
-- -----------------------------------------------------------------------------

-- Constants
SJMOUNT_CONSTANTS = {
	["MOUNTLEVELS"] = {
		-- Mount levels
		["MOUNTLEVEL1"] = "GROUND",	-- Ground mounts
		["MOUNTLEVEL2"] = "FLYING",	-- Flying mounts
		["MOUNTLEVEL3"] = "WATER"	-- Swimming mounts
	},
	-- Riding skill level spells
	["RIDINGLEVELS"] = {
		["APPRENTICE"]  	 	= 33388,	-- Apprentice Riding
		["JOURNEYMAN"]   		= 33391,	-- Journeyman Riding
		["EXPERT"]       		= 34090,	-- Expert Riding
		["ARTISAN"]      		= 34091,	-- Artisan Riding
		["MASTER"] 				= 90265,	-- Master Riding
		["NORTHREND_FLYING"] 	= 54197,	-- Cold Weather Flying
		["AZEROTH_FLYING"]   	= 90267		-- Flight Master's License
	},
}

-- Configuration variables
SJMount_configVariables = {
	-- Config variables
	["usingBlacklist"] = false,	-- if using blacklist (false if whitelist is true)
	["usingWhitelist"] = false,	-- if using whitelist (false if blacklist is true)
}

-- Riding skill state variables
SJMount_skillVariables = {
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.APPRENTICE] 		= false,	-- Apprentice Riding
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.JOURNEYMAN] 		= false, 	-- Journeyman Riding
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.EXPERT]     		= false, 	-- Expert Riding
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.ARTISAN]    		= false, 	-- Artisan Riding
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.MASTER]     		= false,	-- Master Riding
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.NORTHREND_FLYING]	= false, 	-- Cold Weather Flying
	[SJMOUNT_CONSTANTS.RIDINGLEVELS.AZEROTH_FLYING]  	= false, 	-- Flight Master's License
}

-- Mount lists
SJMount_mountList = {
	[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL1] = {},
	[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL2] = {},
	[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL3] = {}
}

---
function SJMount_IsValidMountLevel(string)
	if (string) then
		for k, v in pairs(SJMOUNT_CONSTANTS.MOUNTLEVELS) do
			if (string == v) then
				return true
			end
		end
	end
	return false
end

--- Reimplementation of the World of Warcraft API function IsFlyableArea.
-- Reimplementation of the World of Warcraft API function IsFlyableArea to account for world
-- PvP areas Wintergrasp and Tol Barad. Returns false if the player is presently located in
-- either PvP zone and if a battle is currently active in that zone (i.e. battle for Wintergrasp
-- rendering flying mounts unavailable).
-- @return ifFlyable If flight is allowed in the player's current area
function SJMount_IsFlyableArea()
	if (IsFlyableArea()) then
		if ("Wintergrasp" == GetRealZoneText()) then
			local _pvpID, _localizedName, isActive, _canQueue, _waitTime, _canEnter = GetWorldPVPAreaInfo(1)
			if (isActive) then
				return false
			end
		elseif ("Tol Barad" == GetRealZoneText()) then
			local _pvpID, _localizedName, isActive, _canQueue, _waitTime, _canEnter = GetWorldPVPAreaInfo(2)
			if (isActive) then
				return false
			end
		end
	end
	return true
end

--- Update character specific riding skill status saved variables.
-- Updates the values for riding skill status variables used in determining fastest mount level usable for the player character.
function SJMount_UpdateRidingSkills()
	for k, v in pairs(SJMOUNT_CONSTANTS.RIDINGLEVELS) do
		if (IsSpellKnown(v)) then
			SJMount_skillVariables[v] = true
		else
			SJMount_skillVariables[v] = false
		end
	end
end

---
function SJMount_GetBestRidingLevel()
	local bestRidingLevel
	for k, v in pairs(SJMount_skillVariables) do
		if (v) then
			bestRidingLevel = v
		end
	end
	return bestRidingLevel
end

---
function SJMount_HasBestRidingLevelChanged()
	for k1, v1 in pairs(SJMOUNT_CONSTANTS.RIDINGLEVELS) do
		for k2, v2 in pairs(SJMount_skillVariables) do
			if (IsSpellKnown(v1) ~= v2) then
				return true
			end
		end
	end
	return false
end

---
function SJMount_UpdateMountList()
	local numCompanions = GetNumCompanions(MOUNT)
	for index = 1, numCompanions do
		local _creatureID, _creatureName, spellID, _icon, _active, _mountFlag = GetCompanionInfo(MOUNT, index)
		local mountLevel = SJMount_staticMountList[spellID]
		SJMount_mountList[mountLevel][spellID] = index
	end
end

---
function SJMount_GetMountListLength()
	local listCount = 0
	for _k, v in pairs(SJMount_mountList) do
		listCount = listCount + #v
	end
	return listCount
end

---
function SJMount_HasMountListLengthChanged()
	if (SJMount_GetMountListLength() == GetNumCompanions(MOUNT)) then
		return false
	else
		return true
	end
end

---
function SJMount_UpdateAll()
	SJMount_UpdateRidingSkills()
	SJMount_UpdateMountList()
end

---
function SJMount_Use(mountLevel)
	local flyingMountWhenUnflyable = false
	if (IsMounted()) then
		Dismount()
	else
		if(SJMount_IsFlyableArea()) then
		else

		end
	end
end

---
function SJMount_UseRandomMount(mountLevel)
	if (SJMount_IsValidMountLevel(mountLevel)) then
		if (SJMount_mountList[mountLevel]) then
			local randomTable, index = {}, 1
			for _k, v in pairs(SJMount_mountList[mountLevel]) do
				randomTable[index] = v
				index = index + 1
			end
			local randomIndex = randomTable[random(1, #randomTable)]
			CallCompanion(MOUNT, randomIndex)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR: " .. mountLevel .. " level mount list is empty.|r")
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ERROR: Invalid mount level. Use: \"GROUND\", \"FLYING\", \"WATER\".|r")
	end
end

---
function SJMount_UseRandomGroundMount()
	local mountLevel = SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL1
	SJMount_UseRandomMount(mountLevel)
end

---
function SJMount_UseRandomFlyingMount()
	local mountLevel = SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL2
	SJMount_UseRandomMount(mountLevel)
end

---
function SJMount_SlashCommand() end

-- -----------------------------------------------------------------------------
-- UTILITY FUNCTIONS
-- -----------------------------------------------------------------------------

---
function SJMount_PrintSavedVariables()
	for k, v in pairs(SJMount_configVariables) do
		DEFAULT_CHAT_FRAME:AddMessage(format("Config : %s : %s", k, tostring(v)), 0.6, 0.8, 0.7)
	end
	for k, v in pairs(SJMount_skillVariables) do
		DEFAULT_CHAT_FRAME:AddMessage(format("Skills : %s : %s", k, tostring(v)), 0.6, 0.8, 0.7)
	end
	--if (#SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL1] > 0) then
		for k, v in pairs(SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL1]) do
			DEFAULT_CHAT_FRAME:AddMessage(format("Mounts : Ground : %s : %s", k, tostring(v)), 0.6, 0.8, 0.7)
		end
	--end
	--if (#SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL2] > 0) then
		for k, v in pairs(SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL2]) do
			DEFAULT_CHAT_FRAME:AddMessage(format("Mounts : Flying : %s : %s", k, tostring(v)), 0.6, 0.8, 0.7)
		end
	--end
	--if (#SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL3] > 0) then
		for k, v in pairs(SJMount_mountList[SJMOUNT_CONSTANTS.MOUNTLEVELS.MOUNTLEVEL3]) do
			DEFAULT_CHAT_FRAME:AddMessage(format("Mounts : Water  : %s : %s", k, tostring(v)), 0.6, 0.8, 0.7)
		end
	--end
end
