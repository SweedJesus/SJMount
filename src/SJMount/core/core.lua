local T, C, L = unpack(select(2, ...))

-- Yellow 1 "ca9420"
-- Yellow 2 "e7bf6a"

-- Mount level tags (comparison use)
local MOUNTLEVEL1 	= "GROUND"
local MOUNTLEVEL2 	= "FLYING"
local MOUNTLEVEL3	= "WATER"
-- Riding skill spell IDs
local RIDINGSKILLS = {
	APPRENTICE 			= 33388, -- Apprentice Riding 		[Regular Ground]
	JOURNEYMAN 			= 33391, -- Journeyman Riding 		[Epic Ground]
	EXPERT 				= 34090, -- Expert Riding 			[Regular Flying]
	ARTISAN 			= 34091, -- Artisan Riding 			[Epic Flying rank 1]
	MASTER 				= 90265, -- Master Riding 			[Epic Flying rank 2]
	NORTHREND_FLYING	= 54197, -- Cold Weather Flying 	[Northrend Flying]
	AZEROTH_FLYING 		= 90267  -- Flight Master's License	[Azeroth Flying]
}
-- Regex patterns for blacklist/whitelist additions/removals
local PATTERN_SPELLLINK  = "(|c%x+|H%a*:%d*|h%[[%a%s]*%]|h|r)"
local PATTERN_SPELLID = "|c%x+|H%a*:(%d*)|h%[[%a%s]*%]|h|r"
-- T.OnUpdate throttle and counter (20 second delay)
local THROTTLE, counter = 20.0, 0
-- State variables
T.states = {
	-- Riding skill states
	ridingSkills = {
		apprentice 			= false, -- Apprentice Riding 		[Regular Ground]
		journeyman			= false, -- Journeyman Riding 		[Epic Ground]
		expert 				= false, -- Expert Riding 			[Regular Flying]
		artisan 			= false, -- Artisan Riding 			[Epic Flying rank 1]
		master				= false, -- Master Riding 			[Epic Flying rank 2]
		northrend_flying 	= false, -- Cold Weather Flying 	[Northrend Flying]
		azeroth_flying 		= false	 -- Flight Master's License	[Azeroth Flying]
	},
	-- AddOn states
	isInitialized 		= false,
	isRequestingUpdate 	= false,
	isUpdating 			= false,
	-- World states
	canMount 			= nil,
	isFlyable 			= nil
}
-- Mount linked-list
T.linkedList = {
	[MOUNTLEVEL1] = { -- Linked-list for ground mounts
		mountList 				= {},
		mountListLength_Total 	= 0,
		mountListLength_Active 	= 0,
		randomList 				= {}
	},
	[MOUNTLEVEL2] = { -- Linked-list for flying mounts
		mountList 				= {},
		mountListLength_Total 	= 0,
		mountListLength_Active 	= 0,
		randomList 				= {}
	},
	[MOUNTLEVEL3] = { -- Linked-list for water mounts
		mountList 				= {},
		mountListLength_Total 	= 0,
		mountListLength_Active 	= 0,
		randomList 				= {}
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
-- Name and index of the next mount to be called
T.mountName, T.mountIndex = nil, nil
-- Saved variables
SJMountDataPerChar = {
	["blacklist"] 				= {
		-- [Spell ID], (Mounts to be blacklisted from random-mount selection)
	},
	["whitelist"] 				= {
		-- [Spell ID], (Mounts to be whitelisted in random-mount selection)
	},
	["useBlacklist"] 			= false,
	["useWhitelist"] 			= false,
	["useFlyerWhenUnflyable"] 	= false,
	["debug"] 					= false
}

--- In-game macro function
-- If
function SJMountUse()
	if (T.mountIndex) then
		if (IsMounted()) then
			Dismount()
		else
			CallCompanion(MOUNT, T.mountIndex)
			T.GetNewMount()
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_LINKEDLISTEMPTY)
	end
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420SJMountUse|r] T.mountIndex:%s", tostring(T.mountIndex)))
	end
end

