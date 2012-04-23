
Mounts = {}
if Mounts["NUM_MOUNTS"] then
	if Mounts["NUM_MOUNTS"] ~= GetNumCompanions(MOUNT) then
		Mounts["isListChanged"] = true
		Mounts["NUM_MOUNTS"] = GetNumCompanions(MOUNT)
	else
		Mounts["isListChanged"] = false
	end
else
	Mounts["NUM_MOUNTS"] = GetNumCompanions(MOUNT)
end

Mounts["MountList"] = {}

function Mounts_GetList()
	for i = 1, Mounts["NUM_MOUNTS"] do
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
	end
end