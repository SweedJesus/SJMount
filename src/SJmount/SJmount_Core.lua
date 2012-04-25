
-- Global sustantiations
SJMOUNT_NUM_MOUNTS = GetNumCompanions(MOUNT)	-- Number of mounts
SJMOUNT_LEVEL1 = "EPIC_GROUND"
SJMOUNT_LEVEL2 = "REGULAR_GROUND"
SJMOUNT_LEVEL3 = "EPIC_FLYING"
SJMOUNT_LEVEL4 = "REGULAR_FLYING"
SJMOUNT_LEVEL5 = "WATER"

SJmount_MountList = SJmount_MountList or nil
SJmount_StaticMountList = SJmount_StaticMountList or nil

function SJmount_OnLoad()
end

function SJmount_Init()
	if SJmount_MountList then
		if #SJmount_MountList == NUM_MOUNTS then
			SJmount_MountList_Update()
		end
	else
		SJmount_MountList_Init()
		SJmount_Init()
	end
end

function SJmount_MountList_Update()
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
		SJmount_MountList[spellID] = true



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

function StaticMountList_Init()
	SJMount_StaticMountList = {}
	--[[
	-- EPIC GROUND MOUNTS (LEVEL 1)
	--]]
	SJMount_StaticMountList[92155] = SJMOUNT_LEVEL1 -- Ultramarine Qiraji Battle Tank
	SJMount_StaticMountList[26656] = SJMOUNT_LEVEL1 -- Black Qiraji Battle Tank
	SJMount_StaticMountList[41252] = SJMOUNT_LEVEL1 -- Raven Lord
	SJMount_StaticMountList[93644] = SJMOUNT_LEVEL1 -- Kor'kron Annihilator
	SJMount_StaticMountList[90621] = SJMOUNT_LEVEL1 -- Golden King
	SJMount_StaticMountList[92232] = SJMOUNT_LEVEL1 -- Spectral Wolf
	SJMount_StaticMountList[92231] = SJMOUNT_LEVEL1 -- Spectral Steed
	SJMount_StaticMountList[84751] = SJMOUNT_LEVEL1 -- Fossilized Raptor
	SJMount_StaticMountList[43688] = SJMOUNT_LEVEL1 -- Amani War Bear
	SJMount_StaticMountList[74918] = SJMOUNT_LEVEL1 -- Wooly White Rhino
	SJMount_StaticMountList[58983] = SJMOUNT_LEVEL1 -- Big Blizzard Bear
	SJMount_StaticMountList[42777] = SJMOUNT_LEVEL1 -- Swift Spectral Tiger
	SJMount_StaticMountList[24242] = SJMOUNT_LEVEL1 -- Swift Razzashi Raptor
	SJMount_StaticMountList[24252] = SJMOUNT_LEVEL1 -- Swift Zulian Tiger
	SJMount_StaticMountList[46628] = SJMOUNT_LEVEL1 -- Swift White Hawkstrider
	SJMount_StaticMountList[48954] = SJMOUNT_LEVEL1 -- Swift Zhevra
	SJMount_StaticMountList[49322] = SJMOUNT_LEVEL1 -- Swift Zhevra
	SJMount_StaticMountList[69826] = SJMOUNT_LEVEL1 -- Great Sunwalker Kodo
	SJMount_StaticMountList[68188] = SJMOUNT_LEVEL1 -- Crusader's Black Warhorse
	SJMount_StaticMountList[68187] = SJMOUNT_LEVEL1 -- Crusader's White Warhorse
	SJMount_StaticMountList[66906] = SJMOUNT_LEVEL1 -- Argent Charger
	SJMount_StaticMountList[67466] = SJMOUNT_LEVEL1 -- Argent Warhorse
	SJMount_StaticMountList[66091] = SJMOUNT_LEVEL1 -- Sunreaver Hawkstrider
	SJMount_StaticMountList[73313] = SJMOUNT_LEVEL1 -- Crimson Deathcharger
	SJMount_StaticMountList[48778] = SJMOUNT_LEVEL1 -- Deathcharger
	SJMount_StaticMountList[16056] = SJMOUNT_LEVEL1 -- Ancient Frostsaber (feat of strength)
	SJMount_StaticMountList[16055] = SJMOUNT_LEVEL1 -- Black Nightsaber (feat of strength)
	SJMount_StaticMountList[87091] = SJMOUNT_LEVEL1 -- Goblin Turbo-Trike
	SJMount_StaticMountList[60114] = SJMOUNT_LEVEL1 -- Armored Brown Bear
	SJMount_StaticMountList[60116] = SJMOUNT_LEVEL1 -- Armored Brown Bear
	SJMount_StaticMountList[88748] = SJMOUNT_LEVEL1 -- Brown Riding Camel
	SJMount_StaticMountList[88750] = SJMOUNT_LEVEL1 -- Grey Riding Camel
	SJMount_StaticMountList[88749] = SJMOUNT_LEVEL1 -- Tan Riding Camel
	SJMount_StaticMountList[51412] = SJMOUNT_LEVEL1 -- Big Battle Bear
	SJMount_StaticMountList[22719] = SJMOUNT_LEVEL1 -- Black Battlestrider
	SJMount_StaticMountList[59572] = SJMOUNT_LEVEL1 -- Black Polar Bear
	SJMount_StaticMountList[17461] = SJMOUNT_LEVEL1 -- Black Ram
	SJMount_StaticMountList[60118] = SJMOUNT_LEVEL1 -- Black War Bear
	SJMount_StaticMountList[60119] = SJMOUNT_LEVEL1 -- Black War Bear
	SJMount_StaticMountList[48027] = SJMOUNT_LEVEL1 -- Black War Elekk
	SJMount_StaticMountList[22718] = SJMOUNT_LEVEL1 -- Black War Kodo
	SJMount_StaticMountList[59785] = SJMOUNT_LEVEL1 -- Black War Mammoth
	SJMount_StaticMountList[59788] = SJMOUNT_LEVEL1 -- Black War Mammoth
	SJMount_StaticMountList[22720] = SJMOUNT_LEVEL1 -- Black War Ram
	SJMount_StaticMountList[22721] = SJMOUNT_LEVEL1 -- Black War Raptor
	SJMount_StaticMountList[22717] = SJMOUNT_LEVEL1 -- Black War Steed
	SJMount_StaticMountList[22723] = SJMOUNT_LEVEL1 -- Black War Tiger
	SJMount_StaticMountList[22724] = SJMOUNT_LEVEL1 -- Black War Wolf
	SJMount_StaticMountList[59573] = SJMOUNT_LEVEL1 -- Brown Polar Bear
	SJMount_StaticMountList[39315] = SJMOUNT_LEVEL1 -- Cobalt Riding Talbuk
	SJMount_StaticMountList[34896] = SJMOUNT_LEVEL1 -- Cobalt War Talbuk
	SJMount_StaticMountList[39316] = SJMOUNT_LEVEL1 -- Dark Riding Talbuk
	SJMount_StaticMountList[34790] = SJMOUNT_LEVEL1 -- Dark War Talbuk
	SJMount_StaticMountList[36702] = SJMOUNT_LEVEL1 -- Fiery Warhorse
	SJMount_StaticMountList[23509] = SJMOUNT_LEVEL1 -- Frostwolf Howler
	SJMount_StaticMountList[59810] = SJMOUNT_LEVEL1 -- Grand Black War Mammoth
	SJMount_StaticMountList[59811] = SJMOUNT_LEVEL1 -- Grand Black War Mammoth
	SJMount_StaticMountList[60136] = SJMOUNT_LEVEL1 -- Grand Caravan Mammoth
	SJMount_StaticMountList[60140] = SJMOUNT_LEVEL1 -- Grand Caravan Mammoth
	SJMount_StaticMountList[59802] = SJMOUNT_LEVEL1 -- Grand Ice Mammoth
	SJMount_StaticMountList[59804] = SJMOUNT_LEVEL1 -- Grand Ice Mammoth
	SJMount_StaticMountList[35713] = SJMOUNT_LEVEL1 -- Great Blue Elekk
	SJMount_StaticMountList[49379] = SJMOUNT_LEVEL1 -- Great Brewfest Kodo
	SJMount_StaticMountList[23249] = SJMOUNT_LEVEL1 -- Great Brown Kodo
	SJMount_StaticMountList[34407] = SJMOUNT_LEVEL1 -- Great Elite Elekk
	SJMount_StaticMountList[23248] = SJMOUNT_LEVEL1 -- Great Gray Kodo
	SJMount_StaticMountList[35712] = SJMOUNT_LEVEL1 -- Great Green Elekk
	SJMount_StaticMountList[35714] = SJMOUNT_LEVEL1 -- Great Purple Elekk
	SJMount_StaticMountList[23247] = SJMOUNT_LEVEL1 -- Great White Kodo
	SJMount_StaticMountList[17465] = SJMOUNT_LEVEL1 -- Green Skeletal Warhorse
	SJMount_StaticMountList[48025] = SJMOUNT_LEVEL1 -- Headless Horseman's Horse (variable)
	SJMount_StaticMountList[75614] = SJMOUNT_LEVEL1 -- Celestial Steed (variable)
	SJMount_StaticMountList[59797] = SJMOUNT_LEVEL1 -- Ice Mammoth
	SJMount_StaticMountList[59799] = SJMOUNT_LEVEL1 -- Ice Mammoth
	SJMount_StaticMountList[55531] = SJMOUNT_LEVEL1 -- Mechano-Hog
	SJMount_StaticMountList[60424] = SJMOUNT_LEVEL1 -- Mekgineer's Chopper
	SJMount_StaticMountList[23246] = SJMOUNT_LEVEL1 -- Purple Skeletal Warhorse
	SJMount_StaticMountList[22722] = SJMOUNT_LEVEL1 -- Red Skeletal Warhorse
	SJMount_StaticMountList[17481] = SJMOUNT_LEVEL1 -- Rivendare's Deathcharger
	SJMount_StaticMountList[39317] = SJMOUNT_LEVEL1 -- Silver Riding Talbuk
	SJMount_StaticMountList[34898] = SJMOUNT_LEVEL1 -- Silver War Talbuk
	SJMount_StaticMountList[23510] = SJMOUNT_LEVEL1 -- Stormpike Battle Charger
	SJMount_StaticMountList[23241] = SJMOUNT_LEVEL1 -- Swift Blue Raptor
	SJMount_StaticMountList[43900] = SJMOUNT_LEVEL1 -- Swift Brewfest Ram
	SJMount_StaticMountList[23238] = SJMOUNT_LEVEL1 -- Swift Brown Ram
	SJMount_StaticMountList[23229] = SJMOUNT_LEVEL1 -- Swift Brown Steed
	SJMount_StaticMountList[23250] = SJMOUNT_LEVEL1 -- Swift Brown Wolf
	SJMount_StaticMountList[23221] = SJMOUNT_LEVEL1 -- Swift Frostsaber
	SJMount_StaticMountList[23239] = SJMOUNT_LEVEL1 -- Swift Gray Ram
	SJMount_StaticMountList[23252] = SJMOUNT_LEVEL1 -- Swift Gray Wolf
	SJMount_StaticMountList[35025] = SJMOUNT_LEVEL1 -- Swift Green Hawkstrider
	SJMount_StaticMountList[23225] = SJMOUNT_LEVEL1 -- Swift Green Mechanostrider
	SJMount_StaticMountList[23219] = SJMOUNT_LEVEL1 -- Swift Mistsaber
	SJMount_StaticMountList[23242] = SJMOUNT_LEVEL1 -- Swift Olive Raptor
	SJMount_StaticMountList[23243] = SJMOUNT_LEVEL1 -- Swift Orange Raptor
	SJMount_StaticMountList[23227] = SJMOUNT_LEVEL1 -- Swift Palamino
	SJMount_StaticMountList[33660] = SJMOUNT_LEVEL1 -- Swift Pink Hawkstrider
	SJMount_StaticMountList[35027] = SJMOUNT_LEVEL1 -- Swift Purple Hawkstrider
	SJMount_StaticMountList[23338] = SJMOUNT_LEVEL1 -- Swift Stormsaber
	SJMount_StaticMountList[23251] = SJMOUNT_LEVEL1 -- Swift Timber Wolf
	SJMount_StaticMountList[47037] = SJMOUNT_LEVEL1 -- Swift War Elekk
	SJMount_StaticMountList[35028] = SJMOUNT_LEVEL1 -- Swift Warstrider
	SJMount_StaticMountList[23223] = SJMOUNT_LEVEL1 -- Swift White Mechanostrider
	SJMount_StaticMountList[23240] = SJMOUNT_LEVEL1 -- Swift White Ram
	SJMount_StaticMountList[23228] = SJMOUNT_LEVEL1 -- Swift White Steed
	SJMount_StaticMountList[23222] = SJMOUNT_LEVEL1 -- Swift Yellow Mechanostrider
	SJMount_StaticMountList[39318] = SJMOUNT_LEVEL1 -- Tan Riding Talbuk
	SJMount_StaticMountList[34899] = SJMOUNT_LEVEL1 -- Tan War Talbuk
	SJMount_StaticMountList[54753] = SJMOUNT_LEVEL1 -- White Polar Bear
	SJMount_StaticMountList[39319] = SJMOUNT_LEVEL1 -- White Riding Talbuk
	SJMount_StaticMountList[34897] = SJMOUNT_LEVEL1 -- White War Talbuk
	SJMount_StaticMountList[17229] = SJMOUNT_LEVEL1 -- Winterspring Frostsaber
	SJMount_StaticMountList[59791] = SJMOUNT_LEVEL1 -- Wooly Mammoth
	SJMount_StaticMountList[59793] = SJMOUNT_LEVEL1 -- Wooly Mammoth
	SJMount_StaticMountList[23214] = SJMOUNT_LEVEL1 -- Summon Charger (Alliance Paladin)
	SJMount_StaticMountList[34767] = SJMOUNT_LEVEL1 -- Summon Charger (Bloodelf Paladin)
	SJMount_StaticMountList[23161] = SJMOUNT_LEVEL1 -- Summon Dreadsteed
	SJMount_StaticMountList[63635] = SJMOUNT_LEVEL1 -- Darkspear Raptor (new Argent troll)
	SJMount_StaticMountList[65644] = SJMOUNT_LEVEL1 -- Swift Purple Raptor (old Argent troll)
	SJMount_StaticMountList[63643] = SJMOUNT_LEVEL1 -- Forsaken Warhorse (new Argent undead)
	SJMount_StaticMountList[65645] = SJMOUNT_LEVEL1 -- White Skeletal Warhorse (old Argent undead)
	SJMount_StaticMountList[63641] = SJMOUNT_LEVEL1 -- Thunder Bluff Kodo (new Argent tauren)
	SJMount_StaticMountList[65641] = SJMOUNT_LEVEL1 -- Great Golden Kodo (old Argent tauren)
	SJMount_StaticMountList[63640] = SJMOUNT_LEVEL1 -- Orgrimmar Wolf (new Argent orc)
	SJMount_StaticMountList[65646] = SJMOUNT_LEVEL1 -- Swift Burgundy Wolf (old Argent orc) (got off thottbot not positive if correct)
	SJMount_StaticMountList[63642] = SJMOUNT_LEVEL1 -- Silvermoon Hawkstrider (new Argent bloodelf)
	SJMount_StaticMountList[65639] = SJMOUNT_LEVEL1 -- Swift Red Hawkstrider (old Argent bloodelf)
	SJMount_StaticMountList[63637] = SJMOUNT_LEVEL1 -- Darnassian Nightsaber (new Argent nightelf)
	SJMount_StaticMountList[65638] = SJMOUNT_LEVEL1 -- Swift Moonsaber (old Argent nightelf)
	SJMount_StaticMountList[63639] = SJMOUNT_LEVEL1 -- Exodar Elekk (new Argent draeni)
	SJMount_StaticMountList[65637] = SJMOUNT_LEVEL1 -- Great Red Elekk (old Argent draeni)
	SJMount_StaticMountList[63638] = SJMOUNT_LEVEL1 -- Gnomeregan Mechanostrider (new Argent gnome)
	SJMount_StaticMountList[65642] = SJMOUNT_LEVEL1 -- Turbostrider  (old Argent gnome) (got off thottbot not positive if correct)
	SJMount_StaticMountList[63636] = SJMOUNT_LEVEL1 -- Ironforge Ram (new Argent dwarf)
	SJMount_StaticMountList[65643] = SJMOUNT_LEVEL1 -- Swift Violet Ram (old Argent dwarf)
	SJMount_StaticMountList[63232] = SJMOUNT_LEVEL1 -- Stormwind Steed (new Argent human)
	SJMount_StaticMountList[65640] = SJMOUNT_LEVEL1 -- Swift Gray Steed (old Argent human)
	--[[
-- REGULAR GROUND MOUNTS (LEVEL 2)
--]]
	SJMount_StaticMountList[66907] = SJMOUNT_LEVEL2 -- Argent Warhorse
	SJMount_StaticMountList[87090] = SJMOUNT_LEVEL2 -- Goblin Trike
	SJMount_StaticMountList[64977] = SJMOUNT_LEVEL2 -- Black Skeletal Horse
	SJMount_StaticMountList[35020] = SJMOUNT_LEVEL2 -- Blue Hawkstrider
	SJMount_StaticMountList[10969] = SJMOUNT_LEVEL2 -- Blue Mechanostrider
	SJMount_StaticMountList[33630] = SJMOUNT_LEVEL2 -- Blue Mechanostrider
	SJMount_StaticMountList[578]   = SJMOUNT_LEVEL2 -- Black Wolf
	SJMount_StaticMountList[64658] = SJMOUNT_LEVEL2 -- Black Wolf
	SJMount_StaticMountList[6896]  = SJMOUNT_LEVEL2 -- Black Ram
	SJMount_StaticMountList[470]   = SJMOUNT_LEVEL2 -- Black Stallion
	SJMount_StaticMountList[35022] = SJMOUNT_LEVEL2 -- Black Hawkstrider
	SJMount_StaticMountList[6897]  = SJMOUNT_LEVEL2 -- Blue Ram
	SJMount_StaticMountList[17463] = SJMOUNT_LEVEL2 -- Blue Skeletal Horse
	SJMount_StaticMountList[50869] = SJMOUNT_LEVEL2 -- Brewfest Kodo
	SJMount_StaticMountList[49378] = SJMOUNT_LEVEL2 -- Brewfest Riding Kodo
	SJMount_StaticMountList[43899] = SJMOUNT_LEVEL2 -- Brewfest Ram
	SJMount_StaticMountList[50870] = SJMOUNT_LEVEL2 -- Brewfest Ram
	SJMount_StaticMountList[34406] = SJMOUNT_LEVEL2 -- Brown Elekk
	SJMount_StaticMountList[458]   = SJMOUNT_LEVEL2 -- Brown Horse
	SJMount_StaticMountList[18990] = SJMOUNT_LEVEL2 -- Brown Kodo
	SJMount_StaticMountList[6899]  = SJMOUNT_LEVEL2 -- Brown Ram
	SJMount_StaticMountList[17464] = SJMOUNT_LEVEL2 -- Brown Skeletal Horse
	SJMount_StaticMountList[6654]  = SJMOUNT_LEVEL2 -- Brown Wolf
	SJMount_StaticMountList[6648]  = SJMOUNT_LEVEL2 -- Chestnut Mare
	SJMount_StaticMountList[6653]  = SJMOUNT_LEVEL2 -- Dire Wolf
	SJMount_StaticMountList[8395]  = SJMOUNT_LEVEL2 -- Emerald Raptor
	SJMount_StaticMountList[16060] = SJMOUNT_LEVEL2 -- Golden Sabercat *Unconfirmed*
	SJMount_StaticMountList[35710] = SJMOUNT_LEVEL2 -- Gray Elekk
	SJMount_StaticMountList[18989] = SJMOUNT_LEVEL2 -- Gray Kodo
	SJMount_StaticMountList[6777]  = SJMOUNT_LEVEL2 -- Gray Ram
	SJMount_StaticMountList[459]   = SJMOUNT_LEVEL2 -- Gray Wolf
	SJMount_StaticMountList[15780] = SJMOUNT_LEVEL2 -- Green Mechanostrider
	SJMount_StaticMountList[17453] = SJMOUNT_LEVEL2 -- Green Mechanostrider
	SJMount_StaticMountList[471]   = SJMOUNT_LEVEL2 -- Palamino
	SJMount_StaticMountList[472]   = SJMOUNT_LEVEL2 -- Pinto
	SJMount_StaticMountList[35711] = SJMOUNT_LEVEL2 -- Purple Elekk
	SJMount_StaticMountList[35018] = SJMOUNT_LEVEL2 -- Purple Hawkstrider
	SJMount_StaticMountList[17455] = SJMOUNT_LEVEL2 -- Purple Mechanostrider
	SJMount_StaticMountList[17456] = SJMOUNT_LEVEL2 -- Red & Blue Mechanostrider
	SJMount_StaticMountList[34795] = SJMOUNT_LEVEL2 -- Red Hawkstrider
	SJMount_StaticMountList[10873] = SJMOUNT_LEVEL2 -- Red Mechanostrider
	SJMount_StaticMountList[17462] = SJMOUNT_LEVEL2 -- Red Skeletal Horse
	SJMount_StaticMountList[30174] = SJMOUNT_LEVEL2 -- Riding Turtle
	SJMount_StaticMountList[42776] = SJMOUNT_LEVEL2 -- Spectral Tiger
	SJMount_StaticMountList[10789] = SJMOUNT_LEVEL2 -- Spotted Frostsaber
	SJMount_StaticMountList[15781] = SJMOUNT_LEVEL2 -- Steel Mechanostrider
	SJMount_StaticMountList[8394]  = SJMOUNT_LEVEL2 -- Striped Frostsaber
	SJMount_StaticMountList[10793] = SJMOUNT_LEVEL2 -- Striped Nightsaber
	SJMount_StaticMountList[580]   = SJMOUNT_LEVEL2 -- Timber Wolf
	SJMount_StaticMountList[10796] = SJMOUNT_LEVEL2 -- Turquoise Raptor
	SJMount_StaticMountList[17454] = SJMOUNT_LEVEL2 -- Unpainted Mechanostrider
	SJMount_StaticMountList[10799] = SJMOUNT_LEVEL2 -- Violet Raptor
	SJMount_StaticMountList[6898]  = SJMOUNT_LEVEL2 -- White Ram
	SJMount_StaticMountList[468]   = SJMOUNT_LEVEL2 -- White Stallion
	SJMount_StaticMountList[581]   = SJMOUNT_LEVEL2 -- Winter Wolf
	SJMount_StaticMountList[34769] = SJMOUNT_LEVEL2 -- Summon Warhorse (Bloodelf Paladin)
	SJMount_StaticMountList[13819] = SJMOUNT_LEVEL2 -- Summon Warhorse (Alliance Paladin)
	SJMount_StaticMountList[5784]  = SJMOUNT_LEVEL2 -- Summon Felsteed
	--[[
-- EPIC FLYING MOUNTS (LEVEL 3)
--]]
	SJMount_StaticMountList[72286] = SJMOUNT_LEVEL3 -- Invincible (variable)
	SJMount_StaticMountList[63796] = SJMOUNT_LEVEL3 -- Mimiron's Head (310)
	SJMount_StaticMountList[71810] = SJMOUNT_LEVEL3 -- Wrathful Gladiator's Frostwyrm (310)
	SJMount_StaticMountList[67336] = SJMOUNT_LEVEL3 -- Relentless Gladiator's Frostwyrm (310)
	SJMount_StaticMountList[65439] = SJMOUNT_LEVEL3 -- Furious Gladiator's Frostwyrm (310)
	SJMount_StaticMountList[64927] = SJMOUNT_LEVEL3 -- Deadly Gladiator's Frostwyrm (310)
	SJMount_StaticMountList[72808] = SJMOUNT_LEVEL3 -- Bloodbathed Frostbrood Vanquisher (310)
	SJMount_StaticMountList[43810] = SJMOUNT_LEVEL3 -- Frost Wyrm (280) *Unconfirmed*
	SJMount_StaticMountList[51960] = SJMOUNT_LEVEL3 -- Frost Wyrm (280) *Unconfirmed*
	SJMount_StaticMountList[63956] = SJMOUNT_LEVEL3 -- Ironbound Proto Drake (310)
	SJMount_StaticMountList[63963] = SJMOUNT_LEVEL3 -- Rusted Proto Drake (310)
	SJMount_StaticMountList[40192] = SJMOUNT_LEVEL3 -- Ashes of Al'ar (Phoenix) (310)
	SJMount_StaticMountList[58615] = SJMOUNT_LEVEL3 -- Brutal Nether Drake (310)
	SJMount_StaticMountList[44317] = SJMOUNT_LEVEL3 -- Merciless Nether Drake (310)
	SJMount_StaticMountList[44744] = SJMOUNT_LEVEL3 -- Merciless Nether Drake (310)
	SJMount_StaticMountList[37015] = SJMOUNT_LEVEL3 -- Swift Nether Drake (310)
	SJMount_StaticMountList[49193] = SJMOUNT_LEVEL3 -- Vengeful Nether Drake (310)
	SJMount_StaticMountList[60021] = SJMOUNT_LEVEL3 -- Plagued Proto Drake (310)
	SJMount_StaticMountList[59976] = SJMOUNT_LEVEL3 -- Black Proto Drake (310)
	SJMount_StaticMountList[59996] = SJMOUNT_LEVEL3 -- Blue Proto Drake (280)
	SJMount_StaticMountList[61294] = SJMOUNT_LEVEL3 -- Green Proto Drake (280)
	SJMount_StaticMountList[59961] = SJMOUNT_LEVEL3 -- Red Proto Drake (280)
	SJMount_StaticMountList[60002] = SJMOUNT_LEVEL3 -- Time-Lost Proto Drake (280)
	SJMount_StaticMountList[60024] = SJMOUNT_LEVEL3 -- Violet Proto Drake (280)
	SJMount_StaticMountList[88335] = SJMOUNT_LEVEL3 -- Drake of the East Wind (280)
	SJMount_StaticMountList[88742] = SJMOUNT_LEVEL3 -- Drake of the North Wind (280)
	SJMount_StaticMountList[88744] = SJMOUNT_LEVEL3 -- Drake of the South Wind (280)
	SJMount_StaticMountList[88741] = SJMOUNT_LEVEL3 -- Drake of the West Wind (280)
	SJMount_StaticMountList[88990] = SJMOUNT_LEVEL3 -- Dark Phoenix (280)
	SJMount_StaticMountList[88718] = SJMOUNT_LEVEL3 -- Phosphorescent Stone Drake (280)
	SJMount_StaticMountList[93326] = SJMOUNT_LEVEL3 -- Sandstone Drake (280)
	SJMount_StaticMountList[88746] = SJMOUNT_LEVEL3 -- Vitreous Stone Drake (280)
	SJMount_StaticMountList[88331] = SJMOUNT_LEVEL3 -- Volcanic Stone Drake (280)
	SJMount_StaticMountList[62048] = SJMOUNT_LEVEL3 -- Black Dragonhawk Mount (280)
	SJMount_StaticMountList[61996] = SJMOUNT_LEVEL3 -- Blue Dragonhawk Mount (280)
	SJMount_StaticMountList[61997] = SJMOUNT_LEVEL3 -- Red Dragonhawk Mount (280)
	SJMount_StaticMountList[71342] = SJMOUNT_LEVEL3 -- Big Love Rocket (variable)
	SJMount_StaticMountList[75596] = SJMOUNT_LEVEL3 -- Frosty Flying Carpet (280)
	SJMount_StaticMountList[66087] = SJMOUNT_LEVEL3 -- Silver Covenant Hippogryph (280)
	SJMount_StaticMountList[66088] = SJMOUNT_LEVEL3 -- Sunreaver Dragonhawk (280)
	SJMount_StaticMountList[60025] = SJMOUNT_LEVEL3 -- Albino Drake (280)
	SJMount_StaticMountList[59567] = SJMOUNT_LEVEL3 -- Azure Drake (280)
	SJMount_StaticMountList[59650] = SJMOUNT_LEVEL3 -- Black Drake (280)
	SJMount_StaticMountList[59568] = SJMOUNT_LEVEL3 -- Blue Drake (280)
	SJMount_StaticMountList[59569] = SJMOUNT_LEVEL3 -- Bronze Drake (280)
	SJMount_StaticMountList[59570] = SJMOUNT_LEVEL3 -- Red Drake (280)
	SJMount_StaticMountList[59571] = SJMOUNT_LEVEL3 -- Twilight Drake (280)
	SJMount_StaticMountList[63844] = SJMOUNT_LEVEL3 -- Argent Hippogryph (280)
	SJMount_StaticMountList[41514] = SJMOUNT_LEVEL3 -- Azure Netherwing Drake (280)
	SJMount_StaticMountList[41515] = SJMOUNT_LEVEL3 -- Cobalt Netherwing Drake (280)
	SJMount_StaticMountList[41513] = SJMOUNT_LEVEL3 -- Onyx Netherwing Drake (280)
	SJMount_StaticMountList[41516] = SJMOUNT_LEVEL3 -- Purple Netherwing Drake (280)
	SJMount_StaticMountList[41517] = SJMOUNT_LEVEL3 -- Veridian Netherwing Drake (280)
	SJMount_StaticMountList[41518] = SJMOUNT_LEVEL3 -- Violet Netherwing Drake (280)
	SJMount_StaticMountList[39803] = SJMOUNT_LEVEL3 -- Blue Riding Nether Ray (280)
	SJMount_StaticMountList[39798] = SJMOUNT_LEVEL3 -- Green Riding Nether Ray (280)
	SJMount_StaticMountList[39801] = SJMOUNT_LEVEL3 -- Purple Riding Nether Ray (280)
	SJMount_StaticMountList[39800] = SJMOUNT_LEVEL3 -- Red Riding Nether Ray (280)
	SJMount_StaticMountList[39802] = SJMOUNT_LEVEL3 -- Silver Riding Nether Ray (280)
	SJMount_StaticMountList[43927] = SJMOUNT_LEVEL3 -- Cenarian War Hippogryph (280)
	SJMount_StaticMountList[63844] = SJMOUNT_LEVEL3 -- Argent Hippogryph (280)
	SJMount_StaticMountList[61230] = SJMOUNT_LEVEL3 -- Armored Blue Wind Rider (280)
	SJMount_StaticMountList[61229] = SJMOUNT_LEVEL3 -- Armored Snowy Gryphon (280)
	SJMount_StaticMountList[61309] = SJMOUNT_LEVEL3 -- Magnificient Flying Carpet (280)
	SJMount_StaticMountList[32242] = SJMOUNT_LEVEL3 -- Swift Blue Gryphon (280)
	SJMount_StaticMountList[32290] = SJMOUNT_LEVEL3 -- Swift Green Gryphon (280)
	SJMount_StaticMountList[32295] = SJMOUNT_LEVEL3 -- Swift Green Wind Rider (280)
	SJMount_StaticMountList[61442] = SJMOUNT_LEVEL3 -- Swift Mooncloth Carpet (280)
	SJMount_StaticMountList[32292] = SJMOUNT_LEVEL3 -- Swift Purple Griffon (280)
	SJMount_StaticMountList[32297] = SJMOUNT_LEVEL3 -- Swift Purple Wind Rider (280)
	SJMount_StaticMountList[32289] = SJMOUNT_LEVEL3 -- Swift Red Gryphon (280)
	SJMount_StaticMountList[32246] = SJMOUNT_LEVEL3 -- Swift Red Wind Rider (280)
	SJMount_StaticMountList[61444] = SJMOUNT_LEVEL3 -- Swift Shadoweave Carpet (280)
	SJMount_StaticMountList[61446] = SJMOUNT_LEVEL3 -- Swift Spellfire Carpet (280)
	SJMount_StaticMountList[32296] = SJMOUNT_LEVEL3 -- Swift Yellow Wind Rider (280)
	SJMount_StaticMountList[44151] = SJMOUNT_LEVEL3 -- Turbo-Charged Flying Machine (280)
	SJMount_StaticMountList[46199] = SJMOUNT_LEVEL3 -- X-51 Nether-Rocket Extreme (280)
	SJMount_StaticMountList[54729] = SJMOUNT_LEVEL3 -- Winged Steed of the Ebon Blade (variable)
	SJMount_StaticMountList[48025] = SJMOUNT_LEVEL3 -- Headless Horseman's Horse (variable)
	SJMount_StaticMountList[75614] = SJMOUNT_LEVEL3 -- Celestial Steed (variable)
	SJMount_StaticMountList[75973] = SJMOUNT_LEVEL3 -- X-53 Touring Rocket (variable)
	SJMount_StaticMountList[40120] = SJMOUNT_LEVEL3 -- Druid Swift Flight Form
	--[[
	-- REGULAR FLYING MOUNTS (LEVEL 4)
	--]]
	SJMount_StaticMountList[32243] = SJMOUNT_LEVEL4 -- Tawny Wind Rider
	SJMount_StaticMountList[32244] = SJMOUNT_LEVEL4 -- Blue Wind Rider
	SJMount_StaticMountList[32239] = SJMOUNT_LEVEL4 -- Ebon Gryphon
	SJMount_StaticMountList[61451] = SJMOUNT_LEVEL4 -- Flying Carpet
	SJMount_StaticMountList[44153] = SJMOUNT_LEVEL4 -- Flying Machine
	SJMount_StaticMountList[32235] = SJMOUNT_LEVEL4 -- Golden Gryphon
	SJMount_StaticMountList[32245] = SJMOUNT_LEVEL4 -- Green Wind Rider
	SJMount_StaticMountList[32240] = SJMOUNT_LEVEL4 -- Snowy Gryphon
	SJMount_StaticMountList[46197] = SJMOUNT_LEVEL4 -- X-51 Nether-Rocket
	SJMount_StaticMountList[33943] = SJMOUNT_LEVEL4 -- Druid Flight Form
	--[[
	-- WATER MOUNTS (LEVEL 5)
	--]]
	SJMount_StaticMountList[64731] = SJMOUNT_LEVEL5 -- Sea Turtle
	SJMount_StaticMountList[75207] = SJMOUNT_LEVEL5 -- Abyssal Seahorse
end