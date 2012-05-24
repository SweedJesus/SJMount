local T, C, L = unpack(select(2, ...))

-- -----------------------------------------------------------------------------
-- CONSTANTS
-- -----------------------------------------------------------------------------

local SJM_MOUNTLEVEL1 	= "GROUND"
local SJM_MOUNTLEVEL2 	= "FLYING"
local SJM_MOUNTLEVEL3	= "WATER"

local SJM_RIDINGSKILLS = {
	APPRENTICE 			= 33388, -- Apprentice Riding 		[Regular Ground]
	JOURNEYMAN 			= 33391, -- Journeyman Riding 		[Epic Ground]
	EXPERT 				= 34090, -- Expert Riding 			[Regular Flying]
	ARTISAN 			= 34091, -- Artisan Riding 			[Epic Flying rank 1]
	MASTER 				= 90265, -- Master Riding 			[Epic Flying rank 2]
	NORTHREND_FLYING	= 54197, -- Cold Weather Flying 	[Northrend Flying]
	AZEROTH_FLYING 		= 90267  -- Flight Master's License	[Azeroth Flying]
}

-- -----------------------------------------------------------------------------
-- STRINGS
-- -----------------------------------------------------------------------------

local SJM_YELLOW1 = "ca9420"
local SJM_YELLOW2 = "e7bf6a"

local SJM_mountName
local SJM_mountIndex

local SJM_ridingSkillStates = {
	apprentice 			= false, -- Apprentice Riding 		[Regular Ground]
	journeyman			= false, -- Journeyman Riding 		[Epic Ground]
	expert 				= false, -- Expert Riding 			[Regular Flying]
	artisan 			= false, -- Artisan Riding 			[Epic Flying rank 1]
	master				= false, -- Master Riding 			[Epic Flying rank 2]
	northrend_flying 	= false, -- Cold Weather Flying 	[Northrend Flying]
	azeroth_flying 		= false	 -- Flight Master's License	[Azeroth Flying]
}

local SJM_states = {
	-- AddOn states
	isInitialized 		= false,
	isRequestingUpdate 	= false,
	isUpdating 			= false,
	-- World states
	canMount 			= false,
	isFlyable 			= false
}

local SJM_linkedList = {
	[SJM_MOUNTLEVEL1] = { -- Linked-list for ground mounts
		mountList 		= {},
		mountListLength = 0,
		randomList 		= {}
	},
	[SJM_MOUNTLEVEL2] = { -- Linked-list for flying mounts
		mountList 		= {},
		mountListLength = 0,
		randomList 		= {}
	},
	[SJM_MOUNTLEVEL3] = { -- Linked-list for water mounts
		mountList 		= {},
		mountListLength = 0,
		randomList 		= {}
	}
	-- IMPLEMENTATION:
	-- SJMount_mountLL.ground.mountList : Indexes are ordered by individual mount Spell ID
	-- SJMount_mountLL.ground.mountList[mountSpellID] : Index of the mount in the spell book table
	--
	-- SJMount_mountLL.ground.randomList : Indexes are ordered numerically (1, 2, 3, etc.)
	-- SJMount_mountLL.ground.randomList[randomIndex] : Reference to the value in the mount list
	--
	-- USAGE:
	-- When selecting a random mount, use the standard lua random function from the range 1 to length of the random
	-- list in selecting a random element of the random list. Since an index from the random list table references a
	-- value from the mount list table, two indexes are available: 1, the spell ID of the mount, and 2, the index of
	-- the mount spell ID in the mount companions tab of the spell-book. Use the second index with the WoW library
	-- function CallCompanion to summon the random mount.
	--
	-- e.g. :	local randomListLength		= #SJMount_mountLL.ground.randomList
	-- 			local randomListIndex		= random(1, randomListLength)
	--			local randomCompanionIndex 	= SJMount_mountLL.ground.randomList[randomListIndex][2]
	--			CallCompanion(MOUNT, randomCompanionIndex)
}

