
-- -----------------------------------------------------------------------------
-- Global Variables
-- -----------------------------------------------------------------------------
SJMOUNT_NAME = GetAddOnMetadata("SJMount", "Title")
SJMOUNT_VERSION = GetAddOnMetadata("SJMount", "Version")
SJMOUNT_FILENUM = GetAddOnMetadata("SJMount", "X-FileNumber")

SJMount_eventHandlers = {

	-- ADDON_LOADED:
	-- Fires when an addon and its saved variables are loaded.
	["ADDON_LOADED"] = function(_frame, arg1)
		if (arg1 == SJMOUNT_NAME) then
			-- On AddOn loaded event code
		end
	end,

	-- PLAYER_ENTERING_WORLD:
	-- Fired when the player enters the world, reloads the UI, enters/leaves an instance or battleground, or respawns at a graveyard.
	-- Also fires any other time the player sees a loading screen.
	["PLAYER_ENTERING_WORLD"] = function()
		DEFAULT_CHAT_FRAME:AddMessage("|cffa9bacb<SJMount>|r File: SJMount_" .. SJMOUNT_FILENUM .. "|cffa9bacb by SweedJesus|r")
	end,

	--- LEARNED_SPELL_IN_TAB:
	-- Fires when a spell is learned inside of a given spell book tab, including when spells are learned upon changing the active talent spec.
	["LEARNED_SPELL_IN_TAB"] = function(_frame, spellID, tabID)
		if (tabID == 1) then
			if (SJMount_HasRidingSkillChanged()) then
				SJMount_UpdateRidingSkill()
			end
		end
	end,

	-- COMPANION_LEARNED:
	-- Fires when the player learns to summon a new mount or non-combat pet.
	["COMPANION_LEARNED"] = function()
		if (SJMount_HasMountListChanged()) then
			SJMount_UpdateMountList()
		end
	end,

	-- UNIT_AURA:
	-- Fires when a unit loses or gains a buff or debuff.
	["UNIT_AURA"] = function(_frame, arg1)
		if (arg1 == "player") then
		end
	end,

	-- ZONE_CHANGED:
	-- Fires when the player moves between subzones or other named areas.
	["ZONE_CHANGED"] = function()
	end,

	-- ZONE_CHANGED_NEW_AREA:
	-- Fires when the player moves between major zones or enters/exits an instance.
	["ZONE_CHANGED_NEW_AREA"] = function()
	end,
	-- UPDATE_WORLD_STATES:
	-- Fires when information for world state UI elements changes or becomes available.
	["UPDATE_WORLD_STATES"] = function()
	end
}

-- -----------------------------------------------------------------------------
-- OnLoad Script Functions
-- -----------------------------------------------------------------------------

---
function SJMount_OnLoad(frame)
	-- Register Events
	for event in pairs(SJMount_eventHandlers) do
		frame:RegisterEvent(event)
	end

	-- Slash Commands
	SlashCmdList["SJMOUNT"] = function()
		SJMount_SlashCommand()
	end
	SLASH_SJMOUNT1 = "/sjmount"
	SLASH_SJMOUNT2 = "/sjm"
	SLASH_SJMOUNT3 = "/mount"
end

-- -----------------------------------------------------------------------------
-- OnEvent Script Functions
-- -----------------------------------------------------------------------------

---
function SJMount_OnEvent(frame, event, ...)
	local handler = SJMount_eventHandlers[event]
	if (handler) then
		handler(frame, ...)
	end
end

