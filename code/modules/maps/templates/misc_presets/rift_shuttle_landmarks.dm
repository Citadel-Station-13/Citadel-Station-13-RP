/*
Need to turn all of these into proper initializers like this:

/obj/effect/shuttle_landmark/shuttle_initializer/pirate
	name = "Pirate Skiff Dock"
	landmark_tag = "pirate_docking_arm"
	base_turf = /turf/space
	base_area = /area/space
	shuttle_type = /datum/shuttle/autodock/overmap/pirate
*/

// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/rift/deck3/excursion
	name = "NSB Atlas - Exploration Shuttle Pad"
	landmark_tag = "rift_excursion_pad"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/civvie
	name = "NSB Atlas - Civilian Transport Pad"
	landmark_tag = "rift_civvie_pad"
	docking_controller = "civvie_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/emt
	name = "NSB Atlas - EMT Shuttle Pad"
	landmark_tag = "rift_emt_pad"
	docking_controller = "emt_shuttle_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/trade
	name = "NSB Atlas - Trade Pad"
	landmark_tag = "rift_trade_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/specops
	name = "NSB Atlas - Special Operations Pad"
	landmark_tag = "rift_specops_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/pirate
	name = "NSB Atlas - Pirate Landing Pad"
	landmark_tag = "rift_pirate_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/rift/deck3/courser
	name = "NSB Atlas - Courser Hanger"
	landmark_tag = "rift_courser_hangar"
	docking_controller = "courser_docker"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/courser_dock

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/deck4/excursion_sky
	name = "NSB Atlas Airspace (SE)"
	landmark_tag = "rift_airspace_SE"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/east
	name = "NSB Atlas Airspace (E)"
	landmark_tag = "rift_airspace_E"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/northeast
	name = "NSB Atlas Airspace (NE)"
	landmark_tag = "rift_airspace_NE"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/north
	name = "SB Atlas Airspace (N)"
	landmark_tag = "rift_airspace_N"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

// OFF-STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/away/plains
	name = "NSB Atlas Western Plains"
	landmark_tag = "rift_plains"
	base_turf = /turf/simulated/floor/outdoors/snow/lythios43c
	base_area = /area/rift/surfacebase/outside/west

// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/rift/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/rift/courser
	name = "In transit"
	landmark_tag = "nav_transit_courser"

/obj/effect/shuttle_landmark/transit/rift/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/rift/specops
	name = "In transit"
	landmark_tag = "nav_transit_specops"

/obj/effect/shuttle_landmark/transit/rift/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/rift/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/rift/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"