--- Reimplementation of the World of Warcraft API function IsFlyableArea.
-- Reimplementation of the World of Warcraft API function IsFlyableArea to account for world PvP areas Wintergrasp
-- and Tol Barad. Returns false if player is presently located in either PvP zone and if a battle is currently active
-- in that zone (i.e. battle for Wintergrasp rendering flying mounts unavailable).
-- @return ifFlyable If flight is allowed in the player's current area
function T.IsFlyableArea()
	if (not IsFlyableArea()) then
		return false
	else
		local zoneText = GetRealZoneText()
		if (zoneText == L.WINTERGRASP) then
			local _, _, isActive = GetWorldPVPAreaInfo(1)
			return (not isActive)
		elseif (zoneText == L.TOL_BARAD) then
			local _, _, isActive = GetWorldPVPAreaInfo(2)
			return (not isActive)
		elseif (zoneText == L.DALARAN) then
			return not (GetSubZoneText() == L.CIRCLE_OF_WILLS)
		else
			return true
		end
	end
end

---
function T.MacroTextAdd(t, slot)
	local name = GetActionText(slot)
	if (name == L.MACRO_NAME) then
		GameTooltip:AddLine(L.MACRO_TOOLTIPTEXT, 0.9, 0.8, 0.0, true)
		GameTooltip:Show()
	end
end

---
function T.OnUpdate(self, elapsed)
	counter = counter + elapsed
	if (counter >= THROTTLE) then
		DEFAULT_CHAT_FRAME:AddMessage(L.UPDATE_REQUEST)
		counter = 0
	end
end

---
-- @param arg1 true to enable, false to disable
--
function T.EnableOnUpdateScript(arg1)
	if (arg1) then
		if (not T.states.isRequestingUpdate) then
			counter = THROTTLE
			T.states.isRequestingUpdate = true
			SJM:SetScript("OnUpdate", T.OnUpdate)
		end
	else
		T.states.isRequestingUpdate = false
		SJM:SetScript("OnUpdate", nil)
	end
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420EnableOnUpdateScript|r] arg1:%s", tostring(arg1)))
	end
end

---
function T.RidingSkillStatesUpdate()
	T.states.ridingSkills.apprentice 		= IsSpellKnown(RIDINGSKILLS.APPRENTICE)
	T.states.ridingSkills.journeyman 		= IsSpellKnown(RIDINGSKILLS.JOURNEYMAN)
	T.states.ridingSkills.expert			= IsSpellKnown(RIDINGSKILLS.EXPERT)
	T.states.ridingSkills.artisan 			= IsSpellKnown(RIDINGSKILLS.ARTISAN)
	T.states.ridingSkills.master 			= IsSpellKnown(RIDINGSKILLS.MASTER)
	T.states.ridingSkills.northrend_flying 	= IsSpellKnown(RIDINGSKILLS.NORTHREND_FLYING)
	T.states.ridingSkills.azeroth_flying 	= IsSpellKnown(RIDINGSKILLS.AZEROTH_FLYING)
	if (IsSpellKnown(RIDINGSKILLS.MASTER)) then
		T.states.ridingSkills.apprentice 	= true
		T.states.ridingSkills.journeyman 	= true
		T.states.ridingSkills.expert 		= true
		T.states.ridingSkills.artisan 		= true
		T.states.ridingSkills.master 		= true
	else
		T.states.ridingSkills.master 		= false
		if (IsSpellKnown(RIDINGSKILLS.ARTISAN)) then
			T.states.ridingSkills.apprentice 	= true
			T.states.ridingSkills.journeyman 	= true
			T.states.ridingSkills.expert 		= true
			T.states.ridingSkills.artisan 		= true
		else
			T.states.ridingSkills.artisan 		= false
			if (IsSpellKnown(RIDINGSKILLS.EXPERT)) then
				T.states.ridingSkills.apprentice 	= true
				T.states.ridingSkills.journeyman 	= true
				T.states.ridingSkills.expert 		= true
			else
				T.states.ridingSkills.expert 		= false
				if (IsSpellKnown(RIDINGSKILLS.JOURNEYMAN)) then
					T.states.ridingSkills.apprentice 	= true
					T.states.ridingSkills.journeyman 	= true
				else
					T.states.ridingSkills.apprentice 	= IsSpellKnown(RIDINGSKILLS.APPRENTICE)
					T.states.ridingSkills.journeyman 	= false
				end
			end
		end
	end
