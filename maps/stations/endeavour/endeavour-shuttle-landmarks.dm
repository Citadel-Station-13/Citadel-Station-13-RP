/*
Preset landmarks from Endeavour. Still in use for a few maps. At some point need to remap these but
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
	name = "NSV Endeavour - Docking Arm 2"
	landmark_tag = "nav_capitalship_docking2"
	docking_controller = "deck4_dockarm2"
	base_turf = /turf/space
	base_area = /area/space


// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/endeavour/deck4/specops
	name = "NSV Endeavour - Special Operations Dock"
	landmark_tag = "endeavour_specops_dock"
	docking_controller = "endeavour_specops_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck2/trade
	name = "NSV Endeavour Annex Dock"
	landmark_tag = "endeavour_annex_dock"
	docking_controller = "endeavour_annex_dock"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/endeavour/deck4/excursion
	name = "NSV Endeavour - Excursion Hangar"
	landmark_tag = "endeavour_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/excursion_dock

/obj/effect/shuttle_landmark/endeavour/deck4/courser
	name = "NSV Endeavour - Courser Hangar"
	landmark_tag = "endeavour_courser_hangar"
	docking_controller = "courser_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/courser_dock

/obj/effect/shuttle_landmark/endeavour/deck3/emt
	name = "NSV Endeavour - EMT Shuttle Dock"
	landmark_tag = "endeavour_emt_dock"
	docking_controller = "emt_shuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/hallway/station/docks

/obj/effect/shuttle_landmark/endeavour/deck2/mining
	name = "NSV Endeavour Mining Dock"
	landmark_tag = "endeavour_mining_port"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/quartermaster/miningdock

/obj/effect/shuttle_landmark/endeavour/deck4/civvie
	name = "NSV Endeavour - Civilian Transport Dock"
	landmark_tag = "endeavour_civvie_home"
	docking_controller = "civvie_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/hallway/secondary/docking_hallway

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/endeavour/deck4/excursion_space
	name = "Near NSV Endeavour (SW)"
	landmark_tag = "endeavour_space_SW"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck3/port
	name = "Near NSV Endeavour (Port Deck 3)"
	landmark_tag = "endeavour_space_port_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck3/starboard
	name = "Near NSV Endeavour (Starboard Deck 3)"
	landmark_tag = "endeavour_space_starboard_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck2/port
	name = "Near NSV Endeavour (Port Deck 2)"
	landmark_tag = "endeavour_space_port_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck2/starboard
	name = "Near NSV Endeavour (Starboard Deck 2)"
	landmark_tag = "endeavour_space_starboard_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck1/port
	name = "Near NSV Endeavour (Port Deck 1)"
	landmark_tag = "endeavour_space_port_1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/endeavour/deck1/starboard
	name = "Near NSV Endeavour (Starboard Deck 1)"
	landmark_tag = "endeavour_space_starboard_1"
	base_turf = /turf/space
	base_area = /area/space

// OFF-STATION NAV POINTS


// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/endeavour/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/endeavour/courser
	name = "In transit"
	landmark_tag = "nav_transit_courser"

/obj/effect/shuttle_landmark/transit/endeavour/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/endeavour/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/endeavour/mining
	name = "In transit"
	landmark_tag = "nav_transit_mining"

/obj/effect/shuttle_landmark/transit/endeavour/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/endeavour/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"
