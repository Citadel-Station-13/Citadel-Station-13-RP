DECLARE_SECTOR_SHUTTLE_TEMPLATE(/mercship_1, /transit_boat)
	id = "mercship_1-transit_boat"

#warn impl

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/mercenaryship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/mercenary/engineering, /area/ship/mercenary/engineeringcntrl, /area/ship/mercenary/bridge, /area/ship/mercenary/atmos, /area/ship/mercenary/air, /area/ship/mercenary/engine, /area/ship/mercenary/engine1, /area/ship/mercenary/armoury, /area/ship/mercenary/hangar, /area/ship/mercenary/barracks, /area/ship/mercenary/fighter, /area/ship/mercenary/med, /area/ship/mercenary/med1, /area/ship/mercenary/hall1, /area/ship/mercenary/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/overmap/entity/visitable/ship/mercship
	name = "Unknown Vessel"
	desc = "Spacefaring vessel. No IFF detected."
	scanner_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: UNKNOWN
[i]Transponder[/i]: None Detected
[b]Notice[/b]: Unregistered vessel"}
	color = "#f23000" //Red
	vessel_mass = 8000
	initial_generic_waypoints = list("carrier_fore", "carrier_aft", "carrier_port", "carrier_starboard", "base_dock")
	initial_restricted_waypoints = list("Carrier's Ship's Boat" = list("omship_spawn_mercboat"))


//The boat's area
/area/shuttle/mercboat
	name = "\improper Carrier's Ship's Boat"
	icon_state = "shuttle"
	requires_power = 0

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mercboat
	name = "Carrier's Boat Bay"
	shuttle_type = /datum/shuttle/autodock/overmap/mercboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/mercboat
	name = "Carrier's Ship's Boat"
	current_location = "omship_spawn_mercboat"
	docking_controller_tag = "mercboat_docker"
	shuttle_area = /area/shuttle/mercboat
	fuel_consumption = 0
	defer_initialisation = TRUE
