// Normal map defs
// Z1 is dynamic transit.
#define Z_LEVEL_DECK_ONE				2
#define Z_LEVEL_DECK_TWO				3
#define Z_LEVEL_DECK_THREE				4
#define Z_LEVEL_DECK_FOUR				5
#define Z_LEVEL_MISC					6
#define Z_LEVEL_CENTCOM					7
/*
#define Z_LEVEL_SHIPS					8

#define Z_LEVEL_DEBRISFIELD				9
#define Z_LEVEL_PIRATEBASE				10
#define Z_LEVEL_MININGPLANET			11
#define Z_LEVEL_UNKNOWN_PLANET			12
#define Z_LEVEL_DESERT_PLANET			13
#define Z_LEVEL_GAIA_PLANET				14
#define Z_LEVEL_FROZEN_PLANET			15

#define Z_LEVEL_ROGUEMINE_1				16
#define Z_LEVEL_ROGUEMINE_2				17
#define Z_LEVEL_ROGUEMINE_3				18
#define Z_LEVEL_ROGUEMINE_4				19

#define Z_LEVEL_TRADEPORT				20
#define Z_LEVEL_LAVALAND				21
#define Z_LEVEL_LAVALAND_EAST			22
*/

// Camera Networks
/datum/map/station/euthenia
	name = "Euthenia"
	full_name = "NSV Euthenia"
	path = "euthenia"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 60
	overmap_event_areas = 50
	// usable_email_tlds = list("triumph.nt")

	zlevel_datum_type = /datum/map_level/euthenia

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("title1", "title2", "title3", "title4", "title5", "title6", "title7", "title8", "title9")

	admin_levels = list()
	sealed_levels = list()
	empty_levels = null
	station_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)
	contact_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)
	player_levels = list(Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR)

	holomap_smoosh = list(list(
		Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR))

	station_name	= "NSV Euthenia"
	station_short	= "Euthenia"
	dock_name		= "NDV Marksman"
	dock_type		= "space"
	boss_name		= "Central Command"
	boss_short		= "CentCom"
	company_name	= "NanoTrasen"
	company_short	= "NT"
	starsys_name	= "Sigmar Concord"

	shuttle_docked_message = "This is the %dock_name% calling to the NSV Euthenia. The scheduled crew transfer shuttle has docked with the NSV Euthenia. Departing crew should board the shuttle within %ETD%."
	shuttle_leaving_dock = "The transfer shuttle has left the ship. Estimate %ETA% until the shuttle arrives at the %dock_name%."
	shuttle_called_message = "This is the %dock_name% calling to the NSV Euthenia. A scheduled crew transfer to the %dock_name% is commencing. Those departing should proceed to the shuttle bay within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Crew Hands Transfer"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived at the ship. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at the hanger bay in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation shuttle has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							//NETWORK_DEFAULT,  //Is this even used for anything? Robots show up here, but they show up in ROBOTS network too,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_OUTSIDE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TCOMMS
//							NETWORK_TRIUMPH
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TRADE_STATION
							)

	bot_patrolling = TRUE

	allowed_spawns = list("Shuttle Bay","Gateway","Cryogenic Storage","Cyborg Storage","Beruang Trading Corp Cryo")
	spawnpoint_died = /datum/spawnpoint/shuttle
	spawnpoint_left = /datum/spawnpoint/shuttle
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = null

	unit_test_exempt_areas = list(
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/solar/)
	unit_test_exempt_from_atmos = list(
		/area/engineering/atmos/intake,
		/area/tcommsat/chamber,
		/area/engineering/engineering_airlock,
		/area/solar/)