-- Global fields
SJM_commandTable = nil
SJM_blacklist = {}
-- IMPLEMENTATION:
-- If usage is enabled in SJMount_config, mounts on this list will be EXCLUDED from being loaded into the mount linked-list.
-- Enabling both blacklist and whitelist usage will result in both lists being disabled.
--
-- USAGE:
-- ["Spell ID"] = true
-- Set "true" to enable use
-- Set "false" to remove an entry from the list (on next linked-list load)
SJM_whitelist = {}
-- IMPLEMENTATION:
-- If usage is enabled in SJMount_config, ONLY mounts on this list will be loaded into the mount linked-list.
-- Enabling both blacklist and whitelist usage will result in both lists being disabled.
--
-- USAGE:
-- ["Spell ID"] = true
-- Set "true" to enable use
-- Set "false" to remove an entry from the list (on next linked-list load)
SJM_config = {
	-- Blacklist and whitelist
	useBlacklist 			= false,
	useWhitelist			= false,
	-- Toggleable options
	useFlyerWhenUnflyable 	= false,
	debug 					= false
}

-- Global methods
SJM_SlashCommand = nil

--- Reimplementation of the World of Warcraft API function IsFlyableArea.
-- Reimplementation of the World of Warcraft API function IsFlyableArea to account for world PvP areas Wintergrasp
-- and Tol Barad. Returns false if player is presently located in either PvP zone and if a battle is currently active
-- in that zone (i.e. battle for Wintergrasp rendering flying mounts unavailable).
-- @return ifFlyable If flight is allowed in the player's current area
local function SJM_IsFlyableArea()
	if (not IsFlyableArea()) then
		return false
	else
		local zoneText = GetRealZoneText()
		if (zoneText == "Wintergrasp") then
			local _, _, isActive = GetWorldPVPAreaInfo(1)
			return (not isActive)
		elseif (zoneText == "Tol Barad") then
			local _, _, isActive = GetWorldPVPAreaInfo(2)
			return (not isActive)
		elseif (zoneText == "Dalaran") then
			return not (GetSubZoneText() == "Circle of Wills")
		else
			return true
		end
	end
end

local throttle = 20
local counter = 0
---
function SJM_OnUpdate(self, elapsed)
	counter = counter + elapsed
	if (counter >= throttle) then
		DEFAULT_CHAT_FRAME:AddMessage(L.UPDATE_REQUEST)
		counter = 0
	end
end

---
local function SJM_EnableOnUpdateScript(useScript)
	if (useScript) then
		if (not SJM_states.isRequestingUpdate) then
			counter = throttle
			SJM_states.isRequestingUpdate = true
			SJM:SetScript("OnUpdate", SJM_OnUpdate)
		end
	else
		SJM_states.isRequestingUpdate = false
		SJM:SetScript("OnUpdate", nil)
	end
end

---
function SJM_RidingSkillStatesUpdate()
	SJM_ridingSkillStates.apprentice 		= IsSpellKnown(SJM_RIDINGSKILLS.APPRENTICE)
	SJM_ridingSkillStates.journeyman 		= IsSpellKnown(SJM_RIDINGSKILLS.JOURNEYMAN)
	SJM_ridingSkillStates.expert			= IsSpellKnown(SJM_RIDINGSKILLS.EXPERT)
	SJM_ridingSkillStates.artisan 			= IsSpellKnown(SJM_RIDINGSKILLS.ARTISAN)
	SJM_ridingSkillStates.master 			= IsSpellKnown(SJM_RIDINGSKILLS.MASTER)
	SJM_ridingSkillStates.northrend_flying 	= IsSpellKnown(SJM_RIDINGSKILLS.NORTHREND_FLYING)
	SJM_ridingSkillStates.azeroth_flying 	= IsSpellKnown(SJM_RIDINGSKILLS.AZEROTH_FLYING)
	if (IsSpellKnown(SJM_RIDINGSKILLS.MASTER)) then
		SJM_ridingSkillStates.apprentice 	= true
		SJM_ridingSkillStates.journeyman 	= true
		SJM_ridingSkillStates.expert 		= true
		SJM_ridingSkillStates.artisan 		= true
		SJM_ridingSkillStates.master 		= true
	else
		SJM_ridingSkillStates.master 		= false
		if (IsSpellKnown(SJM_RIDINGSKILLS.ARTISAN)) then
			SJM_ridingSkillStates.apprentice 	= true
			SJM_ridingSkillStates.journeyman 	= true
			SJM_ridingSkillStates.expert 		= true
			SJM_ridingSkillStates.artisan 		= true
		else
			SJM_ridingSkillStates.artisan 		= false
			if (IsSpellKnown(SJM_RIDINGSKILLS.EXPERT)) then
				SJM_ridingSkillStates.apprentice 	= true
				SJM_ridingSkillStates.journeyman 	= true
				SJM_ridingSkillStates.expert 		= true
			else
				SJM_ridingSkillStates.expert 		= false
				if (IsSpellKnown(SJM_RIDINGSKILLS.JOURNEYMAN)) then
					SJM_ridingSkillStates.apprentice 	= true
					SJM_ridingSkillStates.journeyman 	= true
				else
					SJM_ridingSkillStates.apprentice 	= IsSpellKnown(SJM_RIDINGSKILLS.APPRENTICE)
					SJM_ridingSkillStates.journeyman 	= false
				end
			end
		end
	end
