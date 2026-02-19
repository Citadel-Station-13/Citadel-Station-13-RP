// EXCURSION SHUTTLE DATA

/datum/shuttle/autodock/overmap/excursion/endeavour
	name = "Excursion Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/excursion/endeavour/cockpit, /area/shuttle/excursion/endeavour/general, /area/shuttle/excursion/endeavour/cargo)
	current_location = "endeavour_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	landmark_transition = "nav_transit_exploration"
	move_time = 20

/area/shuttle/excursion/endeavour
	name = "Endeavour Excursion Shuttle"
	icon_state = "shuttle"

// COURSER SHUTTLE DATA

/datum/shuttle/autodock/overmap/courser/endeavour
	name = "Courser Scouting Vessel"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/courser/cockpit, /area/shuttle/courser/general, /area/shuttle/courser/battery)
	//shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	current_location = "endeavour_courser_hangar"
	docking_controller_tag = "courser_docker"
	landmark_transition = "nav_transit_courser"
	move_time = 15

/area/shuttle/courser
	name = "Courser Scouting Vessel"
	icon_state = "shuttle"

// Public Civilian Shuttle

/datum/shuttle/autodock/overmap/civvie/endeavour
	name = "Civilian Transport"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/civvie/cockpit, /area/shuttle/civvie/general)
	current_location = "endeavour_civvie_home"
	docking_controller_tag = "civvie_docker"
	landmark_transition = "nav_transit_civvie"
	fuel_consumption = 10
	move_time = 30

/area/shuttle/civvie
	name = "Civilian Transport"
	icon_state = "shuttle"


// Mining Shuttle

/datum/shuttle/autodock/overmap/mining/endeavour
	name = "Mining Shuttle"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/mining_ship/general)
	current_location = "endeavour_mining_port"
	docking_controller_tag = "mining_docker"
	landmark_transition = "nav_transit_mining"
	move_time = 30

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "shuttle"

//EMT Shuttle
/datum/shuttle/autodock/overmap/emt/endeavour
	name = "Dart EMT Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/emt/general, /area/shuttle/emt/cockpit)
	current_location = "endeavour_emt_dock"
	docking_controller_tag = "emt_shuttle_docker"
	landmark_transition = "nav_transit_emt"
	move_time = 20

/area/shuttle/emt
	name = "Dart EMT Shuttle"
	icon_state = "shuttle"


//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape/endeavour
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_endeavour"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo/endeavour
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
