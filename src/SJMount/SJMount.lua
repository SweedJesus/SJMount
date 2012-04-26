

function SJMount_Init()
	SJMOUNT_NUM_MOUNTS = GetNumCompanions(MOUNT)	-- Number of mounts
	SJMOUNT_LEVEL1 = "EPIC_GROUND"
	SJMOUNT_LEVEL2 = "REGULAR_GROUND"
	SJMOUNT_LEVEL3 = "EPIC_FLYING"
	SJMOUNT_LEVEL4 = "REGULAR_FLYING"
	SJMOUNT_LEVEL5 = "WATER"

	SJMount_MountList = SJMount_MountList or nil
	SJMount_StaticMountList = SJMount_StaticMountList or nil
end

function SJMount_UpdateList()
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
		SJMount_MountList[spellID] = true



		--[[
		if (mountFlag % 0x02) == 0 then			-- Flying mount
			mountFlag = mountFlag - 0x02
			if (mountFlag % 0x10) == 0 then			-- Can jump
				mountFlag = mountFlag - 0x10
				if (mountFlag % 0x08) == 0 then			-- Usable underwater
				else									-- Unusable underwater
					if (mountFlag % 0x04) == 0 then			-- Usable at the water's surface
					else									-- Unusable at the water's surface
					end
				end
			else									-- Can't jump
				if (mountFlag % 0x08) == 0 then			-- Usable underwater
				else									-- Unusable underwater
					if (mountFlag % 0x04) == 0 then			-- Usable at the water's surface
					else									-- Unusable at the water's surface
					end
				end
			end
		else									-- Ground mount
			if (mountFlag % 0x10) == 0 then			-- Can jump
				mountFlag = mountFlag - 0x10
				if (mountFlag % 0x08) == 0 then			-- Usable underwater
				else									-- Unusable underwater
					if (mountFlag % 0x04) == 0 then			-- Usable at the water's surface
					else									-- Unusable at the water's surface
					end
				end
			else									-- Can't jump
				if (mountFlag % 0x08) == 0 then			-- Usable underwater
				else									-- Unusable underwater
					if (mountFlag % 0x04) == 0 then			-- Usable at the water's surface
					else									-- Unusable at the water's surface
					end
				end
			end
		end
		--]]
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