//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/map_helper/access_helper/airlock

/obj/map_helper/access_helper/airlock/apply(obj/machinery/door/airlock/to_what)
	// our lists aren't cached, luckily
	// if's are just shameless and unnecessary memory optimizing for like 5 bytes each lmao
	if(to_what.req_access != src.req_access)
		to_what.req_access = src.req_access
	if(to_what.req_one_access != req_one_access)
		to_what.req_one_access = src.req_one_access

/obj/map_helper/access_helper/airlock/detect()
	return locate(/obj/machinery/door/airlock) in loc

/obj/map_helper/access_helper/airlock/station
	icon_state = "station"

/obj/map_helper/access_helper/airlock/station/maintenance
	req_access = list(
		ACCESS_ENGINEERING_MAINT,
	)
	icon_state = "engineering"

/obj/map_helper/access_helper/airlock/station/external_airlock
	req_access = list(
		ACCESS_ENGINEERING_AIRLOCK,
	)
	icon_state = "engineering"

/**
 * for pilots
 */
/obj/map_helper/access_helper/airlock/station/flight_crew
	req_one_access = list(
		ACCESS_GENERAL_PILOT,
		ACCESS_COMMAND_BRIDGE,
	)

/**
 * for external engineering storage usable by other departments
 */
/obj/map_helper/access_helper/airlock/station/technical_storage
	req_access = list(
		ACCESS_ENGINEERING_TECHSTORAGE,
	)
	icon_state = "engineering"

/**
 * for general EVA / stationkeeping storage
 */
/obj/map_helper/access_helper/airlock/station/eva_storage
	req_one_access = list(
		ACCESS_COMMAND_EVA,
		ACCESS_ENGINEERING_AIRLOCK,
	)
	icon_state = "command"

/**
 * 'general station access' for use later in some maps
 * if we want the map to share room with say, offmaps, but
 * not let offmaps into foyers
 */
/obj/map_helper/access_helper/airlock/station/public
	req_access = list()
	icon_state = "station"

/obj/map_helper/access_helper/airlock/station/security
	icon_state = "security"

/obj/map_helper/access_helper/airlock/station/security/department
	req_one_access = list(
		ACCESS_SECURITY_BRIG,
		ACCESS_SECURITY_EQUIPMENT,
		ACCESS_SECURITY_MAIN,
	)

/obj/map_helper/access_helper/airlock/station/security/equipment
	req_access = list(
		ACCESS_SECURITY_EQUIPMENT,
	)

/obj/map_helper/access_helper/airlock/station/security/armory
	req_access = list(
		ACCESS_SECURITY_ARMORY,
	)

/obj/map_helper/access_helper/airlock/station/security/control
	req_access = list(
		ACCESS_SECURITY_ARMORY,
	)

/obj/map_helper/access_helper/airlock/station/security/forensics
	req_access = list(
		ACCESS_SECURITY_FORENSICS,
	)

/obj/map_helper/access_helper/airlock/station/security/brig
	req_one_access = list(
		ACCESS_SECURITY_BRIG,
	)

/obj/map_helper/access_helper/airlock/station/engineering
	icon_state = "engineering"

/obj/map_helper/access_helper/airlock/station/engineering/department
	req_one_access = list(
		ACCESS_ENGINEERING_MAIN,
		ACCESS_ENGINEERING_ATMOS,
		ACCESS_ENGINEERING_ENGINE,
	)

/**
 * for internal department storage
 */
/obj/map_helper/access_helper/airlock/station/engineering/storage
	req_one_access = list(
		ACCESS_ENGINEERING_ENGINE,
		ACCESS_ENGINEERING_ATMOS,
	)

/obj/map_helper/access_helper/airlock/station/engineering/telecomms
	req_access = list(
		ACCESS_ENGINEERING_TELECOMMS,
	)

/obj/map_helper/access_helper/airlock/station/engineering/construction
	req_access = list(
		ACCESS_ENGINEERING_CONSTRUCTION,
	)

/obj/map_helper/access_helper/airlock/station/engineering/engine
	req_access = list(
		ACCESS_ENGINEERING_ENGINE,
	)

/obj/map_helper/access_helper/airlock/station/engineering/atmospherics
	req_access = list(
		ACCESS_ENGINEERING_ATMOS,
	)

/obj/map_helper/access_helper/airlock/station/medical
	icon_state = "medical"