end

---
function T.CheckStates()
	local canmount1, isflyable1 = T.states.canMount, T.states.isFlyable
	local canmount2, isflyable2 = not IsIndoors(), T.IsFlyableArea()
	local getnewmount = false
	if ((canmount1 ~= canmount2) or (isflyable1 ~= isflyable2)) then
		T.states.canMount = canmount2
		T.states.isFlyable = isflyable2
		getnewmount = true
	end
	if getnewmount then T.GetNewMount() end
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420CheckStates|r] canmount1:%s canmount2:%s isflyable1:%s isflyable2:%s getnewmount:%s", tostring(canmount1), tostring(canmount2), tostring(isflyable1), tostring(isflyable2), tostring(getnewmount)))
	end
end

---
-- @param arg1 mount spell ID
-- @param arg2 mount level token
-- @param arg3 mount companion index
-- @param arg4 if to be used in random mount selection
--
function T.LinkedListAddMount(arg1, arg2, arg3, arg4)
	if ((arg2 == MOUNTLEVEL1) or (arg2 == MOUNTLEVEL2) or (arg2 == MOUNTLEVEL3)) then
		if (arg4 == true) then
			local randomListIndex = (#T.linkedList[arg2].randomList + 1)
			T.linkedList[arg2].mountList[arg1] = arg3
			T.linkedList[arg2].mountListLength_Active = T.linkedList[arg2].mountListLength_Active + 1
			T.linkedList[arg2].randomList[randomListIndex] = T.linkedList[arg2].mountList[arg1]
			if ((arg2 == MOUNTLEVEL2) and SJMountDataPerChar.useFlyerWhenUnflyable) then
				randomListIndex = (#T.linkedList.GROUND.randomList + 1)
				T.linkedList[MOUNTLEVEL1].mountList[arg1] = arg3
				T.linkedList[MOUNTLEVEL1].mountListLength_Total = T.linkedList[MOUNTLEVEL1].mountListLength_Total + 1
				T.linkedList[MOUNTLEVEL1].mountListLength_Active = T.linkedList[MOUNTLEVEL1].mountListLength_Active + 1
				T.linkedList[MOUNTLEVEL1].randomList[randomListIndex] = T.linkedList[MOUNTLEVEL1].mountList[arg1]
			end
		else
			T.linkedList[arg2].mountList[arg1] = false
		end
		T.linkedList[arg2].mountListLength_Total = T.linkedList[arg2].mountListLength_Total + 1
	end
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420LinkedListAddMount|r] arg1:%s arg2:%s arg3:%s arg4:%s", arg1, arg2, arg3, tostring(arg4)))
	end
end

---
function T.LinkedListUpdate()
	T.states.isUpdating = true
	-- Erase mount list length and random list entries
	for k, v1 in pairs(T.linkedList) do
		v1.mountListLength_Total, v1.mountListLength_Active = 0, 0
		for k in ipairs(v1.randomList) do
			v1.randomList[k] = nil
		end
	end

	-- If both lists are disable, disable both
	if (SJMountDataPerChar.useBlacklist and SJMountDataPerChar.useWhitelist) then
		SJMountDataPerChar.useBlacklist, SJMountDataPerChar.useWhitelist = false, false
	end

	local numCompanions = GetNumCompanions(MOUNT)	-- Total number of companion mounts learned
	local _, spellID, mountLevel, usemount

	for mountIndex = 1, numCompanions do
		_, _, spellID = GetCompanionInfo(MOUNT, mountIndex)
		mountLevel = T.staticMountList[spellID]
		if (SJMountDataPerChar.useBlacklist) then
			usemount = (SJMountDataPerChar.blacklist[spellID] == nil)
		elseif (SJMountDataPerChar.useWhitelist) then
			usemount = (SJMountDataPerChar.whitelist[spellID] ~= nil)
		else
			usemount = true
		end
		T.LinkedListAddMount(spellID, mountLevel, mountIndex, usemount)
		-- Clear false blacklist and whitelist entries
		SJMountDataPerChar.blacklist[spellID] = (SJMountDataPerChar.blacklist[spellID] or nil)
		SJMountDataPerChar.whitelist[spellID] = (SJMountDataPerChar.whitelist[spellID] or nil)
	end

	T.EnableOnUpdateScript(false)
	T.states.isUpdating = false
end

---
function T.LinkedListUpdateCheck()
	local linkedlistlength_total = T.linkedList.GROUND.mountListLength_Total + T.linkedList.FLYING.mountListLength_Total + T.linkedList.WATER.mountListLength_Total
	local enableonupdatescript = (not linkedlistlength_total == GetNumCompanions(MOUNT))
	T.EnableOnUpdateScript(enableonupdatescript)
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420LinkedListUpdateCheck|r] linkedlistlength_total:%s enableonupdatescript:%s", linkedlistlength_total, tostring(enableonupdatescript)))
	end
