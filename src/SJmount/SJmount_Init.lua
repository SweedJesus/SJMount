
SJmount = Frame

function SJmount_OnLoad(frame)
	-- Register Events
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	frame:RegisterEvent("COMPANION_LEARNED")
	frame:RegisterEvent("UNIT_AURA")
end

function SJmount_OnEvent(frame, event, ...)
	if event == "ADDON_LOADED"then
	elseif event == "PLAYER_ENTERING_WORLD" then
	end
end

