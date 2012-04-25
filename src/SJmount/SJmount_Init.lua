
SJMOUNT_NAME = GetAddOnMetadata("SJmount", "Title")
SJMOUNT_VERSION = GetAddOnMetadata("SJmount", "Version")
SJMOUNT_FILENUM = GetAddOnMetadata("SJmount", "X-FileNumber")

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
			-- On addon load code
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ChatFrame1:AddMessage("")
	end

	-- GetZonePVPInfo() returns:
		-- pvpType ("arena"/"combat"/"contested"/"friendly"/"hostile"/"nil"/"sanctuary")
		-- isSubZonePVP (1 if the current area allows free-for-all PVP; otherwise nil)
		-- factionName (Name of the faction that controls the zone [only applies if pvpType is friendly or hostile])
	-- GetOutdoorPVPWaitTime() returns:
		-- waitTime (The number of seconds until the next world PvP battle on the currently selected map starts)
	-- GetWorldPVPAreaInfo(pvpMapID) arguments:
		-- index (1 = Wintergrasp, 2 = Tol Barad)
	-- returns:
		-- pvpInfo (The PvP queue ID for the specified World PvP area)
		-- localizedName (The localized name for the specified World PvP area)
		-- isActive (Whether there is currently a battle in the specified World PvP area)
		-- canQueue (Whether queueing for the specified World PvP area is currently available (15 minutes before the battle starts for WG/TB))
		-- waitTime (The number of seconds until the next battle in the specified World PvP area starts (number))
		-- canEnter (Whether the player has the required level to be eligible for the specified World PvP area [unconfirmed] (boolean) )
	-- GetWorldPVPQueueStatus(index) arguments:
		-- index (Index of the queue to get data for (between 1 and MAX_WORLD_PVP_QUEUES))
	-- returns:
		-- status (Returns the status of the players queue (string))
			-- confirm - The player can enter the pvp zone
			-- none - No world pvp queue at this index
			-- queued - The player is queued for this pvp zone
		-- mapName (mapName - Map name they are queued for (e.g Wintergrasp) (string) )
		-- queueID (queueID - Queue ID, used for BattlefieldMgrExitRequest() and BattlefieldMgrEntryInviteResponse() (number) )

	if (event == "LEARNED_SPELL_IN_TAB") or (event == "COMPANION_LEARNED") then
		SJmount_UpdateList()
	end
end

