/datum/access
	var/id = 0
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/dd_SortValue()
	return "[access_type][desc]"

/*****************
* Station access *
*****************/


#define ACCESS_COMMAND_CARDMOD 15
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_CARDMOD, station/command/cardmod, "ID Computer")

#define ACCESS_COMMAND_UPLOAD 16
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_UPLOAD, station/command/upload, "AI Upload")

#define ACCESS_COMMAND_TELEPORTER 17
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_TELEPORTER, station/command/teleporter, "Teleporter")

#define ACCESS_COMMAND_EVA 18
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_EVA, station/command/eva, "EVA")

#define ACCESS_COMMAND_BRIDGE 19
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_BRIDGE, station/command/bridge, "Bridge")







#define ACCESS_ENGINEERING_CONSTRUCTION 32
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_CONSTRUCTION, construction, "Construction Areas")

#define ACCESS_MEDICAL_CHEMISTRY 33
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_CHEMISTRY, chemistry, "Chemistry Lab")

#define ACCESS_SUPPLY_MULEBOT 34
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MULEBOT, cargo_bot, "Cargo Bot Delivery")

#define ACCESS_GENERAL_BOTANY 35
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_BOTANY, hydroponics, "Hydroponics")

#define ACCESS_GENERAL_LIBRARY 37
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_LIBRARY, library, "Library")

#define ACCESS_MEDICAL_VIROLOGY 39
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_VIROLOGY, virology, "Virology")

#define ACCESS_MEDICAL_CMO 40
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_CMO, cmo, "Chief Medical Officer")

#define ACCESS_SUPPLY_QM 41
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_QM, qm, "Quartermaster")

#define ACCESS_SCIENCE_EXONET 42
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_EXONET, network, "Station Network")

#define ACCESS_GENERAL_EXPLORER 43
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_EXPLORER, explorer, "Explorer")

#define ACCESS_GENERAL_PATHFINDER 44
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_PATHFINDER, pathfinder, "Pathfinder")

#warn make sure sci can edit these

#define ACCESS_MEDICAL_SURGERY 45
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_SURGERY, surgery, "Surgery")

// #define free_access_id 46

#define ACCESS_SCIENCE_MAIN 47
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_MAIN, research, "Science")

#define ACCESS_SUPPLY_MINE 48
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MINE, mining, "Mining")

#define ACCESS_SUPPLY_MAIN 50
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MAIN, mailsorting, "Cargo Office")

// #define free_access_id 51
// #define free_access_id 52

#define ACCESS_COMMAND_VAULT 53
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_VAULT, heads_vault, "Main Vault")

#define ACCESS_SUPPLY_MINE_OUTPOST 54
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MINE_OUTPOST, mining_station, "Mining EVA")

#define ACCESS_SCIENCE_XENOBIO 55
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOBIO, xenobiology, "Xenobiology Lab")

#define ACCESS_ENGINEERING_CE 56
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_CE, ce, "Chief Engineer")

#define ACCESS_COMMAND_HOP 57
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_HOP, hop, "Head of Personnel")

#define ACCESS_SECURITY_HOS 58
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_HOS, hos, "Head of Security")

#define ACCESS_COMMAND_ANNOUNCE 59 //Request console announcements
/datum/access/RC_announce
	id = ACCESS_COMMAND_ANNOUNCE
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

#define ACCESS_COMMAND_KEYAUTH 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = ACCESS_COMMAND_KEYAUTH
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

#define ACCESS_ENGINEERING_TELECOMMS 61 // has access to the entire telecomms satellite / machinery
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_TELECOMMS, tcomsat, "Telecommunications")

#define ACCESS_GENERAL_GATEWAY 62
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_GATEWAY, gateway, "Gateway")

#define ACCESS_SECURITY_MAIN 63 // Security front doors
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_MAIN, sec_doors, "Security")

#define ACCESS_MEDICAL_PSYCH 64 // Psychiatrist's office
/datum/access/psychiatrist
	id = ACCESS_MEDICAL_PSYCH
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_SCIENCE_XENOARCH 65
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOARCH, xenoarch, "Xenoarchaeology")

#define ACCESS_MEDICAL_EQUIPMENT 66
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_EQUIPMENT, medical_equip, "Medical Equipment")

#define ACCESS_GENERAL_PILOT 67
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_PILOT, pilot, "Pilot")

#define ACCESS_GENERAL_ENTERTAINMENT 72
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_ENTERTAINMENT, entertainment, "Entertainment Backstage")

#define ACCESS_SCIENCE_XENOBOTANY 77
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOBOTANY, xenobotany, "Xenobotany Garden")

/***************
* Antag access *
***************/
#define ACCESS_FACTION_SYNDICATE 150//General Syndicate Access
/datum/access/syndicate
	id = ACCESS_FACTION_SYNDICATE
	access_type = ACCESS_TYPE_SYNDICATE

#define ACCESS_FACTION_PIRATE_MAIN 168//Pirate Crew Access (Blackbeard was born in 1680.)
/datum/access/pirate
	id = ACCESS_FACTION_PIRATE_MAIN
	access_type = ACCESS_TYPE_PRIVATE

/*******
* Misc *
*******/
#define ACCESS_FACTION_TRADER_MAIN 160//General Beruang Trader Access
/datum/access/trader
	id = ACCESS_FACTION_TRADER_MAIN
	access_type = ACCESS_TYPE_PRIVATE

#define ACCESS_SILICON_MAIN 199
/datum/access/synthetic
	id = ACCESS_SILICON_MAIN
	desc = "Synthetic"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_MISC_CASHCRATE 200
/datum/access/crate_cash
	id = ACCESS_MISC_CASHCRATE
	access_type = ACCESS_TYPE_NONE

#define ACCESS_FACTION_ALIEN 300 // For things like crashed ships.
/datum/access/alien
	id = ACCESS_FACTION_ALIEN
	desc = "#%_^&*@!"
	access_type = ACCESS_TYPE_PRIVATE

#define ACCESS_FACTION_TALON 301
/datum/access/talon
	id = ACCESS_FACTION_TALON
	desc = "Talon"
	access_type = ACCESS_TYPE_PRIVATE
