//? Access Regions
//* For custom accesses, use none.
//* Keep this synced with [tgui/packages/tgui/constants/access.ts]

#define ACCESS_REGION_NONE (0)
#define ACCESS_REGION_ALL (~0)
#define ACCESS_REGION_SECURITY (1<<0)
#define ACCESS_REGION_MEDBAY (1<<1)
#define ACCESS_REGION_RESEARCH (1<<2)
#define ACCESS_REGION_ENGINEERING (1<<3)
#define ACCESS_REGION_COMMAND (1<<4)
#define ACCESS_REGION_GENERAL (1<<5)
#define ACCESS_REGION_SUPPLY (1<<6)

// todo: nuke this from orbit
#define DUMB_OLD_ACCESS_REGION_LIST list(ACCESS_REGION_SECURITY, ACCESS_REGION_MEDBAY, ACCESS_REGION_RESEARCH, ACCESS_REGION_ENGINEERING, ACCESS_REGION_COMMAND, ACCESS_REGION_GENERAL, ACCESS_REGION_SUPPLY)

DEFINE_SHARED_BITFIELD(access_region, list(
	"access_region",
	"access_edit_region"
), list(
	BITFIELD(ACCESS_REGION_SECURITY),
	BITFIELD(ACCESS_REGION_MEDBAY),
	BITFIELD(ACCESS_REGION_RESEARCH),
	BITFIELD(ACCESS_REGION_ENGINEERING),
	BITFIELD(ACCESS_REGION_COMMAND),
	BITFIELD(ACCESS_REGION_GENERAL),
	BITFIELD(ACCESS_REGION_SUPPLY),
))

GLOBAL_LIST_INIT(access_region_names, list(
	"[ACCESS_REGION_GENERAL]" = "General",
	"[ACCESS_REGION_COMMAND]" = "Command",
	"[ACCESS_REGION_SECURITY]" = "Security",
	"[ACCESS_REGION_ENGINEERING]" = "Engineering",
	"[ACCESS_REGION_MEDBAY]" = "Medical",
	"[ACCESS_REGION_RESEARCH]" = "Science",
	"[ACCESS_REGION_SUPPLY]" = "Supply",
))

//? Access Types
//* For custom accesses, use none.
//* Keep this synced with [tgui/packages/tgui/constants/access.ts]

#define ACCESS_TYPE_NONE (0)
#define ACCESS_TYPE_ALL (~0)
#define ACCESS_TYPE_CENTCOM (1<<0)
#define ACCESS_TYPE_STATION (1<<1)
#define ACCESS_TYPE_SYNDICATE (1<<2)
#define ACCESS_TYPE_PRIVATE (1<<3)

DEFINE_SHARED_BITFIELD(access_type, list(
	"access_type",
	"access_edit_type"
), list(
	BITFIELD(ACCESS_TYPE_CENTCOM),
	BITFIELD(ACCESS_TYPE_STATION),
	BITFIELD(ACCESS_TYPE_SYNDICATE),
	BITFIELD(ACCESS_TYPE_PRIVATE),
))

GLOBAL_LIST_INIT(access_type_names, list(
	"[ACCESS_TYPE_CENTCOM]" = "Central Command",
	"[ACCESS_TYPE_STATION]" = "Station",
	"[ACCESS_TYPE_SYNDICATE]" = "Mercenary",
	"[ACCESS_TYPE_PRIVATE]" = "Unknown",
))

//? Access Values - constants & datums                ?//
//! DEFINE NUMBERS MUST NEVER CHANGE                  !//
//* Otherwise all maps break.                         *//
//* MAPPERS: This is also where you find your values! *//

//--------------------------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------------------------//
//? THE CURRENT HIGHEST IS 307. UPDATE THIS VALUE AS NEEDED. ADD CONTINUOUSLY, DO NOT SKIP VALUES. ?//
//--------------------------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------------------------//

// When oh when will we escape the tyranny of number enums?
// todo: eventually we'll want a script for "migrating" access in .dmms. if that's, y'know, even possible
//       when we do this however it has to be a "do this once and never again" deal
//       as it's bound to break stuff.

#define STANDARD_ACCESS_DATUM(value, type, desc) \
/datum/access/##type { \
	access_name = desc; \
	access_value = value; \
} \
/datum/access/##type

//* STATION *//

//? General

#define ACCESS_GENERAL_CHAPEL 22
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_CHAPEL, station/general/chapel, "Chapel Office")