end

---
-- @param arg1 mount level token
--
function T.GetRandomMountOfLevel(arg1)
	if ((arg1 == MOUNTLEVEL1) or (arg1 == MOUNTLEVEL2) or (arg1 == MOUNTLEVEL3)) then
		local mountName, mountIndex
		if (next(T.linkedList[arg1].randomList)) then
			local randomMountIndex, _mountSpellID
			randomMountIndex = (random(#T.linkedList[arg1].randomList))
			mountIndex = T.linkedList[arg1].randomList[randomMountIndex]
			_mountSpellID, mountName = GetCompanionInfo(MOUNT, mountIndex)
		else
			DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_LINKEDLISTEMPTY)
		end
		if (SJMountDataPerChar.debug) then
			DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420GetRandomMountOfLevel|r] mountlevel:%s mountname:%s mountindex:%s", arg1, tostring(mountName), tostring(mountIndex)))
		end
		return mountName, mountIndex
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_INVALIDMOUNTLEVEL)
	end
end

---
function T.GetNewMount()
	if ((not T.states.isUpdating) and (not IsIndoors())) then
		if (next(T.linkedList.FLYING.mountList)) then
			if (IsFlyableArea()) then
				T.mountName, T.mountIndex = T.GetRandomMountOfLevel(MOUNTLEVEL2)
			else
				if (SJMountDataPerChar.useFlyerWhenUnflyable) then
					local numground = #T.linkedList.GROUND.randomList
					local total = numground + #T.linkedList.FLYING.randomList
					if (random(total) < numground) then
						T.mountName, T.mountIndex = T.GetRandomMountOfLevel(MOUNTLEVEL1)
					else
						T.mountName, T.mountIndex = T.GetRandomMountOfLevel(MOUNTLEVEL2)
					end
				else
					T.mountName, T.mountIndex = T.GetRandomMountOfLevel(MOUNTLEVEL1)
				end
			end
		else
			T.mountName, T.mountIndex = T.GetRandomMountOfLevel(MOUNTLEVEL1)
		end
	else
		T.mountName, T.mountIndex = nil, nil
	end
	if (SJMountDataPerChar.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420GetNewMount|r] T.mountName:%s T.mountIndex:%s", tostring(T.mountName), tostring(T.mountIndex)))
	end
end

---
function T.WriteMacro()
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
	T.RidingSkillStatesUpdate()
	if (T.states.ridingSkills.apprentice) then
		T.LinkedListUpdate()
		T.WriteMacro()
		T.CheckStates()
		-- Macro tooltip
		hooksecurefunc(getglobal("GameTooltip"), "SetAction", T.MacroTextAdd)
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.ERROR_NORIDINGSKILLKNOWN)
		DisableAddOn(T.addonName)
	end
end

---
-- @param arg1 string to tokenize
-- @param arg2 1 to add, 0 (or not 1) to remove
-- @param arg3 blacklist or whitelist localized token
--
function T.AddMounts(arg1, arg2, arg3)
	local list
	if (arg3 == L.TOKEN_BLACKLIST) then
		list = SJMountDataPerChar.blacklist
	elseif (arg3 == L.TOKEN_WHITELIST) then
		list = SJMountDataPerChar.whitelist
	end
	arg3 = strlower(arg3)
	local enableonupdatescript
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
				enableonupdatescript = true
			end
		end
	end
	if (enableonupdatescript) then
		T.EnableOnUpdateScript(true)
	else
		T.SlashCommand(arg3, T.commandTable[strlower(L.TOKEN_ADD)][strlower(L.TOKEN_HELP)])
	end
