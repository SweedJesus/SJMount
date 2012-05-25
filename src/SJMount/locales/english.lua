local T, C, L = unpack(select(2, ...))

-- -----------------------------------------------------------------------------
-- Localization for enUS and enGB
-- -----------------------------------------------------------------------------

-- Yellow 1 "ca9420"
-- Yellow 2 "e7bf6a"

-- Strings
L.STRING_DEBUGGINGMESSAGES 		= "debugging messages"
L.STRING_USEFLYERWHENUNFLYABLE 	= "use flying mounts when unflyable"
L.STRING_OFF 					= "|cffff0000off|r"
L.STRING_ON 					= "|cff00ff00on|r"
-- Zone names
L.WINTERGRASP					= "Wintergrasp"
L.TOL_BARAD						= "Tol Barad"
L.DALARAN						= "Dalaran"
L.CIRCLE_OF_WILLS					= "Circle of Wills"
-- Tokens
L.TOKEN_ADD 					= "Add"
L.TOKEN_BLACKLIST 				= "Blacklist"
L.TOKEN_CONFIG 					= "Config"
L.TOKEN_HELP 					= "Help"
L.TOKEN_LINKEDLIST 				= "Linkedlist"
L.TOKEN_PRINT 					= "Print"
L.TOKEN_REMOVE 					= "Remove"
L.TOKEN_STATUS 					= "Status"
L.TOKEN_UPDATE 					= "Update"
L.TOKEN_WHITELIST 				= "Whitelist"
-- Macro strings
L.MACRO_BODY 					= "/run SJMountUse()"
L.MACRO_NAME 					= "SJMount Macro"
L.MACRO_ICON 					= "SPELL_NATURE_SWIFTNESS"
L.MACRO_TOOLTIPTEXT 			= "Left click to call a random mount, or to dismount while mounted. Right click to override safefly."
-- Update request string
L.UPDATE_REQUEST 				= "<|cffca9420SJMount|r> please enter |cffe7bf6a/sjm update|r to update!"
-- Error strings
L.ERROR_LINKEDLISTEMPTY 		= "<|cffca9420SJMount|r> |cffff0000ERROR|r linkedlist is empty. Check blacklists or whitelists."
L.ERROR_INVALIDMOUNTLEVEL 		= "<|cffca9420SJMount|r> |cffff0000ERROR|r not valid mount level (GROUND, FLYING, WATER)"
L.ERROR_NORIDINGSKILLKNOWN 		= "<|cffca9420SJMount|r> |cffff0000ERROR|r no riding skill known."
-- Command table
-- Update strings
L.CT_UPDATE						= "<|cffca9420SJMount|r> updated"
-- Config strings
L.CT_CONFIG_STATUS1 			= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> [1] use blacklist [%s]"
L.CT_CONFIG_STATUS2 			= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> [2] use whitelist [%s]"
L.CT_CONFIG_STATUS3 			= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> [3] use flying mounts when unflyable [%s]"
L.CT_CONFIG_TOGGLE_ENABLED 		= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> %s enabled"
L.CT_CONFIG_TOGGLE_ENABLEDLIST 	= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> %s enabled (%s disabled)"
L.CT_CONFIG_TOGGLE_DISABLED 	= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> %s disabled"
L.CT_CONFIG_HELP_STATUS 		= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> status: prints the status of all configuration options"
L.CT_CONFIG_HELP_1 				= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> 1 (useBlacklist) : toggles the exclusion of blacklisted mounts from random mount selection"
L.CT_CONFIG_HELP_2 				= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> 2 (useWhitelist) : toggles the exclusive use of whitelisted mounts in random mount selection"
L.CT_CONFIG_HELP_3 				= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> 3 (useFlyerWhenUnflyable) : toggles the use of flying mounts when only ground riding is possible"
L.CT_CONFIG_HELP 				= "<|cffca9420SJMount|r> <|cffe7bf6aConfig|r> commands: status, [1-3], help <command>"
-- Add strings
L.CT_ADD_LIST_SUCCESS			= "<|cffca9420SJMount|r> <|cffe7bf6aAdd|r> %s added to %s"
L.CT_ADD_LIST_FAILURE			= "<|cffca9420SJMount|r> <|cffe7bf6aAdd|r> failed to add %s to %s (not a mount spell!)"
L.CT_ADD_HELP_LIST				= "<|cffca9420SJMount|r> <|cffe7bf6aAdd|r> %s <spell link>: add a learned mount to the %s by its spell link"
L.CT_ADD_HELP					= "<|cffca9420SJMount|r> <|cffe7bf6aAdd|r> commands: blacklist <spell link>, whitelist <spell link>, help <command>"
-- Remove strings
L.CT_REMOVE_LIST_SUCCESS		= "<|cffca9420SJMount|r> <|cffe7bf6aRemove|r> %s removed from %s"
L.CT_REMOVE_LIST_FAILURE		= "<|cffca9420SJMount|r> <|cffe7bf6aRemove|r> failed to remove %s from %s (not a mount spell!)"
L.CT_REMOVE_HELP_LIST			= "<|cffca9420SJMount|r> <|cffe7bf6aRemove|r> %s <spell link>: remove a learned mount from the %s by its spell link"
L.CT_REMOVE_HELP				= "<|cffca9420SJMount|r> <|cffe7bf6aRemove|r> commands: blacklist <spell link>, whitelist <spell link>, help <command>"
-- Print strings
L.CT_PRINT_LIST_START 			= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> printing %s..."
L.CT_PRINT_LIST_LOOP 			= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> %s %s"
L.CT_PRINT_LIST_EMPTY 			= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> %s empty!"
L.CT_PRINT_HELP_LIST			= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> %s: print all entries in the %s"
L.CT_PRINT_HELP_LINKEDLIST		= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> linkedlist <print all>: print entries in the %s. Only prints entries that are not blacklisted/ that are whitelisted, or prints all if \'print all\' is \'true\'"
L.CT_PRINT_HELP					= "<|cffca9420SJMount|r> <|cffe7bf6aPrint|r> commands: blacklist, whitelist, linkedlist <print all>"
-- Help strings
L.CT_HELP_UPDATE				= "<|cffca9420SJMount|r> update: reloads the list of mounts to use in random mount selection"
L.CT_HELP_CONFIG				= "<|cffca9420SJMount|r> config: commands pertaining to configuring SJMount"
L.CT_HELP_ADD					= "<|cffca9420SJMount|r> add: commands pertaining to adding mounts to the blacklist or whitelist"
L.CT_HELP_REMOVE				= "<|cffca9420SJMount|r> remove: commands pertaining to removing mounts from the blacklist or whitelist"
L.CT_HELP_PRINT					= "<|cffca9420SJMount|r> print: commands pertaining to printing all entries in either the blacklist, whitelist, or linkedlist"
L.CT_HELP						= "<|cffca9420SJMount|r> commands: update, config <subcommand>, add <subcommand>, remove <subcommand>, print <subcommand>, help <command>"
