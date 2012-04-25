
--- OnLoad
function SJmount_OnLoad(frame)
	-- Register Events
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	frame:RegisterEvent("COMPANION_LEARNED")
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("UPDATE_WORLD_STATES")
	-- Slash Commands
	SlashCmdList["SJmount"] = SJmount_SCommand
	SLASH_SJmount1 = "/sjmount"
	SLASH_SJmount2 = "/sjm"
	SLASH_SJmount3 = "/mount"
end

--- OnEvent
function SJmount_OnEvent(frame, event, ...)
	if (event == "ADDON_LOADED") then
		if (arg1 == "SJmount") then
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
	end

	if (event == "LEARNED_SPELL_IN_TAB") or (event == "COMPANION_LEARNED") then
	end
end