#define ACCESS_GENERAL_BAR 25
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_BAR, station/general/bar, "Bar")

#define ACCESS_GENERAL_JANITOR 26
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_JANITOR, station/general/janitor, "Custodial Closet")

#define ACCESS_GENERAL_CREMATOR 27
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_CREMATOR, station/general/crematorium, "Crematorium")

#define ACCESS_GENERAL_KITCHEN 28
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_KITCHEN, station/general/kitchen, "Kitchen")

#define ACCESS_GENERAL_BOTANY 35
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_BOTANY, station/general/hydroponics, "Hydroponics")

#define ACCESS_GENERAL_LIBRARY 37
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_LIBRARY, station/general/library, "Library")

#define ACCESS_GENERAL_EXPLORER 43
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_EXPLORER, station/general/explorer, "Explorer")

#define ACCESS_GENERAL_PATHFINDER 44
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_PATHFINDER, station/general/pathfinder, "Pathfinder")
	access_edit_list = list(
		/datum/access/station/general/explorer,
		/datum/access/station/general/pilot,
		/datum/access/station/general/pathfinder,
	)

#define ACCESS_GENERAL_GATEWAY 62
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_GATEWAY, station/general/gateway, "Gateway")

#define ACCESS_GENERAL_PILOT 67
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_PILOT, station/general/pilot, "Pilot")

#define ACCESS_GENERAL_ENTERTAINMENT 72
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_ENTERTAINMENT, station/general/entertainment, "Entertainment Backstage")

#define ACCESS_GENERAL_CLOWN 136
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_CLOWN, station/general/clown, "Clown Office")

#define ACCESS_GENERAL_MIME 138
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_MIME, station/general/mime, "Mime Office")

#define ACCESS_GENERAL_TOMFOOLERY 137
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_TOMFOOLERY, station/general/tomfoolery, "Tomfoolery Closet")

#define ACCESS_GENERAL_EDIT 305
STANDARD_ACCESS_DATUM(ACCESS_GENERAL_EDIT, station/general/edit, "General - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_GENERAL
	access_edit_type = ACCESS_TYPE_STATION

//? Command

#define ACCESS_COMMAND_CARDMOD 15
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_CARDMOD, station/command/cardmod, "ID Modification")
	access_edit_type = ACCESS_TYPE_STATION
	access_edit_region = ACCESS_REGION_ALL

#define ACCESS_COMMAND_UPLOAD 16
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_UPLOAD, station/command/upload, "AI Upload")

#define ACCESS_COMMAND_TELEPORTER 17
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_TELEPORTER, station/command/teleporter, "Teleporter")

#define ACCESS_COMMAND_EVA 18
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_EVA, station/command/eva, "EVA")

#define ACCESS_COMMAND_BRIDGE 19
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_BRIDGE, station/command/bridge, "Bridge")

#define ACCESS_COMMAND_CAPTAIN 20
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_CAPTAIN, station/command/captain, "Facility Director")

#define ACCESS_COMMAND_LOCKERS 21
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_LOCKERS, station/command/lockers, "Personal Lockers")

#define ACCESS_COMMAND_IAA 38
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_IAA, station/command/iaa, "Internal Affairs")

#define ACCESS_COMMAND_ANNOUNCE 59
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_ANNOUNCE, station/command/announce, "RC Announcements")

#define ACCESS_COMMAND_KEYAUTH 60 //Used for events which require at least two people to confirm them
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_KEYAUTH, station/command/keyauth, "Keycard Authentication")

#define ACCESS_COMMAND_HOP 57
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_HOP, station/command/hop, "Head of Personnel")

#define ACCESS_COMMAND_VAULT 53
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_VAULT, station/command/vault, "Main Vault")

#define ACCESS_COMMAND_BANKING 68
STANDARD_ACCESS_DATUM(ACCESS_COMMAND_BANKING, station/command/bank_manage, "Account Uplink")

//? Security

#define ACCESS_SECURITY_EQUIPMENT 1
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_EQUIPMENT, station/security/equipment, "Security Equipment")

#define ACCESS_SECURITY_BRIG 2
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_BRIG, station/security/brig, "Brig")

#define ACCESS_SECURITY_ARMORY 3
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_ARMORY, station/security/armory, "Armory")

#define ACCESS_SECURITY_FORENSICS 4
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_FORENSICS, station/security/forensics, "Forensics")