end

---
local function SJM_LinkedListAddMount(spellID, mountLevel, mountSublevel, companionIndex, usemount)
	if ((mountLevel == SJM_MOUNTLEVEL1) or (mountLevel == SJM_MOUNTLEVEL2) or (mountLevel == SJM_MOUNTLEVEL3)) then
		if (usemount == true) then
			local randomListIndex = (#SJM_linkedList[mountLevel].randomList + 1)
			SJM_linkedList[mountLevel].mountList[spellID] = companionIndex
			SJM_linkedList[mountLevel].randomList[randomListIndex] = SJM_linkedList[mountLevel].mountList[spellID]
			if ((mountLevel == SJM_MOUNTLEVEL2) and SJM_config.useFlyerWhenUnflyable) then
				randomListIndex = (#SJM_linkedList.GROUND.randomList + 1)
				SJM_linkedList[SJM_MOUNTLEVEL1].mountList[spellID] = companionIndex
				SJM_linkedList[SJM_MOUNTLEVEL1].mountListLength = SJM_linkedList[SJM_MOUNTLEVEL1].mountListLength + 1
				SJM_linkedList[SJM_MOUNTLEVEL1].randomList[randomListIndex] = SJM_linkedList[SJM_MOUNTLEVEL1].mountList[spellID]
			end
		else
			SJM_linkedList[mountLevel].mountList[spellID] = false
		end
		SJM_linkedList[mountLevel].mountListLength = SJM_linkedList[mountLevel].mountListLength + 1
	end
end

---
local function SJM_LinkedListUpdate()
	SJM_states.isUpdating = true
	-- Erase mount list length and random list entries
	for k, v1 in pairs(SJM_linkedList) do
		v1.mountListLength = 0
		for k in ipairs(v1.randomList) do
			v1.randomList[k] = nil
		end
	end

	-- If both lists are disable, disable both
	if (SJM_config.useBlacklist and SJM_config.useWhitelist) then
		SJM_config.useBlacklist, SJM_config.useWhitelist = false, false
	end

	local numCompanions = GetNumCompanions(MOUNT)	-- Total number of companion mounts learned
	local _, spellID, mountLevel, mountSublevel, usemount

	for mountIndex = 1, numCompanions do
		_, _, spellID = GetCompanionInfo(MOUNT, mountIndex)
		--local mountSubLevel, mountLevel = strsplit(" ", T.staticMountList[spellID], 2)
		mountLevel = T.staticMountList[spellID]
		if (SJM_config.useBlacklist) then
			usemount = (SJM_blacklist[spellID] == nil)
		elseif (SJM_config.useWhitelist) then
			usemount = (SJM_whitelist[spellID] ~= nil)
		else
			usemount = true
		end
		SJM_LinkedListAddMount(spellID, mountLevel, mountSublevel, mountIndex, usemount)
		-- Clear false blacklist and whitelist entries
		SJM_blacklist[spellID] = (SJM_blacklist[spellID] or nil)
		SJM_whitelist[spellID] = (SJM_whitelist[spellID] or nil)
	end

	SJM_EnableOnUpdateScript(false)
	SJM_states.isUpdating = false
end

---
function SJM_LinkedListUpdateCheck()
	SJM_EnableOnUpdateScript(not (SJM_linkedList.GROUND.mountListLength + SJM_linkedList.FLYING.mountListLength + SJM_linkedList.WATER.mountListLength) == GetNumCompanions(MOUNT))
end

---
local function SJM_GetRandomMountOfLevel(mountLevel)
	if ((mountLevel == SJM_MOUNTLEVEL1) or (mountLevel == SJM_MOUNTLEVEL2) or (mountLevel == SJM_MOUNTLEVEL3)) then
		if (next(SJM_linkedList[mountLevel].randomList)) then
			local randomMountIndex = (random(#SJM_linkedList[mountLevel].randomList))
			local mountIndex = SJM_linkedList[mountLevel].randomList[randomMountIndex]
			local _mountSpellID, mountName = GetCompanionInfo(MOUNT, mountIndex)
			return mountName, mountIndex
		else
			DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_LINKEDLISTEMPTY)
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_INVALIDMOUNTLEVEL)
	end
end

---
local function SJM_GetNewMount()
	if ((not SJM_states.isUpdating) and (not IsIndoors())) then
		if (next(SJM_linkedList.FLYING.mountList)) then
			if (SJM_IsFlyableArea()) then
				SJM_mountName, SJM_mountIndex = SJM_GetRandomMountOfLevel(SJM_MOUNTLEVEL2)
			else
				if (SJM_config.useFlyerWhenUnflyable) then
					local numground = #SJM_linkedList.GROUND.randomList
					local numflying = #SJM_linkedList.FLYING.randomList
					local total = numground + numflying
					if (random(total) < numground) then
						SJM_mountName, SJM_mountIndex = SJM_GetRandomMountOfLevel(SJM_MOUNTLEVEL1)
					else
						SJM_mountName, SJM_mountIndex = SJM_GetRandomMountOfLevel(SJM_MOUNTLEVEL2)
					end
				else
					SJM_mountName, SJM_mountIndex = SJM_GetRandomMountOfLevel(SJM_MOUNTLEVEL1)
				end
			end
		else
			SJM_mountName, SJM_mountIndex = SJM_GetRandomMountOfLevel(SJM_MOUNTLEVEL1)
		end
		if (SJM_config.debug) then
			DEFAULT_CHAT_FRAME:AddMessage("Next mount: " .. SJM_mountName)
		end
	end
end

---
function SJM_MacroUseFunction()
	if (not (IsFlying() and SJM_config.useSafefly) and IsMounted()) then
		Dismount()
	else
		CallCompanion(MOUNT, SJM_mountIndex)
		SJM_GetNewMount()
	end
end

---
function SJM_CheckStates()
	if ((SJM_states.canMount ~= IsIndoors()) or (SJM_states.isFlyable ~= SJM_IsFlyableArea())) then
		SJM_states.canMount = not IsIndoors()
		SJM_states.isFlyable = SJM_IsFlyableArea()
		SJM_GetNewMount()
	end
end

-- -----------------------------------------------------------------------------
-- MACRO FUNCTIONS
-- -----------------------------------------------------------------------------

-- Custom macro tooltip code
local saved_macros = {
	-- ["Macro name"] = "Text to be displayed in the macro tooltip"
	[L.MACRO_NAME] = L.MACRO_TOOLTIPTEXT
}

---
function SetAction(t, slot)
	local name = GetActionText(slot)
	if (name) then
		local text = saved_macros[name]
		GameTooltip:AddLine(text, 0.9, 0.8, 0.0, true)
		GameTooltip:Show()
	end
end

local key = "GameTooltip"
local frame =  getglobal(key)
hooksecurefunc(frame, "SetAction", SetAction)

---
local function SJM_WriteMacro()
	if (not InCombatLockdown()) then
		local macroIndex = GetMacroIndexByName(L.MACRO_NAME)
		if (macroIndex == 0) then
			CreateMacro(
				L.MACRO_NAME,							-- Macro name
				L.MACRO_ICON,							-- Macro icon
				format(L.MACRO_BODY),	-- Macro body
				1										-- 1 for per-character macro
			)
		else
			EditMacro(
				macroIndex,								-- Macro index
				L.MACRO_NAME,							-- Macro name (nil for no change)
				L.MACRO_ICON,							-- Macro icon (nil for no change)
				format(L.MACRO_BODY)	-- Macro body (nil for no change)
			)
		end
	end
end

---
function T.Init()
	SJM_RidingSkillStatesUpdate()
	if (SJM_ridingSkillStates.apprentice) then
		SJM_LinkedListUpdate()
		SJM_WriteMacro()
		SJM_CheckStates()
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_NORIDINGSKILLKNOWN)
		DisableAddOn(SJM_NAME)
	end
end

-- -----------------------------------------------------------------------------
-- SLASH COMMAND FUNCTIONS
-- -----------------------------------------------------------------------------

local PATTERN_SPELLLINK  = "(|c%x+|H%a*:%d*|h%[[%a%s]*%]|h|r)"
local PATTERN_SPELLID = "|c%x+|H%a*:(%d*)|h%[[%a%s]*%]|h|r"

local SJM_commandTable
local SJM_CT_AddMounts

---
function SJM_CT_AddMounts(arg1, arg2, arg3)
	local list
	if (arg3 == L.TOKEN_BLACKLIST) then
		list = SJM_blacklist
	elseif (arg3 == L.TOKEN_WHITELIST) then
		list = SJM_whitelist
	end
	arg3 = strlower(arg3)
	local enableOnUpdateScript
	if (arg1) then
		local add, spellID = ((arg2 == 1) or nil), nil
		for spellLink in gmatch(arg1, PATTERN_SPELLLINK) do
			spellID = tonumber(strmatch(spellLink, PATTERN_SPELLID))
			if (T.staticMountList[spellID]) then
				list[spellID] = add
				if (add) then
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_ADD_LIST_SUCCESS, spellLink, arg3))
				else
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_REMOVE_LIST_SUCCESS, spellLink, arg3))
				end
				enableOnUpdateScript = true
			end
		end
	end
	if (enableOnUpdateScript) then
		SJM_EnableOnUpdateScript(true)
	else
		SJM_SlashCommand(arg3, SJM_commandTable[strlower(L.TOKEN_ADD)][strlower(L.TOKEN_HELP)])
	end
