
SJMOUNT_NAME = GetAddOnMetadata("SJMount", "Title")
SJMOUNT_VERSION = GetAddOnMetadata("SJMount", "Version")
SJMOUNT_FILENUM = GetAddOnMetadata("SJMount", "X-FileNumber")

SJMount_EventHandlers = {

	--- ADDON_LOADED Event Handler:
	-- Fires when an addon and its saved variables are loaded.
	["ADDON_LOADED"] = function(frame, arg1)
		if arg1 == SJMOUNT_NAME then
			-- On AddOn loaded event code
		end
	end,

	--- PLAYER_ENTERING_WORLD Event Handler:
	-- Fired when the player enters the world, reloads the UI, enters/leaves an instance or battleground, or respawns at a graveyard.
	-- Also fires any other time the player sees a loading screen.
	["PLAYER_ENTERING_WORLD"] = function()
		DEFAULT_CHAT_FRAME:AddMessage("|cffa9bacb<SJMount>|r File: SJMount_" .. SJMOUNT_FILENUM .. "|cffa9bacb by SweedJesus|r")
	end,

	--- LEARNED_SPELL_IN_TAB Event Handler:
	["LEARNED_SPELL_IN_TAB"] = function()
		SJMount_UpdateList()
	end,

	--- COMPANION_LEARNED Event Handler:
	["COMPANION_LEARNED"] = function() end,

	--- UNIT_AURA Event Handler:
	["UNIT_AURA"] = function() end,

	["ZONE_CHANGED"] = function()
		SJMount_IsFlyableArea()
	end,

	--- ZONE_CHANGED_NEW_AREA Event Handler:
	-- Fires when the player moves between major zones or enters/exits an instance.
	["ZONE_CHANGED_NEW_AREA"] = function()
		SJMount_IsFlyableArea()
	end,
	--- UPDATE_WORLD_STATES Event Handler:
	["UPDATE_WORLD_STATES"] = function() end
}

--- OnLoad
function SJMount_OnLoad(frame)
	-- Register Events
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	frame:RegisterEvent("COMPANION_LEARNED")
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("UPDATE_WORLD_STATES")
	-- Slash Commands
	SlashCmdList["SJMount"] = SJMount_SCommand
	SLASH_SJMount1 = "/sjmount"
	SLASH_SJMount2 = "/sjm"
	SLASH_SJMount3 = "/mount"
end

--- OnEvent
function SJMount_OnEvent(frame, event, ...)
	local handler = SJMount_EventHandlers[event]
	if handler then
		handler(frame, ...)
	end
end

