
local NUM_MOUNTS = GetNumCompanions(MOUNT)

SJmount_MountList = SJmount_MountList or nil

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

function SJmount_MountList_Init()
	SJmount_MountList = {}
	SJmount_MountList["EPIC_GROUND"] = {
		[92155] = false, -- Ultramarine Qiraji Battle Tank
		[26656] = false, -- Black Qiraji Battle Tank
		[41252] = false, -- Raven Lord
		[93644] = false, -- Kor'kron Annihilator
		[90621] = false, -- Golden King
		[92232] = false, -- Spectral Wolf
		[92231] = false, -- Spectral Steed
		[84751] = false, -- Fossilized Raptor
		[43688] = false, -- Amani War Bear
		[74918] = false, -- Wooly White Rhino
		[58983] = false, -- Big Blizzard Bear
		[42777] = false, -- Swift Spectral Tiger
		[24242] = false, -- Swift Razzashi Raptor
		[24252] = false, -- Swift Zulian Tiger
		[46628] = false, -- Swift White Hawkstrider
		[48954] = false, -- Swift Zhevra
		[49322] = false, -- Swift Zhevra
		[69826] = false, -- Great Sunwalker Kodo
		[68188] = false, -- Crusader's Black Warhorse
		[68187] = false, -- Crusader's White Warhorse
		[66906] = false, -- Argent Charger
		[67466] = false, -- Argent Warhorse
		[66091] = false, -- Sunreaver Hawkstrider
		[73313] = false, -- Crimson Deathcharger
		[48778] = false, -- Deathcharger
		[16056] = false, -- Ancient Frostsaber (feat of strength)
		[16055] = false, -- Black Nightsaber (feat of strength)
		[87091] = false, -- Goblin Turbo-Trike
		[60114] = false, -- Armored Brown Bear
		[60116] = false, -- Armored Brown Bear
		[88748] = false, -- Brown Riding Camel
		[88750] = false, -- Grey Riding Camel
		[88749] = false, -- Tan Riding Camel
		[51412] = false, -- Big Battle Bear
		[22719] = false, -- Black Battlestrider
		[59572] = false, -- Black Polar Bear
		[17461] = false, -- Black Ram
		[60118] = false, -- Black War Bear
		[60119] = false, -- Black War Bear
		[48027] = false, -- Black War Elekk
		[22718] = false, -- Black War Kodo
		[59785] = false, -- Black War Mammoth
		[59788] = false, -- Black War Mammoth
		[22720] = false, -- Black War Ram
		[22721] = false, -- Black War Raptor
		[22717] = false, -- Black War Steed
		[22723] = false, -- Black War Tiger
		[22724] = false, -- Black War Wolf
		[59573] = false, -- Brown Polar Bear
		[39315] = false, -- Cobalt Riding Talbuk
		[34896] = false, -- Cobalt War Talbuk
		[39316] = false, -- Dark Riding Talbuk
		[34790] = false, -- Dark War Talbuk
		[36702] = false, -- Fiery Warhorse
		[23509] = false, -- Frostwolf Howler
		[59810] = false, -- Grand Black War Mammoth
		[59811] = false, -- Grand Black War Mammoth
		[60136] = false, -- Grand Caravan Mammoth
		[60140] = false, -- Grand Caravan Mammoth
		[59802] = false, -- Grand Ice Mammoth
		[59804] = false, -- Grand Ice Mammoth
		[35713] = false, -- Great Blue Elekk
		[49379] = false, -- Great Brewfest Kodo
		[23249] = false, -- Great Brown Kodo
		[34407] = false, -- Great Elite Elekk
		[23248] = false, -- Great Gray Kodo
		[35712] = false, -- Great Green Elekk
		[35714] = false, -- Great Purple Elekk
		[23247] = false, -- Great White Kodo
		[17465] = false, -- Green Skeletal Warhorse
		[48025] = false, -- Headless Horseman's Horse (variable)
		[75614] = false, -- Celestial Steed (variable)
		[59797] = false, -- Ice Mammoth
		[59799] = false, -- Ice Mammoth
		[55531] = false, -- Mechano-Hog
		[60424] = false, -- Mekgineer's Chopper
		[23246] = false, -- Purple Skeletal Warhorse
		[22722] = false, -- Red Skeletal Warhorse
		[17481] = false, -- Rivendare's Deathcharger
		[39317] = false, -- Silver Riding Talbuk
		[34898] = false, -- Silver War Talbuk
		[23510] = false, -- Stormpike Battle Charger
		[23241] = false, -- Swift Blue Raptor
		[43900] = false, -- Swift Brewfest Ram
		[23238] = false, -- Swift Brown Ram
		[23229] = false, -- Swift Brown Steed
		[23250] = false, -- Swift Brown Wolf
		[23221] = false, -- Swift Frostsaber
		[23239] = false, -- Swift Gray Ram
		[23252] = false, -- Swift Gray Wolf
		[35025] = false, -- Swift Green Hawkstrider
		[23225] = false, -- Swift Green Mechanostrider
		[23219] = false, -- Swift Mistsaber
		[23242] = false, -- Swift Olive Raptor
		[23243] = false, -- Swift Orange Raptor
		[23227] = false, -- Swift Palamino
		[33660] = false, -- Swift Pink Hawkstrider
		[35027] = false, -- Swift Purple Hawkstrider
		[23338] = false, -- Swift Stormsaber
		[23251] = false, -- Swift Timber Wolf
		[47037] = false, -- Swift War Elekk
		[35028] = false, -- Swift Warstrider
		[23223] = false, -- Swift White Mechanostrider
		[23240] = false, -- Swift White Ram
		[23228] = false, -- Swift White Steed
		[23222] = false, -- Swift Yellow Mechanostrider
		[39318] = false, -- Tan Riding Talbuk
		[34899] = false, -- Tan War Talbuk
		[54753] = false, -- White Polar Bear
		[39319] = false, -- White Riding Talbuk
		[34897] = false, -- White War Talbuk
		[17229] = false, -- Winterspring Frostsaber
		[59791] = false, -- Wooly Mammoth
		[59793] = false, -- Wooly Mammoth
		[23214] = false, -- Summon Charger (Alliance Paladin)
		[34767] = false, -- Summon Charger (Bloodelf Paladin)
		[23161] = false, -- Summon Dreadsteed
		[63635] = false, -- Darkspear Raptor (new Argent troll)
		[65644] = false, -- Swift Purple Raptor (old Argent troll)
		[63643] = false, -- Forsaken Warhorse (new Argent undead)
		[65645] = false, -- White Skeletal Warhorse (old Argent undead)
		[63641] = false, -- Thunder Bluff Kodo (new Argent tauren)
		[65641] = false, -- Great Golden Kodo (old Argent tauren)
		[63640] = false, -- Orgrimmar Wolf (new Argent orc)
		[65646] = false, -- Swift Burgundy Wolf (old Argent orc) (got off thottbot, not positive if correct)
		[63642] = false, -- Silvermoon Hawkstrider (new Argent bloodelf)
		[65639] = false, -- Swift Red Hawkstrider (old Argent bloodelf)
		[63637] = false, -- Darnassian Nightsaber (new Argent nightelf)
		[65638] = false, -- Swift Moonsaber (old Argent nightelf)
		[63639] = false, -- Exodar Elekk (new Argent draeni)
		[65637] = false, -- Great Red Elekk (old Argent draeni)
		[63638] = false, -- Gnomeregan Mechanostrider (new Argent gnome)
		[65642] = false, -- Turbostrider  (old Argent gnome) (got off thottbot, not positive if correct)
		[63636] = false, -- Ironforge Ram (new Argent dwarf)
		[65643] = false, -- Swift Violet Ram (old Argent dwarf)
		[63232] = false, -- Stormwind Steed (new Argent human)
		[65640] = false, -- Swift Gray Steed (old Argent human)
	}
	SJmount_MountList["REGULAR_GROUND"] = {
		[66907] = false, -- Argent Warhorse
		[87090] = false, -- Goblin Trike
		[64977] = false, -- Black Skeletal Horse
		[35020] = false, -- Blue Hawkstrider
		[10969] = false, -- Blue Mechanostrider
		[33630] = false, -- Blue Mechanostrider
		[578] = false, -- Black Wolf
		[64658] = false, -- Black Wolf
		[6896] = false, -- Black Ram
		[470] = false, -- Black Stallion
		[35022] = false, -- Black Hawkstrider
		[6897] = false, -- Blue Ram
		[17463] = false, -- Blue Skeletal Horse
		[50869] = false, -- Brewfest Kodo
		[49378] = false, -- Brewfest Riding Kodo
		[43899] = false, -- Brewfest Ram
		[50870] = false, -- Brewfest Ram
		[34406] = false, -- Brown Elekk
		[458] = false, -- Brown Horse
		[18990] = false, -- Brown Kodo
		[6899] = false, -- Brown Ram
		[17464] = false, -- Brown Skeletal Horse
		[6654] = false, -- Brown Wolf
		[6648] = false, -- Chestnut Mare
		[6653] = false, -- Dire Wolf
		[8395] = false, -- Emerald Raptor
		[16060] = false, -- Golden Sabercat *Unconfirmed*
		[35710] = false, -- Gray Elekk
		[18989] = false, -- Gray Kodo
		[6777] = false, -- Gray Ram
		[459] = false, -- Gray Wolf
		[15780] = false, -- Green Mechanostrider
		[17453] = false, -- Green Mechanostrider
		[471] = false, -- Palamino
		[472] = false, -- Pinto
		[35711] = false, -- Purple Elekk
		[35018] = false, -- Purple Hawkstrider
		[17455] = false, -- Purple Mechanostrider
		[17456] = false, -- Red & Blue Mechanostrider
		[34795] = false, -- Red Hawkstrider
		[10873] = false, -- Red Mechanostrider
		[17462] = false, -- Red Skeletal Horse
		[30174] = false, -- Riding Turtle
		[42776] = false, -- Spectral Tiger
		[10789] = false, -- Spotted Frostsaber
		[15781] = false, -- Steel Mechanostrider
		[8394] = false, -- Striped Frostsaber
		[10793] = false, -- Striped Nightsaber
		[580] = false, -- Timber Wolf
		[10796] = false, -- Turquoise Raptor
		[17454] = false, -- Unpainted Mechanostrider
		[10799] = false, -- Violet Raptor
		[6898] = false, -- White Ram
		[468] = false, -- White Stallion
		[581] = false, -- Winter Wolf
		[34769] = false, -- Summon Warhorse (Bloodelf Paladin)
		[13819] = false, -- Summon Warhorse (Alliance Paladin)
		[5784] = false, -- Summon Felsteed
	}
	SJmount_MountList["EPIC_FLYING"] = {
		[72286] = false, -- Invincible (variable)
		[63796] = false, -- Mimiron's Head (310)
		[71810] = false, -- Wrathful Gladiator's Frostwyrm (310)
		[67336] = false, -- Relentless Gladiator's Frostwyrm (310)
		[65439] = false, -- Furious Gladiator's Frostwyrm (310)
		[64927] = false, -- Deadly Gladiator's Frostwyrm (310)
		[72808] = false, -- Bloodbathed Frostbrood Vanquisher (310)
		[43810] = false, -- Frost Wyrm (280) *Unconfirmed*
		[51960] = false, -- Frost Wyrm (280) *Unconfirmed*
		[63956] = false, -- Ironbound Proto Drake (310)
		[63963] = false, -- Rusted Proto Drake (310)
		[40192] = false, -- Ashes of Al'ar (Phoenix) (310)
		[58615] = false, -- Brutal Nether Drake (310)
		[44317] = false, -- Merciless Nether Drake (310)
		[44744] = false, -- Merciless Nether Drake (310)
		[37015] = false, -- Swift Nether Drake (310)
		[49193] = false, -- Vengeful Nether Drake (310)
		[60021] = false, -- Plagued Proto Drake (310)
		[59976] = false, -- Black Proto Drake (310)
		[59996] = false, -- Blue Proto Drake (280)
		[61294] = false, -- Green Proto Drake (280)
		[59961] = false, -- Red Proto Drake (280)
		[60002] = false, -- Time-Lost Proto Drake (280)
		[60024] = false, -- Violet Proto Drake (280)
		[88335] = false, -- Drake of the East Wind (280)
		[88742] = false, -- Drake of the North Wind (280)
		[88744] = false, -- Drake of the South Wind (280)
		[88741] = false, -- Drake of the West Wind (280)
		[88990] = false, -- Dark Phoenix (280)
		[88718] = false, -- Phosphorescent Stone Drake (280)
		[93326] = false, -- Sandstone Drake (280)
		[88746] = false, -- Vitreous Stone Drake (280)
		[88331] = false, -- Volcanic Stone Drake (280)
		[62048] = false, -- Black Dragonhawk Mount (280)
		[61996] = false, -- Blue Dragonhawk Mount (280)
		[61997] = false, -- Red Dragonhawk Mount (280)
		[71342] = false, -- Big Love Rocket (variable)
		[75596] = false, -- Frosty Flying Carpet (280)
		[66087] = false, -- Silver Covenant Hippogryph (280)
		[66088] = false, -- Sunreaver Dragonhawk (280)
		[60025] = false, -- Albino Drake (280)
		[59567] = false, -- Azure Drake (280)
		[59650] = false, -- Black Drake (280)
		[59568] = false, -- Blue Drake (280)
		[59569] = false, -- Bronze Drake (280)
		[59570] = false, -- Red Drake (280)
		[59571] = false, -- Twilight Drake (280)
		[63844] = false, -- Argent Hippogryph (280)
		[41514] = false, -- Azure Netherwing Drake (280)
		[41515] = false, -- Cobalt Netherwing Drake (280)
		[41513] = false, -- Onyx Netherwing Drake (280)
		[41516] = false, -- Purple Netherwing Drake (280)
		[41517] = false, -- Veridian Netherwing Drake (280)
		[41518] = false, -- Violet Netherwing Drake (280)
		[39803] = false, -- Blue Riding Nether Ray (280)
		[39798] = false, -- Green Riding Nether Ray (280)
		[39801] = false, -- Purple Riding Nether Ray (280)
		[39800] = false, -- Red Riding Nether Ray (280)
		[39802] = false, -- Silver Riding Nether Ray (280)
		[43927] = false, -- Cenarian War Hippogryph (280)
		[63844] = false, -- Argent Hippogryph (280)
		[61230] = false, -- Armored Blue Wind Rider (280)
		[61229] = false, -- Armored Snowy Gryphon (280)
		[61309] = false, -- Magnificient Flying Carpet (280)
		[32242] = false, -- Swift Blue Gryphon (280)
		[32290] = false, -- Swift Green Gryphon (280)
		[32295] = false, -- Swift Green Wind Rider (280)
		[61442] = false, -- Swift Mooncloth Carpet (280)
		[32292] = false, -- Swift Purple Griffon (280)
		[32297] = false, -- Swift Purple Wind Rider (280)
		[32289] = false, -- Swift Red Gryphon (280)
		[32246] = false, -- Swift Red Wind Rider (280)
		[61444] = false, -- Swift Shadoweave Carpet (280)
		[61446] = false, -- Swift Spellfire Carpet (280)
		[32296] = false, -- Swift Yellow Wind Rider (280)
		[44151] = false, -- Turbo-Charged Flying Machine (280)
		[46199] = false, -- X-51 Nether-Rocket Extreme (280)
		[54729] = false, -- Winged Steed of the Ebon Blade (variable)
		[48025] = false, -- Headless Horseman's Horse (variable)
		[75614] = false, -- Celestial Steed (variable)
		[75973] = false, -- X-53 Touring Rocket (variable)
		[40120] = false, -- Druid Swift Flight Form
	}
	SJmount_MountList["REGULAR_FLYING"] = {
		-- REGULAR FLYING MOUNTS
		[32243] = false, -- Tawny Wind Rider
		[32244] = false, -- Blue Wind Rider
		[32239] = false, -- Ebon Gryphon
		[61451] = false, -- Flying Carpet
		[44153] = false, -- Flying Machine
		[32235] = false, -- Golden Gryphon
		[32245] = false, -- Green Wind Rider
		[32240] = false, -- Snowy Gryphon
		[46197] = false, -- X-51 Nether-Rocket
		[33943] = false, -- Druid Flight Form

		-- WATER MOUNTS
		[64731] = false, -- Sea Turtle
		[75207] = false, -- Abyssal Seahorse
	}
end