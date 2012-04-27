
--------------------------------------------------------------------------------
-- Global Variables
--------------------------------------------------------------------------------
SJMOUNT_CONSTS = {
	["MOUNTLEVELS"] = {
		-- Mount levels
		["MOUNTLEVEL1"] = "GROUND",	-- Ground mounts
		["MOUNTLEVEL2"] = "FLYING",	-- Flying mounts
		["MOUNTLEVEL3"] = "WATER"	-- Swimming mounts
	},
	-- Riding skill level spells
	["RIDINGLEVELS"] = {
		["APPRENTICE"]   = 33388,	-- Apprentice Riding
		["JOURNEYMAN"]   = 33391,	-- Journeyman Riding
		["EXPERT"]       = 34090,	-- Expert Riding
		["ARTISAN"]      = 34091,	-- Artisan Riding
		["MASTER"]       = 90265,	-- Master Riding
	},
	["NORTHREND_FLYING"] = 54197,	-- Cold Weather Flying
	["AZEROTH_FLYING"]   = 90267	-- Flight Master's License
}
-- Configuration variables
SJMount_configVariables = {
	-- Config variables
	["usingBlacklist"] = false,		-- if using blacklist (false if whitelist is true)
	["usingWhitelist"] = false,		-- if using whitelist (false if blacklist is true)
}
-- Riding skill state variables
SJMount_skillVariables = {
	["ridinglevels"] = {
		["hasApprentice"]  = nil,	-- Apprentice Riding
		["hasJourneyman"]  = nil, 	-- Journeyman Riding
		["hasExpert"]      = nil, 	-- Expert Riding
		["hasArtisan"]     = nil, 	-- Artisan Riding
		["hasMaster"]      = nil, 	-- Master Riding
	},
	["hasNorthrendFlying"] = nil, 	-- Cold Weather Flying
	["hasAzerothFlying"]   = nil, 	-- Flight Master's License
}
-- Mount list tables
SJMount_mountList = {
	[SJMOUNT_CONSTS.MOUNTLEVELS.MOUNTLEVEL1] = {},
	[SJMOUNT_CONSTS.MOUNTLEVELS.MOUNTLEVEL2] = {},
	[SJMOUNT_CONSTS.MOUNTLEVELS.MOUNTLEVEL3] = {}
}

---
function SJMount_IsValidMountLevel(string)
	if (string ~= nil) then
		for k, v in pairs(SJMOUNT_CONSTS.MOUNTLEVELS) do
			if (string == v) then
				return true
			end
		end
	end
	return false
end

---
function SJMount_Use(mountLevel)
	if (IsMounted()) then
		Dismount()
	else

	end
end

---
function SJMount_UseRandomMount(mountLevel)
	if (SJMount_IsValidMountLevel(mountLevel)) then
		if (SJMount_mountList[mountLevel] ~= nil) then
			local randomTable, i = {}, 1
			for _k, v in pairs(SJMount_mountList[mountLevel]) do
				randomTable[i] = v
				i = i + 1
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
function SJMount_HasRidingSkillChanged()
	if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.APPRENTICE) ~= SJMount_skillVariables.hasApprentice) then
		return true
	else
		if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.JOURNEYMAN) ~= SJMount_skillVariables.ridinglevels.hasJourneyman) then
			return true
		else
			if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.EXPERT) ~= SJMount_skillVariables.ridinglevels.hasExpert) then
				return true
			else
				if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.ARTISAN) ~= SJMount_skillVariables.ridinglevels.hasArtisan) then
					return true
				else
					if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.MASTER) ~= SJMount_skillVariables.ridinglevels.hasMaster) then
						return true
					else
						return false
					end
				end
			end
		end
	end
end

--- Update character specific riding skill status saved variables.
-- Updates the values for riding skill status variables used in determining fastest mount level usable for the player character.
function SJMount_UpdateRidingSkill()
	-- Check riding skill level
	-- Master Riding is riding skill level
	if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.MASTER)) then
		SJMount_skillVariables.ridinglevels.hasApprentice = true
		SJMount_skillVariables.ridinglevels.hasJourneyman = true
		SJMount_skillVariables.ridinglevels.hasExpert = true
		SJMount_skillVariables.ridinglevels.hasArtisan = true
		SJMount_skillVariables.ridinglevels.hasMaster = true
	else
		SJMount_skillVariables.ridinglevels.hasMaster = false
		-- Artisan Riding is riding skill level
		if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.ARTISAN)) then
			SJMount_skillVariables.ridinglevels.hasApprentice = true
			SJMount_skillVariables.ridinglevels.hasJourneyman = true
			SJMount_skillVariables.ridinglevels.hasExpert = true
			SJMount_skillVariables.ridinglevels.hasArtisan = true
		else
			SJMount_skillVariables.ridinglevels.hasArtisan = false
			-- Expert Riding is riding skill level
			if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.EXPERT)) then
				SJMount_skillVariables.ridinglevels.hasApprentice = true
				SJMount_skillVariables.ridinglevels.hasJourneyman = true
				SJMount_skillVariables.ridinglevels.hasExpert = true
			else
				SJMount_skillVariables.ridinglevels.hasExpert = false
				-- Journeyman Riding is riding skill level
				if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.JOURNEYMAN)) then
					SJMount_skillVariables.ridinglevels.hasApprentice = true
					SJMount_skillVariables.ridinglevels.hasJourneyman = true
				else
					SJMount_skillVariables.ridinglevels.hasJourneyman = false
					-- Apprentice Riding is riding skill level
					if (IsSpellKnown(SJMOUNT_CONSTS.RIDINGLEVELS.APPRENTICE)) then
						SJMount_skillVariables.ridinglevels.hasApprentice = true
					else
						SJMount_skillVariables.ridinglevels.hasApprentice = false
					end
				end
			end
		end
	end
	-- Check continent specific riding skills
	-- Cold Weather Flying (Northrend)
	if (IsSpellKnown(SJMOUNT_CONSTS.NORTHREND_FLYING)) then
		SJMount_skillVariables.hasNorthrendFlying = true
	else
		SJMount_skillVariables.hasNorthrendFlying = false
	end
	-- Flight Master's License (Azeroth)
	if (IsSpellKnown(SJMOUNT_CONSTS.AZEROTH_FLYING)) then
		SJMount_skillVariables.hasAzerothFlying = true
	else
		SJMount_skillVariables.hasAzerothFlying = false
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
function SJMount_HasMountListChanged()
	if (SJMount_GetMountListLength() == GetNumCompanions(MOUNT)) then
		return false
	else
		return true
	end
end

---
function SJMount_UpdateMountList()
	local numCompanions = GetNumCompanions(MOUNT)
	for i = 1, numCompanions do
		local _creatureID, _creatureName, spellID, _icon, _active, _mountFlag = GetCompanionInfo(MOUNT, i)
		local mountLevel = SJMount_staticMountList[spellID]
		SJMount_mountList[mountLevel][spellID] = i
	end
end

---
function SJMount_UpdateAll()
	SJMount_UpdateRidingSkill()
	SJMount_UpdateMountList()
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
		else
			return true
		end
	end
end

---
function SJMount_SlashCommand() end
