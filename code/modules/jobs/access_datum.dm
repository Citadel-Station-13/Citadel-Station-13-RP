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

/var/const/access_external_airlocks = 13
/datum/access/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_emergency_storage = 14
/datum/access/emergency_storage
	id = access_emergency_storage
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_change_ids = 15
/datum/access/change_ids
	id = access_change_ids
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

/var/const/access_ai_upload = 16
/datum/access/ai_upload
	id = access_ai_upload
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

/var/const/access_teleporter = 17
/datum/access/teleporter
	id = access_teleporter
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/var/const/access_eva = 18
/datum/access/eva
	id = access_eva
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

/var/const/access_heads = 19
/datum/access/heads
	id = access_heads
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/var/const/access_captain = 20
/datum/access/captain
	id = access_captain
	desc = "Facility Director"
	region = ACCESS_REGION_COMMAND

/var/const/access_all_personal_lockers = 21
/datum/access/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/var/const/access_chapel_office = 22
/datum/access/chapel_office
	id = access_chapel_office
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/var/const/access_tech_storage = 23
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_atmospherics = 24
/datum/access/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_bar = 25
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/var/const/access_janitor = 26
/datum/access/janitor
	id = access_janitor
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/var/const/access_crematorium = 27
/datum/access/crematorium
	id = access_crematorium
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/var/const/access_kitchen = 28
/datum/access/kitchen
	id = access_kitchen
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

/var/const/access_robotics = 29
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/var/const/access_rd = 30
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/var/const/access_cargo = 31
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/var/const/access_construction = 32
/datum/access/construction
	id = access_construction
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_chemistry = 33
/datum/access/chemistry
	id = access_chemistry
	desc = "Chemistry Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_cargo_bot = 34
/datum/access/cargo_bot
	id = access_cargo_bot
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/var/const/access_hydroponics = 35
/datum/access/hydroponics
	id = access_hydroponics
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/var/const/ACCESS_GENERAL_LIBRARY = 37
/datum/access/library
	id = ACCESS_GENERAL_LIBRARY
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/var/const/ACCESS_COMMAND_IAA = 38
/datum/access/lawyer
	id = ACCESS_COMMAND_IAA
	desc = "Internal Affairs"
	region = ACCESS_REGION_COMMAND

/var/const/access_virology = 39
/datum/access/virology
	id = access_virology
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/var/const/ACCESS_MEDICAL_CMO = 40
/datum/access/cmo
	id = ACCESS_MEDICAL_CMO
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_SUPPLY_QM = 41
/datum/access/qm
	id = ACCESS_SUPPLY_QM
	desc = "Quartermaster"
	region = ACCESS_REGION_SUPPLY

/var/const/ACCESS_SCIENCE_EXONET = 42
/datum/access/network
	id = ACCESS_SCIENCE_EXONET
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

var/const/ACCESS_GENERAL_EXPLORER = 43
/datum/access/explorer
	id = ACCESS_GENERAL_EXPLORER
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

var/const/ACCESS_GENERAL_PATHFINDER = 44
/datum/access/pathfinder
	id = ACCESS_GENERAL_PATHFINDER
	desc = "Pathfinder"
	region = ACCESS_REGION_GENERAL

#warn make sure sci can edit these

/var/const/ACCESS_MEDICAL_SURGERY = 45
/datum/access/surgery
	id = ACCESS_MEDICAL_SURGERY
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 46

/var/const/ACCESS_SCIENCE_MAIN = 47
/datum/access/research
	id = ACCESS_SCIENCE_MAIN
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/var/const/ACCESS_SUPPLY_MINE = 48
/datum/access/mining
	id = ACCESS_SUPPLY_MINE
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/var/const/ACCESS_SUPPLY_MAIN = 50
/datum/access/mailsorting
	id = ACCESS_SUPPLY_MAIN
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 51
// /var/const/free_access_id = 52

