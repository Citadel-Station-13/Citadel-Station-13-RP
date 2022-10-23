/*
** Landmark Defs
 */

// Shared landmark for docking at the station

/obj/effect/shuttle_landmark/automatic/station_dockpoint1
	name = "Station Docking Point 1"
	landmark_tag = "nav_station_docking1"
	docking_controller = "deck4_dockarm1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/automatic/station_dockpoint2
	name = "NSV Triumph - Docking Arm 2"
	landmark_tag = "nav_capitalship_docking2"
	docking_controller = "deck4_dockarm2"
	base_turf = /turf/space
	base_area = /area/space


// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/triumph/deck4/civvie
	name = "NSV Triumph - Civilian Transport Dock"
	landmark_tag = "triumph_civvie_home"
	docking_controller = "civvie_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/emt
	name = "NSV Triumph - EMT Shuttle Dock"
	landmark_tag = "triumph_emt_dock"
	docking_controller = "emt_shuttle_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/mining
	name = "NSV Triumph Mining Dock"
	landmark_tag = "triumph_mining_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/trade
	name = "NSV Triumph Annex Dock"
	landmark_tag = "triumph_annex_dock"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/triumph/deck4/excursion
	name = "NSV Triumph - Excursion Hanger"
	landmark_tag = "triumph_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/excursion_dock

/obj/effect/shuttle_landmark/triumph/deck4/courser
	name = "NSV Triumph - Courser Hanger"
	landmark_tag = "triumph_courser_hangar"
	docking_controller = "courser_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/courser_dock

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/triumph/deck4/excursion_space
	name = "Near NSV Triumph (SW)"
	landmark_tag = "triumph_space_SW"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/port
	name = "Near NSV Triumph (Port Deck 3)"
	landmark_tag = "triumph_space_port_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/starboard
	name = "Near NSV Triumph (Starboard Deck 3)"
	landmark_tag = "triumph_space_starboard_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/port
	name = "Near NSV Triumph (Port Deck 2)"
	landmark_tag = "triumph_space_port_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/starboard
	name = "Near NSV Triumph (Starboard Deck 2)"
	landmark_tag = "triumph_space_starboard_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck1/port
	name = "Near NSV Triumph (Port Deck 1)"
	landmark_tag = "triumph_space_port_1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck1/starboard
	name = "Near NSV Triumph (Starboard Deck 1)"
	landmark_tag = "triumph_space_starboard_1"
	base_turf = /turf/space
	base_area = /area/space

// OFF-STATION NAV POINTS


// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/triumph/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/triumph/courser
	name = "In transit"
	landmark_tag = "nav_transit_courser"

/obj/effect/shuttle_landmark/transit/triumph/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/triumph/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/triumph/mining
	name = "In transit"
	landmark_tag = "nav_transit_mining"

/obj/effect/shuttle_landmark/transit/triumph/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/triumph/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"
