/*
Need to turn all of these into proper initializers like this:

/obj/effect/shuttle_landmark/shuttle_initializer/pirate
	name = "Pirate Skiff Dock"
	shuttle_type = /datum/shuttle/autodock/overmap/pirate
*/

// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/rift/deck3/excursion
	name = "NSB Atlas - Exploration Shuttle Pad"

/obj/effect/shuttle_landmark/rift/deck3/civvie
	name = "NSB Atlas - Civilian Transport Pad"

/obj/effect/shuttle_landmark/rift/deck3/oldcentury
	name = "NSB Atlas - Secondary Civilian Transport Pad"
	landmark_tag = "rift_oldcentury_pad"
	docking_controller = "rift_oldcentury_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/emt
	name = "NSB Atlas - EMT Shuttle Pad"

/obj/effect/shuttle_landmark/rift/deck3/trade
	name = "NSB Atlas - Trade Pad"

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

// OFF-STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/away/plains
	name = "NSB Atlas Western Plains"
