local T, C, L = unpack(select(2, ...))

local PATTERN_SPELLLINK  = "(|c%x+|H%a*:%d*|h%[[%a%s]*%]|h|r)"
local PATTERN_SPELLID = "|c%x+|H%a*:(%d*)|h%[[%a%s]*%]|h|r"

config = {
	-- Toggles
	debug = false,
	-- General blacklist/whitelist
	blacklist = {},
	whitelist = {},
	-- Zone whitelists
	zones = {
		["Temple of Ahn'Qiraj"] = {
			ground = {
				21176,
				21218,
				21321,
				21323,
				21324
			}
		}
	}
}

local MOUNTLEVELS = {"ground", "flying", "water"}

local lists = {
	numMounts = 0,
	ground = false,
	flying = false,
	water = false,
	use = {
		ground = {},
		flying = {},
		water = {}
	}
}

local function IsFlyableArea() end

local function Init()
	lists.numMounts = GetNumCompanions(MOUNT)
	local name, spellID, level, _

	-- All mounts
	for index = 1, lists.numMounts do
		_, name, spellID = GetCompanionInfo(index)
		level = strlower(T.staticMountList[spellID])
		if (not lists[level]) then lists[level] = {} end
		tinsert(lists[level], spellID, index)
	end
end

local function UseListUpdate()
	for spellID in pairs(lists.use) do
		lists.use[spellID] = nil
	end

	for level in pairs(MOUNTLEVELS) do
		local zoneList = config.zones[GetZoneText()]
		if (lists[level]) then
			if (zoneList[level]) then
				local haszonemount = false
				for spellID in pairs(zoneList[level]) do
					if (lists[level][spellID]) then
						lists.use[level][spellID] = lists[level][spellID]
						haszonemount = true
					end
				end
				if (not haszonemount) then
					for spellID, index in pairs(lists[level]) do
						lists.use[level][spellID] = index
					end
				end
				if (config.debug) then
					DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420UseListUpdatet|r] haszonemount = %s", tostring(haszonemount)))
				end
			end
			if (config.debug) then
				DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420UseListUpdatet|r] zoneList[%s] = %s", tostring(level), tostring(zoneList[level])))
			end
		else
		end
		if (config.debug) then
			DEFAULT_CHAT_FRAME:AddMessage(format("[|cffca9420UseListUpdatet|r] lists[%s] = %s", tostring(level), tostring(lists[level])))
		end
	end
end

local function GetNext()
	if (zone ~= GetZoneText) then
	end
end