/var/const/ACCESS_COMMAND_VAULT = 53
/datum/access/heads_vault
	id = ACCESS_COMMAND_VAULT
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_SUPPLY_MINE_OUTPOST = 54
/datum/access/mining_station
	id = ACCESS_SUPPLY_MINE_OUTPOST
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

/var/const/ACCESS_SCIENCE_XENOBIO = 55
/datum/access/xenobiology
	id = ACCESS_SCIENCE_XENOBIO
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/ACCESS_ENGINEERING_CE = 56
/datum/access/ce
	id = ACCESS_ENGINEERING_CE
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/ACCESS_COMMAND_HOP = 57
/datum/access/hop
	id = ACCESS_COMMAND_HOP
	desc = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_SECURITY_HOS = 58
/datum/access/hos
	id = ACCESS_SECURITY_HOS
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/var/const/ACCESS_COMMAND_ANNOUNCE = 59 //Request console announcements
/datum/access/RC_announce
	id = ACCESS_COMMAND_ANNOUNCE
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_COMMAND_KEYAUTH = 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = ACCESS_COMMAND_KEYAUTH
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_ENGINEERING_TELECOMMS = 61 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = ACCESS_ENGINEERING_TELECOMMS
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_GENERAL_GATEWAY = 62
/datum/access/gateway
	id = ACCESS_GENERAL_GATEWAY
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

/var/const/ACCESS_SECURITY_MAIN = 63 // Security front doors
/datum/access/sec_doors
	id = ACCESS_SECURITY_MAIN
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/var/const/ACCESS_MEDICAL_PSYCH = 64 // Psychiatrist's office
/datum/access/psychiatrist
	id = ACCESS_MEDICAL_PSYCH
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/var/const/ACCESS_SCIENCE_XENOARCH = 65
/datum/access/xenoarch
	id = ACCESS_SCIENCE_XENOARCH
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/var/const/ACCESS_MEDICAL_EQUIPMENT = 66
/datum/access/medical_equip
	id = ACCESS_MEDICAL_EQUIPMENT
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

var/const/ACCESS_GENERAL_PILOT = 67
/datum/access/pilot
	id = ACCESS_GENERAL_PILOT
	desc = "Pilot"
	region = ACCESS_REGION_SUPPLY

/var/const/ACCESS_GENERAL_ENTERTAINMENT = 72
/datum/access/entertainment
	id = ACCESS_GENERAL_ENTERTAINMENT
	desc = "Entertainment Backstage"
	region = ACCESS_REGION_GENERAL

/var/const/ACCESS_SCIENCE_XENOBOTANY = 77
/datum/access/xenobotany
	id = ACCESS_SCIENCE_XENOBOTANY
	desc = "Xenobotany Garden"
	region = ACCESS_REGION_RESEARCH

/***************
* Antag access *
***************/
/var/const/access_syndicate = 150//General Syndicate Access
/datum/access/syndicate
	id = access_syndicate
	access_type = ACCESS_TYPE_SYNDICATE

/var/const/access_pirate = 168//Pirate Crew Access (Blackbeard was born in 1680.)
/datum/access/pirate
	id = access_pirate
	access_type = ACCESS_TYPE_PRIVATE

/*******
* Misc *
*******/
/var/const/access_trader = 160//General Beruang Trader Access
/datum/access/trader
	id = access_trader
	access_type = ACCESS_TYPE_PRIVATE

/var/const/access_synth = 199
/datum/access/synthetic
	id = access_synth
	desc = "Synthetic"
	access_type = ACCESS_TYPE_NONE

/var/const/access_crate_cash = 200
/datum/access/crate_cash
	id = access_crate_cash
	access_type = ACCESS_TYPE_NONE

/var/const/access_alien = 300 // For things like crashed ships.
/datum/access/alien
	id = access_alien
	desc = "#%_^&*@!"
	access_type = ACCESS_TYPE_PRIVATE

/var/const/access_talon = 301
/datum/access/talon
	id = access_talon
	desc = "Talon"
	access_type = ACCESS_TYPE_PRIVATE
