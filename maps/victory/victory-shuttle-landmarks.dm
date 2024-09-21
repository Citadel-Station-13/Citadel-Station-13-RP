/*
Preset landmarks from Victory. Still in use for a few maps. At some point need to remap these but
right now its not a big priority - Bloop 2022

 */

// Shared landmark for docking at the station

/obj/effect/shuttle_landmark/automatic/station_dockpoint1
	name = "Station Docking Point 1"
	landmark_tag = "nav_station_docking1"
	docking_controller = "deck4_dockarm1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/automatic/station_dockpoint2
	name = "NSV Victory - Docking Arm 2"
	landmark_tag = "nav_capitalship_docking2"
	docking_controller = "deck4_dockarm2"
	base_turf = /turf/space
	base_area = /area/space


// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/victory/deck4/civvie
	name = "NSV Victory - Civilian Transport Dock"
	landmark_tag = "victory_civvie_home"
	docking_controller = "civvie_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck4/specops
	name = "NSV Victory - Special Operations Dock"
	landmark_tag = "victory_specops_dock"
	docking_controller = "victory_specops_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck3/emt
	name = "NSV Victory - EMT Shuttle Dock"
	landmark_tag = "victory_emt_dock"
	docking_controller = "emt_shuttle_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck2/mining
	name = "NSV Victory Mining Dock"
	landmark_tag = "victory_mining_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck2/trade
	name = "NSV Victory Annex Dock"
	landmark_tag = "victory_annex_dock"
	docking_controller = "victory_annex_dock"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/victory/deck4/excursion
	name = "NSV Victory - Excursion Hangar"
	landmark_tag = "victory_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/excursion_dock

/obj/effect/shuttle_landmark/victory/deck4/courser
	name = "NSV Victory - Courser Hangar"
	landmark_tag = "victory_courser_hangar"
	docking_controller = "courser_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/courser_dock

/obj/effect/shuttle_landmark/victory/deck4/hammerhead
	name = "NSV Victory - Hammerhead Hangar"
	landmark_tag = "rift_hammerhead_hangar"
	docking_controller = "hammerhead_docker"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/security/hammerhead_bay

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/victory/deck4/excursion_space
	name = "Near NSV Victory (SW)"
	landmark_tag = "victory_space_SW"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck3/port
	name = "Near NSV Victory (Port Deck 3)"
	landmark_tag = "victory_space_port_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck3/starboard
	name = "Near NSV Victory (Starboard Deck 3)"
	landmark_tag = "victory_space_starboard_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck2/port
	name = "Near NSV Victory (Port Deck 2)"
	landmark_tag = "victory_space_port_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck2/starboard
	name = "Near NSV Victory (Starboard Deck 2)"
	landmark_tag = "victory_space_starboard_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck1/port
	name = "Near NSV Victory (Port Deck 1)"
	landmark_tag = "victory_space_port_1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/victory/deck1/starboard
	name = "Near NSV Victory (Starboard Deck 1)"
	landmark_tag = "victory_space_starboard_1"
	base_turf = /turf/space
	base_area = /area/space

// OFF-STATION NAV POINTS


// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/victory/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/victory/courser
	name = "In transit"
	landmark_tag = "nav_transit_courser"

/obj/effect/shuttle_landmark/transit/victory/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/victory/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/victory/mining
	name = "In transit"
	landmark_tag = "nav_transit_mining"

/obj/effect/shuttle_landmark/transit/victory/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/victory/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"