/*
	belter_docked_z = 		list(Z_LEVEL_DECK_TWO)
	belter_transit_z =	 	list(Z_LEVEL_SHIPS)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2,
						 	 	 Z_LEVEL_ROGUEMINE_3,
								 Z_LEVEL_ROGUEMINE_4)

	lavaland_levels =		list(Z_LEVEL_LAVALAND,
								 Z_LEVEL_LAVALAND_EAST)

	lateload_z_levels = list(
		list("Triumph - Misc","Triumph - Ships",), // Stock Triumph lateload maps
		list("Debris Field - Z1 Space"), // Debris Field
		list("Away Mission - Pirate Base"), // Vox Pirate Base & Mining Planet
		list("ExoPlanet - Z1 Planet"),//Mining planet
		list("ExoPlanet - Z2 Planet"), // Rogue Exoplanet
		list("ExoPlanet - Z3 Planet"), // Desert Exoplanet
		list("ExoPlanet - Z4 Planet"), // Gaia Planet
		list("ExoPlanet - Z5 Planet"), // Frozen Planet
		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4"),
		list("Away Mission - Trade Port"), // Trading Post
		list("Away Mission - Lava Land", "Away Mission - Lava Land (East)")
	)
*/
	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_DECK_ONE,
		Z_LEVEL_DECK_TWO,
		Z_LEVEL_DECK_THREE,
		Z_LEVEL_DECK_FOUR
		/*
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_PIRATEBASE,
		Z_LEVEL_MININGPLANET,
		Z_LEVEL_UNKNOWN_PLANET,
		Z_LEVEL_DESERT_PLANET,
		Z_LEVEL_GAIA_PLANET,
		Z_LEVEL_FROZEN_PLANET,
		Z_LEVEL_TRADEPORT,
		Z_LEVEL_LAVALAND,
		Z_LEVEL_LAVALAND_EAST
		*/
		)

	lateload_single_pick = null //Nothing right now.
/*
	planet_datums_to_make = list(/datum/planet/lavaland,
								/datum/planet/classg,
								/datum/planet/classd,
								/datum/planet/classh,
								/datum/planet/classp,
								/datum/planet/classm)
*/
/datum/map/station/euthenia/perform_map_generation()
	return 1
/*
// For making the 4-in-1 holomap, we calculate some offsets
/// Width and height of compiled in triumph z levels.
#define TRIUMPH_MAP_SIZE 140
/// 40px central gutter between columns
#define TRIUMPH_HOLOMAP_CENTER_GUTTER 40
/// 100
#define TRIUMPH_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TRIUMPH_MAP_SIZE) - TRIUMPH_HOLOMAP_CENTER_GUTTER) / 2)
/// 60
#define TRIUMPH_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (3*TRIUMPH_MAP_SIZE)) / 2)
*/
// We have a bunch of stuff common to the station z levels
/datum/map_level/triumph/ship
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_level/triumph/ship/deck_one
	z = Z_LEVEL_DECK_ONE
	name = "Deck 1"
	transit_chance = 33
	base_turf = /turf/space
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_offset_x = TRIUMPH_HOLOMAP_MARGIN_X
	holomap_offset_y = TRIUMPH_HOLOMAP_MARGIN_Y + TRIUMPH_MAP_SIZE*1

/datum/map_level/triumph/ship/deck_two
	z = Z_LEVEL_DECK_TWO
	name = "Deck 2"
	transit_chance = 33
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_offset_x = TRIUMPH_HOLOMAP_MARGIN_X
	holomap_offset_y = TRIUMPH_HOLOMAP_MARGIN_Y + TRIUMPH_MAP_SIZE*2

/datum/map_level/triumph/ship/deck_three
	z = Z_LEVEL_DECK_THREE
	name = "Deck 3"
	transit_chance = 33
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_offset_x = HOLOMAP_ICON_SIZE - TRIUMPH_HOLOMAP_MARGIN_X - TRIUMPH_MAP_SIZE
	holomap_offset_y = TRIUMPH_HOLOMAP_MARGIN_Y + TRIUMPH_MAP_SIZE*1

/datum/map_level/triumph/ship/deck_four
	z = Z_LEVEL_DECK_FOUR
	name = "Deck 4"
	transit_chance = 33
	base_turf = /turf/simulated/open
	flags = LEGACY_LEVEL_STATION|LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER|LEGACY_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT
	holomap_offset_x = HOLOMAP_ICON_SIZE - TRIUMPH_HOLOMAP_MARGIN_X - TRIUMPH_MAP_SIZE
	holomap_offset_y = TRIUMPH_HOLOMAP_MARGIN_Y + TRIUMPH_MAP_SIZE*2

/datum/map_level/triumph/colony
	z = Z_LEVEL_CENTCOM
	name = "Flagship"
	flags = LEGACY_LEVEL_ADMIN|LEGACY_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/triumph/ships
	z = Z_LEVEL_SHIPS
	name = "Misc"
	flags = LEGACY_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_level/triumph/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = LEGACY_LEVEL_ADMIN|MAP_LEVEL_XENOARCH_EXEMPT

// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)


/// Z level dropper. Todo, make something generic so we dont have to copy pasta this
/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize(mapload)
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	if(isobserver(A) || A.anchored)
		return
	if(A.throwing)
		return
	if(!A.can_fall())
		return
	if(isliving(A))
		var/mob/living/L = A
		if(L.is_floating || L.flying)
			return //Flyers/nograv can ignore it

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.
