local addonName, addonTable = ...
addonTable[1] = {} -- T, functions, constants, variables
addonTable[2] = {} -- C, config
addonTable[3] = {} -- L, localization

SJM_E = addonTable

local T, C, L = unpack(select(2, ...))

T.addonName = addonName
T.version = GetAddOnMetadata("SJMount", "Version")
T.client = GetLocale()

local eventHandlers = {
	-- ADDON_LOADED:
	-- Fires when an addon and its saved variables are loaded.
	["ADDON_LOADED"] = function(_frame, arg1)
	--		if (arg1 == SJM_NAME) then
	--		end
	end,

	-- PLAYER_ENTERING_WORLD:
	-- Fired when the player enters the world, reloads the UI, enters/leaves an instance or battleground, or respawns at a graveyard.
	-- Also fires any other time the player sees a loading screen.
	["PLAYER_ENTERING_WORLD"] = function()
		T.Init()
	end,
	-- LEARNED_SPELL_IN_TAB:
	-- Fires when a spell is learned inside of a given spell book tab, including when spells are learned upon changing the active talent spec.
	["LEARNED_SPELL_IN_TAB"] = function(_frame, spellID, tabID)
		if (tabID == 1) then
			T.RidingSkillsUpdate()
		end
	end,

	-- COMPANION_LEARNED:
	-- Fires when the player learns to summon a new mount or non-combat pet.
	["COMPANION_LEARNED"] = function()
		T.LinkedListUpdateCheck()
	end,

	-- UNIT_AURA:
	-- Fires when a unit loses or gains a buff or debuff.
	["UNIT_AURA"] = function(_frame, arg1)
	--		if (arg1 == "player") then
	--		end
	end,

	-- ZONE_CHANGED:
	-- Fires when the player moves between subzones or other named areas.
	["ZONE_CHANGED"] = function()
		T.CheckStates()
	end,

	-- ZONE_CHANGED_NEW_AREA:
	-- Fires when the player moves between major zones or enters/exits an instance.
	["ZONE_CHANGED_NEW_AREA"] = function()
		T.CheckStates()
	end,
	-- UPDATE_WORLD_STATES:
	-- Fires when information for world state UI elements changes or becomes available.
	--	["UPDATE_WORLD_STATES"] = function()
	--		DEFAULT_CHAT_FRAME:AddMessage("C")
	--		SJM_CheckStates()
	--	end
}

-- -----------------------------------------------------------------------------
-- OnLoad Script Functions
-- -----------------------------------------------------------------------------

function SJM_OnLoad(frame)
	-- Register Events
	for event in pairs(eventHandlers) do
		frame:RegisterEvent(event)
	end

	-- Slash Commands
	SLASH_SJM1 = "/sjmount"
	SLASH_SJM2 = "/sjm"
	SlashCmdList["SJM"] = function(msg)
		T.SlashCommand(msg)
	end
end

-- -----------------------------------------------------------------------------
-- OnEvent Script Functions
-- -----------------------------------------------------------------------------

function SJM_OnEvent(frame, event, ...)
	local handler = eventHandlers[event]
	if (handler) then
		handler(frame, ...)
	end
end