#define ACCESS_SECURITY_MAIN 63 // Security front doors
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_MAIN, station/security/main, "Security")

#define ACCESS_SECURITY_HOS 58
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_HOS, station/security/hos, "Head of Security")

#define ACCESS_SECURITY_EDIT 306
STANDARD_ACCESS_DATUM(ACCESS_SECURITY_EDIT, station/security/edit, "Security - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_SECURITY
	access_edit_type = ACCESS_TYPE_STATION

//? Engineering

#define ACCESS_ENGINEERING_MAIN 10
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_MAIN, station/engineering/main, "Engineering")

#define ACCESS_ENGINEERING_ENGINE 11
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_ENGINE, station/engineering/engine, "Engine Room")

#define ACCESS_ENGINEERING_MAINT 12
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_MAINT, station/engineering/maint, "Maintenance")

#define ACCESS_ENGINEERING_AIRLOCK 13
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_AIRLOCK, station/engineering/airlock, "External Airlocks")

#define ACCESS_ENGINEERING_TRIAGE 14
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_TRIAGE, station/engineering/triage, "Engineering Triage")

#define ACCESS_ENGINEERING_TECHSTORAGE 23
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_TECHSTORAGE, station/engineering/techstorage, "Technical Storage")

#define ACCESS_ENGINEERING_ATMOS 24
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_ATMOS, station/engineering/atmos, "Atmospherics")

#define ACCESS_ENGINEERING_CONSTRUCTION 32
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_CONSTRUCTION, station/engineering/construction, "Construction Areas")

#define ACCESS_ENGINEERING_TELECOMMS 61 // has access to the entire telecomms satellite / machinery
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_TELECOMMS, station/engineering/tcomsat, "Telecomms")

#define ACCESS_ENGINEERING_CE 56
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_CE, station/engineering/ce, "Chief Engineer")

#define ACCESS_ENGINEERING_EDIT 303
STANDARD_ACCESS_DATUM(ACCESS_ENGINEERING_EDIT, station/engineering/edit, "Engineering - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_ENGINEERING
	access_edit_type = ACCESS_TYPE_STATION

//? Medical

#define ACCESS_MEDICAL_MAIN 5
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_MAIN, station/medical/main, "Medical")

#define ACCESS_MEDICAL_MORGUE 6
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_MORGUE, station/medical/morgue, "Morgue")

#define ACCESS_MEDICAL_CHEMISTRY 33
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_CHEMISTRY, station/medical/chemistry, "Chemistry Lab")

#define ACCESS_MEDICAL_VIROLOGY 39
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_VIROLOGY, station/medical/virology, "Virology")

#define ACCESS_MEDICAL_CMO 40
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_CMO, station/medical/cmo, "Chief Medical Officer")

#define ACCESS_MEDICAL_SURGERY 45
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_SURGERY, station/medical/surgery, "Surgery")

#define ACCESS_MEDICAL_PSYCH 64 // Psychiatrist's office
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_PSYCH, station/medical/psych, "Phychiatrist's Office")

#define ACCESS_SCIENCE_XENOARCH 65
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOARCH, station/science/xenoarch, "Xenoarchaeology")

#define ACCESS_MEDICAL_EQUIPMENT 66
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_EQUIPMENT, station/medical/equipment, "Medical Equipment")

#define ACCESS_MEDICAL_EDIT 302
STANDARD_ACCESS_DATUM(ACCESS_MEDICAL_EDIT, station/medical/edit, "Medical - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_MEDBAY
	access_edit_type = ACCESS_TYPE_STATION

//? Science

#define ACCESS_SCIENCE_FABRICATION 7
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_FABRICATION, station/science/fabrication, "Fabrication")

#define ACCESS_SCIENCE_TOXINS 8
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_TOXINS, station/science/toxins, "Toxins Lab")

#define ACCESS_SCIENCE_GENETICS 9
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_GENETICS, station/science/genetics, "Genetics Lab")

#define ACCESS_SCIENCE_ROBOTICS 29
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_ROBOTICS, station/science/robotics, "Robotics")

#define ACCESS_SCIENCE_RD 30
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_RD, station/science/rd, "Research Director")

#define ACCESS_SCIENCE_EXONET 42
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_EXONET, station/science/exonet, "Station Network")

#define ACCESS_SCIENCE_MAIN 47
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_MAIN, station/science/main, "Science")

#define ACCESS_SCIENCE_XENOBIO 55
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOBIO, station/science/xenobiology, "Xenobiology Lab")