end

SJM_commandTable = {
	[strlower(L.TOKEN_UPDATE)] = function()
		SJM_LinkedListUpdate()
		SJM_GetNewMount()
		DEFAULT_CHAT_FRAME:AddMessage(L.CT_UPDATE)
	end,
	[strlower(L.TOKEN_CONFIG)] = {
		[strlower(L.TOKEN_STATUS)] = function()
			if (SJM_config.useBlacklist) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS1, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS1, L.STRING_OFF))
			end
			if (SJM_config.useWhitelist) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS2, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS2, L.STRING_OFF))
			end
			if (SJM_config.useFlyerWhenUnflyable) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS3, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS3, L.STRING_OFF))
			end
		end,
		["1"] = function()
			if (not SJM_config.useBlacklist) then
				SJM_config.useBlacklist = true
				SJM_config.useWhitelist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLEDLIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_WHITELIST)))
			else
				SJM_config.useBlacklist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, strlower(L.TOKEN_BLACKLIST)))
			end
			SJM_EnableOnUpdateScript(true)
		end,
		["2"] = function()
			if (not SJM_config.useWhitelist) then
				SJM_config.useWhitelist = true
				SJM_config.useBlacklist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLEDLIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_BLACKLIST)))
			else
				SJM_config.useWhitelist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, strlower(L.TOKEN_WHITELIST)))
			end
			SJM_EnableOnUpdateScript(true)
		end,
		["3"] = function()
			if (not SJM_config.useFlyerWhenUnflyable) then
				SJM_config.useFlyerWhenUnflyable = true
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLED, L.STRING_USEFLYERWHENUNFLYABLE))
			else
				SJM_config.useFlyerWhenUnflyable = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, L.STRING_USEFLYERWHENUNFLYABLE))
			end
		end,
		["debug"] = function()
			if (not SJM_config.debug) then
				SJM_config.debug = true
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLED, L.STRING_DEBUGGINGMESSAGES))
			else
				SJM_config.debug = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, L.STRING_DEBUGGINGMESSAGES))
			end
		end,
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_STATUS)] 	= L.CT_CONFIG_HELP_STATUS,
			["1"] 						= L.CT_CONFIG_HELP_1,
			["2"] 						= L.CT_CONFIG_HELP_2,
			["3"] 						= L.CT_CONFIG_HELP_3,
			[strlower(L.TOKEN_HELP)] 	= L.CT_CONFIG_HELP
		}
	},
	[strlower(L.TOKEN_ADD)] = {
		[strlower(L.TOKEN_BLACKLIST)] = function(arg1)
			SJM_CT_AddMounts(arg1, 1, L.TOKEN_BLACKLIST)
		end,
		[strlower(L.TOKEN_WHITELIST)] = function(arg1)
			SJM_CT_AddMounts(arg1, 1, L.TOKEN_WHITELIST)
		end,
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_BLACKLIST)] 	= format(L.CT_ADD_HELP_LIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_BLACKLIST)),
			[strlower(L.TOKEN_WHITELIST)] 	= format(L.CT_ADD_HELP_LIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_WHITELIST)),
			[strlower(L.TOKEN_HELP)] 		= L.CT_ADD_HELP
		}
	},
	[strlower(L.TOKEN_REMOVE)] = {
		[strlower(L.TOKEN_BLACKLIST)] = function(arg1)
			SJM_CT_AddMounts(arg1, 0, L.TOKEN_BLACKLIST)
		end,
		[strlower(L.TOKEN_WHITELIST)] = function(arg1)
			SJM_CT_AddMounts(arg1, 0, L.TOKEN_WHITELIST)
		end,
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_BLACKLIST)] 	= format(L.CT_REMOVE_HELP_LIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_BLACKLIST)),
			[strlower(L.TOKEN_WHITELIST)] 	= format(L.CT_REMOVE_HELP_LIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_WHITELIST)),
			[strlower(L.TOKEN_HELP)] 		= L.CT_REMOVE_HELP
		}
	},
	[strlower(L.TOKEN_PRINT)] = {
		[strlower(L.TOKEN_BLACKLIST)] = function()
			DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_BLACKLIST)))
			if (next(SJM_blacklist)) then
				for v in pairs(SJM_blacklist) do
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_BLACKLIST), GetSpellLink(v)))
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_EMPTY, strlower(L.TOKEN_BLACKLIST)))
			end
		end,
		[strlower(L.TOKEN_WHITELIST)] = function()
			DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_WHITELIST)))
			if (next(SJM_whitelist)) then
				for v in pairs(SJM_whitelist) do
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_WHITELIST), GetSpellLink(v)))
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_EMPTY, strlower(L.TOKEN_WHITELIST)))
			end
		end,
		[strlower(L.TOKEN_LINKEDLIST)] = function(showAll)
			if (showAll == "true") then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_LINKEDLIST) .. " (all)"))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_LINKEDLIST)))
			end
			local hasEntries = false
			if (next(SJM_linkedList[SJM_MOUNTLEVEL1].mountList)) then
				hasEntries = true
				for k, v in pairs(SJM_linkedList[SJM_MOUNTLEVEL1].mountList) do
					if ((showAll == "true") or (v ~= false)) then
						DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_LINKEDLIST), GetSpellLink(k)))
					end
				end
			end
			if (next(SJM_linkedList[SJM_MOUNTLEVEL2].mountList)) then
				hasEntries = true
				for k, v in pairs(SJM_linkedList[SJM_MOUNTLEVEL2].mountList) do
					if ((showAll == "true") or (v ~= false)) then
						DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_LINKEDLIST), GetSpellLink(k)))
					end
				end
			end
			if (next(SJM_linkedList[SJM_MOUNTLEVEL3].mountList)) then
				hasEntries = true
				for k, v in pairs(SJM_linkedList[SJM_MOUNTLEVEL3].mountList) do
					if ((showAll == "true") or (v ~= false)) then
						DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_LINKEDLIST), GetSpellLink(k)))
					end
				end
			end
			if (not hasEntries) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_EMPTY, strlower(L.TOKEN_LINKEDLIST)))
			end
		end,
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_BLACKLIST)] 	= format(L.CT_PRINT_HELP_LIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_BLACKLIST)),
			[strlower(L.TOKEN_WHITELIST)] 	= format(L.CT_PRINT_HELP_LIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_WHITELIST)),
			[strlower(L.TOKEN_LINKEDLIST)] 	= format(L.CT_PRINT_HELP_LIST, strlower(L.TOKEN_LINKEDLIST), strlower(L.TOKEN_LINKEDLIST)),
			[strlower(L.TOKEN_HELP)] 		= L.CT_PRINT_HELP
		}
	},
	[strlower(L.TOKEN_HELP)] = {
		[strlower(L.TOKEN_UPDATE)] 	= L.CT_HELP_UPDATE,
		[strlower(L.TOKEN_CONFIG)] 	= L.CT_HELP_CONFIG,
		[strlower(L.TOKEN_ADD)] 	= L.CT_HELP_ADD,
		[strlower(L.TOKEN_REMOVE)] 	= L.CT_HELP_REMOVE,
		[strlower(L.TOKEN_PRINT)] 	= L.CT_HELP_PRINT,
		[strlower(L.TOKEN_HELP)] 	= L.CT_HELP
	}
}