end

T.commandTable = {
	[strlower(L.TOKEN_UPDATE)] = function()
		T.LinkedListUpdate()
		T.GetNewMount()
		DEFAULT_CHAT_FRAME:AddMessage(L.CT_UPDATE)
	end,
	[strlower(L.TOKEN_CONFIG)] = {
		[strlower(L.TOKEN_STATUS)] = function()
			if (SJMountDataPerChar.useBlacklist) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS1, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS1, L.STRING_OFF))
			end
			if (SJMountDataPerChar.useWhitelist) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS2, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS2, L.STRING_OFF))
			end
			if (SJMountDataPerChar.useFlyerWhenUnflyable) then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS3, L.STRING_ON))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_STATUS3, L.STRING_OFF))
			end
		end,
		["1"] = function()
			if (not SJMountDataPerChar.useBlacklist) then
				SJMountDataPerChar.useBlacklist = true
				SJMountDataPerChar.useWhitelist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLEDLIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_WHITELIST)))
			else
				SJMountDataPerChar.useBlacklist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, strlower(L.TOKEN_BLACKLIST)))
			end
			T.EnableOnUpdateScript(true)
		end,
		["2"] = function()
			if (not SJMountDataPerChar.useWhitelist) then
				SJMountDataPerChar.useWhitelist = true
				SJMountDataPerChar.useBlacklist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLEDLIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_BLACKLIST)))
			else
				SJMountDataPerChar.useWhitelist = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, strlower(L.TOKEN_WHITELIST)))
			end
			T.EnableOnUpdateScript(true)
		end,
		["3"] = function()
			if (not SJMountDataPerChar.useFlyerWhenUnflyable) then
				SJMountDataPerChar.useFlyerWhenUnflyable = true
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLED, L.STRING_USEFLYERWHENUNFLYABLE))
			else
				SJMountDataPerChar.useFlyerWhenUnflyable = false
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_DISABLED, L.STRING_USEFLYERWHENUNFLYABLE))
			end
		end,
		["debug"] = function()
			if (not SJMountDataPerChar.debug) then
				SJMountDataPerChar.debug = true
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_CONFIG_TOGGLE_ENABLED, L.STRING_DEBUGGINGMESSAGES))
			else
				SJMountDataPerChar.debug = false
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
			T.AddMounts(arg1, 1, L.TOKEN_BLACKLIST)
		end,
		[strlower(L.TOKEN_WHITELIST)] = function(arg1)
			T.AddMounts(arg1, 1, L.TOKEN_WHITELIST)
		end,
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_BLACKLIST)] 	= format(L.CT_ADD_HELP_LIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_BLACKLIST)),
			[strlower(L.TOKEN_WHITELIST)] 	= format(L.CT_ADD_HELP_LIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_WHITELIST)),
			[strlower(L.TOKEN_HELP)] 		= L.CT_ADD_HELP
		}
	},
	[strlower(L.TOKEN_REMOVE)] = {
		[strlower(L.TOKEN_BLACKLIST)] = {
			[strlower(L.TOKEN_ALL)] = function()
				if (next(SJMountDataPerChar.blacklist)) then
					for v in pairs(SJMountDataPerChar.blacklist) do
						SJMountDataPerChar.blacklist[v] = nil
					end
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_REMOVE_LIST_ALL, strlower(L.TOKEN_BLACKLIST)))
				else
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_REMOVE_LIST_EMPTY, strlower(L.TOKEN_BLACKLIST)))
				end
			end,
			[strlower(L.TOKEN_HELP)] = function(arg1)
				T.AddMounts(arg1, 0, L.TOKEN_BLACKLIST)
			end
		},
		[strlower(L.TOKEN_WHITELIST)] = {
			[strlower(L.TOKEN_ALL)] = function()
				if (next(SJMountDataPerChar.whitelist)) then
					for v in pairs(SJMountDataPerChar.whitelist) do
						SJMountDataPerChar.whitelist[v] = nil
					end
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_REMOVE_LIST_ALL, strlower(L.TOKEN_WHITELIST)))
				else
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_REMOVE_LIST_EMPTY, strlower(L.TOKEN_WHITELIST)))
				end
			end,
			[strlower(L.TOKEN_HELP)] = function(arg1)
				T.AddMounts(arg1, 0, L.TOKEN_WHITELIST)
			end
		},
		[strlower(L.TOKEN_HELP)] = {
			[strlower(L.TOKEN_BLACKLIST)] 	= format(L.CT_REMOVE_HELP_LIST, strlower(L.TOKEN_BLACKLIST), strlower(L.TOKEN_BLACKLIST)),
			[strlower(L.TOKEN_WHITELIST)] 	= format(L.CT_REMOVE_HELP_LIST, strlower(L.TOKEN_WHITELIST), strlower(L.TOKEN_WHITELIST)),
			[strlower(L.TOKEN_HELP)] 		= L.CT_REMOVE_HELP
		}
	},
	[strlower(L.TOKEN_PRINT)] = {
		[strlower(L.TOKEN_BLACKLIST)] = function()
			DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_BLACKLIST)))
			if (next(SJMountDataPerChar.blacklist)) then
				for v in pairs(SJMountDataPerChar.blacklist) do
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_BLACKLIST), GetSpellLink(v)))
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_EMPTY, strlower(L.TOKEN_BLACKLIST)))
			end
		end,
		[strlower(L.TOKEN_WHITELIST)] = function()
			DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_WHITELIST)))
			if (next(SJMountDataPerChar.whitelist)) then
				for v in pairs(SJMountDataPerChar.whitelist) do
					DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_WHITELIST), GetSpellLink(v)))
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_EMPTY, strlower(L.TOKEN_WHITELIST)))
			end
		end,
		[strlower(L.TOKEN_LINKEDLIST)] = function(showAll)
			if (showAll == "all") then
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_LINKEDLIST) .. " (all)"))
			else
				DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_START, strlower(L.TOKEN_LINKEDLIST)))
			end
			local hasEntries = false
			if (next(T.linkedList[MOUNTLEVEL1].mountList)) then
				hasEntries = true
				for k, v in pairs(T.linkedList[MOUNTLEVEL1].mountList) do
					if ((showAll == "all") or (v ~= false)) then
						DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_LINKEDLIST), GetSpellLink(k)))
					end
				end
			end
			if (next(T.linkedList[MOUNTLEVEL2].mountList)) then
				hasEntries = true
				for k, v in pairs(T.linkedList[MOUNTLEVEL2].mountList) do
					if ((showAll == "all") or (v ~= false)) then
						DEFAULT_CHAT_FRAME:AddMessage(format(L.CT_PRINT_LIST_LOOP, strlower(L.TOKEN_LINKEDLIST), GetSpellLink(k)))
					end
				end
			end
			if (next(T.linkedList[MOUNTLEVEL3].mountList)) then
				hasEntries = true
				for k, v in pairs(T.linkedList[MOUNTLEVEL3].mountList) do
					if ((showAll == "all") or (v ~= false)) then
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
			[strlower(L.TOKEN_LINKEDLIST)] 	= format(L.CT_PRINT_HELP_LINKEDLIST, strlower(L.TOKEN_LINKEDLIST), strlower(L.TOKEN_LINKEDLIST)),
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

---
-- @param arg1 chat string to be tokenized
-- @param arg2 command table to matched with a chat string token
--
function T.SlashCommand(arg1, arg2)
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

	arg2 = arg2 or T.commandTable

	local command, parameters = string.split(" ", arg1, 2)
	local entry = arg2[strlower(command)]
	local which = type(entry)

	if (which == "function") then
		entry(parameters)
	elseif (which == "table") then
		T.SlashCommand(parameters or "", entry)
	elseif (which == "string") then
		DEFAULT_CHAT_FRAME:AddMessage(entry)
	elseif (arg1 ~= strlower(L.TOKEN_HELP)) then
		T.SlashCommand(strlower(L.TOKEN_HELP), arg2)
	end
end
