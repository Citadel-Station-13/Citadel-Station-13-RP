
// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/rift/deck3/excursion
	name = "NSB Atlas - Exploration Shuttle Pad"

/obj/effect/shuttle_landmark/rift/deck3/civvie
	name = "NSB Atlas - Civilian Transport Pad"

/obj/effect/shuttle_landmark/rift/deck3/oldcentury
	name = "NSB Atlas - Secondary Civilian Transport Pad"
	landmark_tag = "rift_oldcentury_pad"
	docking_controller = "oldcentury_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/emt
	name = "NSB Atlas - EMT Shuttle Pad"

/obj/effect/shuttle_landmark/rift/deck3/trade
	name = "NSB Atlas - Trade Pad"

/obj/effect/shuttle_landmark/rift/deck3/scoophead
	name = "NSB Atlas - Scoophead Pad"
	landmark_tag = "rift_scoophead_dock"

/obj/effect/shuttle_landmark/rift/deck3/udang
	name = "NSB Atlas - Udang Pad"
	landmark_tag = "rift_udang_dock"

/obj/effect/shuttle_landmark/rift/deck3/specops
	name = "NSB Atlas - Special Operations Pad"

/obj/effect/shuttle_landmark/rift/deck3/pirate
	name = "NSB Atlas - Pirate Landing Pad"

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/rift/deck3/courser
	name = "NSB Atlas - Courser Hangar"

/obj/effect/shuttle_landmark/rift/deck2/hammerhead
	name = "NSB Atlas - Hammerhead Hangar"

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/deck4/excursion_sky
	name = "NSB Atlas Airspace (SE)"

/obj/effect/shuttle_landmark/rift/deck4/east
	name = "NSB Atlas Airspace (E)"

/obj/effect/shuttle_landmark/rift/deck4/northeast
	name = "NSB Atlas Airspace (NE)"

/obj/effect/shuttle_landmark/rift/deck4/north
	name = "SB Atlas Airspace (N)"
	landmark_tag = "rift_airspace_N"

// OFF-STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/away/plains
	name = "NSB Atlas Western Plains"
	landmark_tag = "rift_plains"

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

// Hammerhead Patrol Barge

// Public Civilian Shuttle


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