function SJM_SlashCommand(msg, cmdTable)
	-- CHARACTER CLASS:
	--     x : (where x is not one of the magic characters ^$()%.[]*+-?) represents the character x itself.
	--     . : (a dot) represents all characters.
	--    %a : represents all letters.
	--    %c : represents all control characters.
	--    %d : represents all digits.
	--    %l : represents all lowercase letters.
	--    %p : represents all punctuation characters.
	--    %s : represents all space characters.
	--    %u : represents all uppercase letters.
	--    %w : represents all alphanumeric characters.
	--    %x : represents all hexadecimal digits.
	--    %z : represents the character with representation 0.
	--    %x : (where x is any non-alphanumeric character) represents the character x. This is the standard way to
	--         escape the magic characters. Any punctuation character (even the non magic) can be preceded by a '%'
	--         when used to represent itself in a pattern.
	-- [set] : represents the class which is the union of all characters in set. A range of characters can be specified
	--         by separating the end characters of the range with a '-'. All classes %x described above can also be
	--         used as components in set. All other characters in set represent themselves.
	-- [^set]: represents the complement of set, where set is interpreted as above.
	--
	-- PATTERN ITEM:
	--  single character class : any single character in the class.
	--  single character class
	--       followed by a [-] : zero or more repetitions of characters in the class. Always matches
	--                           the shortest possible sequence.
	--  single character class
	--       followed by a [*] : zero or more repetitions of a character in the class. Always matches
	--                           the longest possible sequence.
	--  single character class
	--       followed by a [+] : one or more repetitions of characters in the class. Always matches
	--                           the longest possible sequence.
	--  single character class
	--       followed by a [?] : zero or one occurrence of a character in the class. Always matches one
	--                           occurrence if it is possible to do so.
	--                      %n : for n between 1 and 9; matches a substring equal to the nth capture string
	-- %bxy, where x and y are :
	-- two distinct characters :
	--
	-- PATTERN:
	-- ^ : at the beginning of a pattern anchors the match at the beginning of the subject string.
	-- $ : at the end of a pattern anchors the match at the end of the subject string.
	--     (At other positions, '^' and '$' have no special meaning and represent themselves. )
	--
	-- CAPTURES:
	-- When a match succeeds, the substrings of the subject string that match captures are stored (captured) for
	-- future use. Captures are numbered according to their left parentheses. As a special case, the empty capture ()
	-- captures the current string position (a number). A pattern cannot contain embedded zeros. Use %z instead.

	cmdTable = cmdTable or SJM_commandTable

	local command, parameters = string.split(" ", msg, 2)
	local entry = cmdTable[strlower(command)]
	local which = type(entry)

	if (which == "function") then
		entry(parameters)
	elseif (which == "table") then
		SJM_SlashCommand(parameters or "", entry)
	elseif (which == "string") then
		DEFAULT_CHAT_FRAME:AddMessage(entry)
	elseif (msg ~= strlower(L.TOKEN_HELP)) then
		SJM_SlashCommand(strlower(L.TOKEN_HELP), cmdTable)
	end
end