/obj/map_helper/access_helper/airlock/station/medical/department
	req_one_access = list(
		ACCESS_MEDICAL_MAIN,
	)

/obj/map_helper/access_helper/airlock/station/medical/chemistry
	req_access = list(
		ACCESS_MEDICAL_CHEMISTRY,
	)

/obj/map_helper/access_helper/airlock/station/medical/virology
	req_access = list(
		ACCESS_MEDICAL_VIROLOGY,
	)

/obj/map_helper/access_helper/airlock/station/medical/surgery
	req_access = list(
		ACCESS_MEDICAL_SURGERY,
	)

/obj/map_helper/access_helper/airlock/station/medical/psychiatry
	req_access = list(
		ACCESS_MEDICAL_PSYCH,
	)

/obj/map_helper/access_helper/airlock/station/medical/equipment
	req_access = list(
		ACCESS_MEDICAL_EQUIPMENT,
	)

/obj/map_helper/access_helper/airlock/station/service
	icon_state = "service"

/obj/map_helper/access_helper/airlock/station/service/bar
	req_access = list(
		ACCESS_GENERAL_BAR,
	)

/obj/map_helper/access_helper/airlock/station/service/kitchen
	req_access = list(
		ACCESS_GENERAL_KITCHEN,
	)

/obj/map_helper/access_helper/airlock/station/service/library
	req_access = list(
		ACCESS_GENERAL_LIBRARY,
	)

/obj/map_helper/access_helper/airlock/station/service/botany
	req_access = list(
		ACCESS_GENERAL_BOTANY,
	)

/obj/map_helper/access_helper/airlock/station/service/janitor
	req_access = list(
		ACCESS_GENERAL_JANITOR,
	)

/obj/map_helper/access_helper/airlock/station/service/chapel
	req_access = list(
		ACCESS_GENERAL_CHAPEL,
	)

/obj/map_helper/access_helper/airlock/station/service/chapel/cremator
	req_access = list(
		ACCESS_GENERAL_CREMATOR,
	)

/obj/map_helper/access_helper/airlock/station/service/entertainer
	req_one_access = list(
		ACCESS_GENERAL_CLOWN,
		ACCESS_GENERAL_MIME,
		ACCESS_GENERAL_ENTERTAINMENT,
		ACCESS_GENERAL_TOMFOOLERY,
	)

/obj/map_helper/access_helper/airlock/station/supply
	icon_state = "supply"

/obj/map_helper/access_helper/airlock/station/supply/cargo_bay
	req_access = list(
		ACCESS_SUPPLY_BAY,
	)

/obj/map_helper/access_helper/airlock/station/supply/department
	req_access = list(
		ACCESS_SUPPLY_MAIN,
	)

/**
 * for all of onstation mining
 */
/obj/map_helper/access_helper/airlock/station/supply/mining
	req_access = list(
		ACCESS_SUPPLY_MINE,
	)

/**
 * for transit to and doors within offstation areas
 */
/obj/map_helper/access_helper/airlock/station/supply/mining_outpost
	req_access = list(
		ACCESS_SUPPLY_MINE_OUTPOST,
	)

/obj/map_helper/access_helper/airlock/station/science
	icon_state = "science"

/obj/map_helper/access_helper/airlock/station/science/department
	req_access = list(
		ACCESS_SCIENCE_MAIN,
	)

/obj/map_helper/access_helper/airlock/station/science/fabrication
	req_access = list(
		ACCESS_SCIENCE_FABRICATION,
	)

/**
 * so, what toxins is becoming.
 *
 * slated for potential engi-sci cluster.
 */
/obj/map_helper/access_helper/airlock/station/science/material_science
	req_one_access = list(
		ACCESS_SCIENCE_TOXINS,
	)

/**
 * slated for potential med-sci cluster.
 */
/obj/map_helper/access_helper/airlock/station/science/xenobiology
	req_access = list(
		ACCESS_SCIENCE_XENOBIO,
	)

/**
 * slated for potential med-sci cluster.
 */
/obj/map_helper/access_helper/airlock/station/science/xenobotany
	req_access = list(
		ACCESS_SCIENCE_XENOBOTANY,
	)

/obj/map_helper/access_helper/airlock/station/science/xenoarcheology
	req_access = list(
		ACCESS_SCIENCE_XENOARCH,
	)

/**
 * slated for potential med-sci cluster.
 */
