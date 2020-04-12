//Normal map defs
#define Z_LEVEL_ENDEAVOR_ONE			1
#define Z_LEVEL_ENDEAVOR_TWO			2
#define Z_LEVEL_ENDEAVOR_THREE			3
#define Z_LEVEL_ENDEAVOR_FOUR			4
#define Z_LEVEL_ENDEAVOR_FIVE			5
#define Z_LEVEL_CENTCOM					6
#define Z_LEVEL_MINING_LOW				7
#define Z_LEVEL_MINING_HIGH				8
#define Z_LEVEL_SHIPS					9
#define Z_LEVEL_MISC					10
#define Z_LEVEL_ODIN5A_BEACH			11
#define Z_LEVEL_ODIN5A_CAVE				12


#define Z_LEVEL_BOTTOM_DECK				Z_LEVEL_ENDEAVOR_ONE
#define Z_LEVEL_TOP_DECK				Z_LEVEL_ENDEAVOR_FIVE

/datum/map/endeavor
	name = "Endeavor"
	full_name = "SEV Endeavor"
	path = "endeavor"

	zlevel_datum_type = /datum/map_z_level/endeavor

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'
	station_name  = "SEV Endeavor"
	station_short = "Endeavor"
	dock_name     = "SEV Phoenix"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Odin"

	shuttle_docked_message = "The automated crew transfer ferry has docked at the SEV Endeavor. It will depart for the %dock_name% in approximately %ETD%."
	shuttle_leaving_dock = "The automated crew transfer ferry has left the SEV Endeavor. Estimate %ETA% until the tram arrives at the %dock_name%."
	shuttle_called_message = "An automated crew transfer ferry is en route to the SEV Endeavor. It will arrive in approximately %ETA%"
	shuttle_recall_message = "The automated crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency ferry has arrived at the SEV Endeavor's dock on deck 4. You have approximately %ETD% to board the ferry."
	emergency_shuttle_leaving_dock = "The emergency ferry has left the SEV Endeavor. Estimate %ETA% until the ferry arrives at the %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule ferry has been called from the %dock_name%. It will arrive at the evacuation dock on deck 4 in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency ferry has been recalled."

/*
	shuttle_docked_message = "The scheduled Orange Line tram to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Orange Line tram has left the station. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the Orange Line tram station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation tram has arrived at the tram station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule tram has been called. It will arrive at the tram station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation tram has been recalled."
*/
	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/arrivals
	spawnpoint_left = /datum/spawnpoint/arrivals
	spawnpoint_stayed = /datum/spawnpoint/cryo

	lateload_z_levels = list(
		list("Endeavor - Misc","Endeavor - Ships") //Stock Tether lateload maps
		)

/datum/map/endeavor/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 9, 9, Z_LEVEL_MINING_HIGH, 192, 192) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 9, 9, Z_LEVEL_MINING_HIGH, 192, 192)         // Create the mining ore distribution map.


//	seed_submaps(list(Z_LEVEL_MINING_LOW), 300, /area/mine/unexplored/low, /datum/map_template) //We don't have any templates to spawn yet
	new /datum/random_map/automata/cave_system/no_cracks(null, 9, 9, Z_LEVEL_MINING_LOW, 192, 192) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 9, 9, Z_LEVEL_MINING_LOW, 192, 192)         // Create the mining ore distribution map.

	return 1

// Short range computers see only the main levels
/datum/map/endeavor/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz >= Z_LEVEL_BOTTOM_DECK && srcz <= Z_LEVEL_TOP_DECK)
		return list(
			Z_LEVEL_ENDEAVOR_ONE,
			Z_LEVEL_ENDEAVOR_TWO,
			Z_LEVEL_ENDEAVOR_THREE,
			Z_LEVEL_ENDEAVOR_FOUR,
			Z_LEVEL_ENDEAVOR_FIVE)
	else
		return ..()

// We have a bunch of stuff common to the ship z levels
/datum/map_z_level/endeavor/ship
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES

/datum/map_z_level/endeavor/ship/one
	z = Z_LEVEL_ENDEAVOR_ONE
	name = "Endeavor Deck 1"
	base_turf = /turf/space
	transit_chance = 20

/datum/map_z_level/endeavor/ship/two
	z = Z_LEVEL_ENDEAVOR_TWO
	name = "Endeavor Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 20

/datum/map_z_level/endeavor/ship/three
	z = Z_LEVEL_ENDEAVOR_THREE
	name = "Endeavor Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 20

/datum/map_z_level/endeavor/ship/four
	z = Z_LEVEL_ENDEAVOR_FOUR
	name = "Endeavor Deck 4"
	base_turf = /turf/simulated/open
	transit_chance = 20

/datum/map_z_level/endeavor/ship/five
	z = Z_LEVEL_ENDEAVOR_FIVE
	name = "Endeavor Deck 5"
	base_turf = /turf/simulated/open
	transit_chance = 20

/datum/map_z_level/endeavor/central_command
	z = Z_LEVEL_CENTCOM
	name = "Central Command"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_SEALED
	base_turf = /turf/space


/datum/map_z_level/endeavor/mining
	name = "Asteroid"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 0

/datum/map_z_level/endeavor/mining/low
	name = "Asteroid Interior"
	z = Z_LEVEL_MINING_LOW
	base_turf = /turf/simulated/mineral/floor/vacuum
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED //Radios can't breach that much rock

/datum/map_z_level/endeavor/mining/high
	name = "Asteroid Surface"
	z = Z_LEVEL_MINING_HIGH
	base_turf = /turf/simulated/mineral/floor/vacuum
