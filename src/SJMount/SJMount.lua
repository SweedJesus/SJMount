
SJMOUNT_NUM_MOUNTS = GetNumCompanions(MOUNT)	-- Number of mounts
SJMOUNT_LEVELS = {								-- Mount level string constants
	[1] = "EPIC_GROUND",
	[2] = "REGULAR_GROUND",
	[3] = "EPIC_FLYING",
	[4] = "REGULAR_FLYING",
	[5] = "WATER"
}

SJMount_config = {}								-- Config options table
SJMount_mountList = {							-- Per character mount list
	[SJMOUNT_LEVELS[1]] = {},
	[SJMOUNT_LEVELS[2]] = {},
	[SJMOUNT_LEVELS[3]] = {},
	[SJMOUNT_LEVELS[4]] = {},
	[SJMOUNT_LEVELS[5]] = {}
}

function SJMount_UpdateMacro()

end

function SJMount_UpdateMountList()
	for i = 1, NUM_MOUNTS do
		local
		creatureID,		-- Unique ID of the companion
		creatureName,	-- Localized name of the companion
		spellID,		-- The "spell" for summoning the companion
		icon,			-- Path to an icon texture for the companion
		active,			-- 1 if the companion queried is summoned; otherwise nil
		mountFlag		-- A bit-field that indicates mount capabilities. Only returned for mounts
			-- 0x01 : Ground mount
			-- 0x02 : Flying mount
			-- 0x04 : Usable at the water's surface
			-- 0x08 : Usable underwater
			-- 0x10 : Can jump
		= GetCompanionInfo(MOUNT, i)
		if SJMount_mountList[SJMount_StaticMountList[spellID]][spellID] == nil then
			-- If the index for the currently known mount does not exist
		else
			-- If the index exists
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