/obj/map_helper/access_helper/airlock/station/science/genetics
	req_one_access = list(
		ACCESS_SCIENCE_XENOBOTANY,
		ACCESS_SCIENCE_XENOBIO,
	)

/**
 * slated for potential engi-sci cluster.
 *
 * use for mech lab specifically
 */
/obj/map_helper/access_helper/airlock/station/science/mechatronics
	req_access = list(
		ACCESS_SCIENCE_ROBOTICS,
	)

/**
 * use for unified robotics labs
 * use for prosthetics/augments/robots robotics labs
 */
/obj/map_helper/access_helper/airlock/station/science/robotics
	req_access = list(
		ACCESS_SCIENCE_ROBOTICS,
	)

/obj/map_helper/access_helper/airlock/station/exploration
	icon_state = "science"

/obj/map_helper/access_helper/airlock/station/exploration/explorer
	req_access = list(
		ACCESS_GENERAL_EXPLORER,
	)

/**
 * 'aux' exploration areas like the SAR bay, shuttle bay, etc
 */
/obj/map_helper/access_helper/airlock/station/exploration/auxillery
	req_one_access = list(
		ACCESS_GENERAL_EXPLORER,
	)

/obj/map_helper/access_helper/airlock/station/exploration/shuttle
	req_one_access = list(
		ACCESS_GENERAL_PILOT,
		ACCESS_GENERAL_EXPLORER,
	)

/obj/map_helper/access_helper/airlock/station/command
	icon_state = "command"

/obj/map_helper/access_helper/airlock/station/command/bridge
	req_access = list(
		ACCESS_COMMAND_BRIDGE,
	)

/obj/map_helper/access_helper/airlock/station/command/ai_upload
	req_access = list(
		ACCESS_COMMAND_UPLOAD,
	)

/obj/map_helper/access_helper/airlock/station/command/ai_core
	req_access = list(
		ACCESS_COMMAND_UPLOAD,
	)

/obj/map_helper/access_helper/airlock/station/command/teleporter
	req_access = list(
		ACCESS_COMMAND_TELEPORTER,
	)

/obj/map_helper/access_helper/airlock/station/command/storage
	req_access = list(
		ACCESS_COMMAND_EVA,
	)

/obj/map_helper/access_helper/airlock/station/command/vault
	req_access = list(
		ACCESS_COMMAND_VAULT,
	)

/obj/map_helper/access_helper/airlock/station/centcom
	icon_state = "centcom"

/**
 * special offices are under this
 *
 * for future readers: this doesn't mean that pathfinder/quartermaster/similar are official heads of staff
 *
 * i'm just putting this here as an extra 'fuck you' for whoever tries to argue server politics using code pathing.
 */
/obj/map_helper/access_helper/airlock/station/head_office
	icon_state = "command"

/obj/map_helper/access_helper/airlock/station/head_office/head_of_personnel
	req_access = list(
		ACCESS_COMMAND_HOP,
	)

/obj/map_helper/access_helper/airlock/station/head_office/captain
	req_access = list(
		ACCESS_COMMAND_CAPTAIN,
	)

/obj/map_helper/access_helper/airlock/station/head_office/blueshield
	req_access = list(
		ACCESS_COMMAND_BLUESHIELD,
	)

/obj/map_helper/access_helper/airlock/station/head_office/internal_affairs
	req_access = list(
		ACCESS_COMMAND_IAA,
	)

/obj/map_helper/access_helper/airlock/station/head_office/head_of_security
	req_access = list(
		ACCESS_SECURITY_HOS,
	)

/obj/map_helper/access_helper/airlock/station/head_office/research_director
	req_access = list(
		ACCESS_SCIENCE_RD,
	)

/obj/map_helper/access_helper/airlock/station/head_office/chief_engineer
	req_access = list(
		ACCESS_ENGINEERING_CE,
	)

/obj/map_helper/access_helper/airlock/station/head_office/quartermaster
	req_access = list(
		ACCESS_SUPPLY_QM,
	)

/obj/map_helper/access_helper/airlock/station/head_office/chief_medical_officer
	req_access = list(
		ACCESS_MEDICAL_CMO,
	)

/obj/map_helper/access_helper/airlock/station/head_office/pathfinder
	req_access = list(
		ACCESS_GENERAL_PATHFINDER,
	)

/obj/map_helper/access_helper/airlock/offmap
	icon_state = "offmap"


