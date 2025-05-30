
/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(ACCESS_FACTION_SYNDICATE)


/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(ACCESS_FACTION_TRADER)

//
// "Tram" Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
//	Supply Shuttle roofing for the planetmap

/datum/shuttle/autodock/ferry/supply
	ceiling_type = /turf/simulated/floor/plasteel/lythios43c

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////

// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion/rift
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "rift_excursion_pad"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	fuel_consumption = 3
	move_direction = WEST

/obj/overmap/entity/visitable/ship/landable/excursion/rift
	name = "Excursion Shuttle"
	desc = "The Mk2 Excursion Shuttle. NT Approved!"
	color = "#72388d" //Purple
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

// COURSER SHUTTLE DATA

/datum/shuttle/autodock/overmap/courser
	name = "Courser Scouting Vessel"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/courser/cockpit, /area/shuttle/courser/general, /area/shuttle/courser/battery)
	current_location = "rift_courser_hangar"
	docking_controller_tag = "courser_docker"
	landmark_transition = "nav_transit_courser"
	move_time = 15

/obj/overmap/entity/visitable/ship/landable/courser
	name = "Courser Scouting Vessel"
	desc = "Where there's a cannon, there's a way."
	color = "#af3e97" //Pinkish Purple
	fore_dir = EAST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Courser Scouting Vessel"

/area/shuttle/courser
	name = "Courser Scouting Vessel"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/courser
	name = "short jump console"
	shuttle_tag = "Courser Scouting Vessel"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

// Hammerhead Patrol Barge

/datum/shuttle/autodock/overmap/hammerhead
	name = "Hammerhead Patrol Barge"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/hammerhead/cockpit, /area/shuttle/hammerhead/general)
	current_location = "rift_hammerhead_hangar"
	docking_controller_tag = "hammerhead_docker"
	landmark_transition = "nav_transit_hammerhead"
	move_time = 15
	fuel_consumption = 5
	move_direction = WEST

/obj/overmap/entity/visitable/ship/landable/hammerhead
	name = "Hammerhead Patrol Barge"
	desc = "To Detain and Enforce."
	color = "#b91a14" //Vibrant Red
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Hammerhead Patrol Barge"

/area/shuttle/hammerhead
	name = "Hammerhead Patrol Barge"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/hammerhead
	name = "short jump console"
	shuttle_tag = "Hammerhead Patrol Barge"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

// Public Civilian Shuttle

/datum/shuttle/autodock/overmap/civvie
	name = "Civilian Transport"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/civvie/cockpit, /area/shuttle/civvie/general)
	current_location = "rift_civvie_pad"
	docking_controller_tag = "civvie_docker"
	landmark_transition = "nav_transit_civvie"
	fuel_consumption = 10
	move_time = 30

/obj/overmap/entity/visitable/ship/landable/civvie
	name = "Civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = NORTH
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Transport"

/area/shuttle/civvie
	name = "Civilian Transport"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/civvie
	name = "civilian jump console"
	shuttle_tag = "Civilian Transport"

// Civilian Century Shuttle

/datum/shuttle/autodock/overmap/oldcentury
	name = "Civilian Century Shuttle"
	warmup_time = 15
	shuttle_area = /area/shuttle/oldcentury
	current_location = "rift_oldcentury_pad"
	docking_controller_tag = "oldcentury_docker"
	landmark_transition = "nav_transit_oldcentury"
	fuel_consumption = 8
	move_time = 37

/obj/overmap/entity/visitable/ship/landable/oldcentury
	name = "Civilian Century Shuttle"
	desc = "Is it... A replica ? Or... the real deal ? This shuttle, based on the shuttles from earth's old days. No teasing, this shuttle is a replica, but still a old and crapy ship."
	fore_dir = NORTH
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Century Shuttle"
	color = "#4cad73" //Greyish green

/area/shuttle/oldcentury
	name = "Civilian Century Shuttle"
	icon_state = "shuttle"
	requires_power = 1
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

/obj/machinery/computer/shuttle_control/explore/oldcentury
	name = "Century jump console"
	shuttle_tag = "Civilian Century Shuttle"

//EMT Shuttle
/datum/shuttle/autodock/overmap/emt
	name = "Dart EMT Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/emt/general, /area/shuttle/emt/cockpit)
	current_location = "rift_emt_pad"
	docking_controller_tag = "emt_shuttle_docker"
	landmark_transition = "nav_transit_emt"
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/emt
	name = "Dart EMT Shuttle"
	desc = "The budget didn't allow for flashing lights."
	color = "#69b9de" //Light Blue
	fore_dir = NORTH
	vessel_mass = 9000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Dart EMT Shuttle"

/area/shuttle/emt
	name = "Dart EMT Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/emt
	name = "EMT jump console"
	shuttle_tag = "Dart EMT Shuttle"

//? merged


// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_rift"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