#define ACCESS_SCIENCE_XENOBOTANY 77
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_XENOBOTANY, station/science/xenobotany, "Xenobotany Garden")

#define ACCESS_SCIENCE_EDIT 307
STANDARD_ACCESS_DATUM(ACCESS_SCIENCE_EDIT, station/science/edit, "Science - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_RESEARCH
	access_edit_type = ACCESS_TYPE_STATION

//? Supply

#define ACCESS_SUPPLY_BAY 31
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_BAY, station/supply/cargo, "Cargo Bay")

#define ACCESS_SUPPLY_MULEBOT 34
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MULEBOT, station/supply/mulebot, "Mulebot Access")

#define ACCESS_SUPPLY_QM 41
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_QM, station/supply/qm, "Quartermaster")

#define ACCESS_SUPPLY_MINE 48
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MINE, station/supply/mining, "Mining")

#define ACCESS_SUPPLY_MAIN 50
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MAIN, station/supply/main, "Cargo Office")

#define ACCESS_SUPPLY_MINE_OUTPOST 54
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_MINE_OUTPOST, station/supply/mining_outpost, "Mining EVA")

#define ACCESS_SUPPLY_EDIT 304
STANDARD_ACCESS_DATUM(ACCESS_SUPPLY_EDIT, station/supply/edit, "Supply - Access Edit")
	sort_order = -1000
	access_edit_region = ACCESS_REGION_SUPPLY
	access_edit_type = ACCESS_TYPE_STATION

//* CENTCOM *//

#define ACCESS_CENTCOM_GENERAL 101
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_GENERAL, centcom/general, "General Facilities")

#define ACCESS_CENTCOM_THUNDERDOME 102
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_THUNDERDOME, centcom/thunderdome, "Entertainment Facilities")

#define ACCESS_CENTCOM_ERT 103
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_ERT, centcom/ert, "Emergency Response Team")

#define ACCESS_CENTCOM_MEDICAL 104
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_MEDICAL, centcom/medical, "Medical Facilities")

#define ACCESS_CENTCOM_DORMS 105
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_DORMS, centcom/dorms, "Dormitories")

#define ACCESS_CENTCOM_STORAGE 106
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_STORAGE, centcom/storage, "Storage")

#define ACCESS_CENTCOM_TELEPORTER 107
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_TELEPORTER, centcom/teleporter, "Teleporter")

#define ACCESS_CENTCOM_ERT_LEAD 108
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_ERT_LEAD, centcom/ert_lead, "ERT Administration")

#define ACCESS_CENTCOM_ADMIRAL 109
STANDARD_ACCESS_DATUM(ACCESS_CENTCOM_ADMIRAL, centcom/admiral, "Admiral")
	access_edit_region = ACCESS_REGION_ALL
	access_edit_type = ACCESS_TYPE_CENTCOM | ACCESS_TYPE_STATION

//* FACTIONS *//

//? Syndicate

#define ACCESS_FACTION_SYNDICATE 150//General Syndicate Access
STANDARD_ACCESS_DATUM(ACCESS_FACTION_SYNDICATE, faction/syndicate, "Syndicate")

//? Pirate

#define ACCESS_FACTION_PIRATE 168//Pirate Crew Access (Blackbeard was born in 1680.)
STANDARD_ACCESS_DATUM(ACCESS_FACTION_PIRATE, faction/pirate, "Pirate")

//? Trader

#define ACCESS_FACTION_TRADER 160//General Beruang Trader Access
STANDARD_ACCESS_DATUM(ACCESS_FACTION_TRADER, faction/trader, "Trader")

//? Alien

#define ACCESS_FACTION_ALIEN 300 // For things like crashed ships.
STANDARD_ACCESS_DATUM(ACCESS_FACTION_ALIEN, faction/alien, "Alien")

//? Talon

#define ACCESS_FACTION_TALON 301
STANDARD_ACCESS_DATUM(ACCESS_FACTION_TALON, faction/talon, "Talon")

//? Misc

#define ACCESS_MISC_CASHCRATE 200
STANDARD_ACCESS_DATUM(ACCESS_MISC_CASHCRATE, misc/cashcrate, "Cash Crates")

//* SPECIAL *//

//? Silicons

#define ACCESS_SPECIAL_SILICONS 199
STANDARD_ACCESS_DATUM(ACCESS_SPECIAL_SILICONS, special/silicons, "Synthetic")
