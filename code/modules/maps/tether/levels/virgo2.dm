/datum/atmosphere/planet/virgo2
	base_gases = list(
	/datum/gas/nitrogen = 0.10,
	/datum/gas/oxygen = 0.03,
	/datum/gas/carbon_dioxide = 0.87
	)
	base_target_pressure = 312.1
	minimum_pressure = 312.1
	maximum_pressure = 312.1
	minimum_temp = 612
	maximum_temp = 612

// Turfmakers
#define VIRGO2_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO2
#define VIRGO2_TURF_CREATE(x)	x/virgo2/initial_gas_mix=ATMOSPHERE_ID_VIRGO2;x/virgo2/color="#eacd7c"

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)
VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)


/obj/effect/overmap/visitable/sector/virgo2
	name = "Virgo 2"
	desc = "Includes the Remmi Aerostat and associated ground mining complexes."
	scanner_desc = @{"[i]Stellar Body[/i]: Virgo 2
[i]Class[/i]: R-Class Planet
[i]Habitability[/i]: Low (High Temperature, Toxic Atmosphere)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	color = "#dfff3f" //Bright yellow
	in_space = 0
	initial_generic_waypoints = list("aerostat_west","aerostat_east","aerostat_south","aerostat_northwest","aerostat_northeast")

// -- Datums -- //

/* Temporarily added a copy to tether_things.dm as a shuttle datum for a shuttle that isnt loaded in throws runtimes. -Bloop
/datum/shuttle/autodock/ferry/aerostat
	name = "Aerostat Ferry"
	shuttle_area = /area/shuttle/aerostat
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_station = "aerostat_east"
	landmark_offsite = "aerostat_surface"
*/

/datum/random_map/noise/ore/virgo2
	descriptor = "virgo 2 ore distribution map"
	deep_val = 0.2
	rare_val = 0.1

/datum/random_map/noise/ore/virgo2/check_map_sanity()
	return 1 //Totally random, but probably beneficial.

// -- Objs -- //

/obj/machinery/computer/shuttle_control/aerostat_shuttle
	name = "aerostat ferry control console"
	shuttle_tag = "Aerostat Ferry"

/obj/tether_away_spawner/aerostat_inside
	name = "Aerostat Indoors Spawner"
	faction = "aerostat_inside"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic = 3,
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion = 1,
		/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser = 3,
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1
	)

/obj/tether_away_spawner/aerostat_surface
	name = "Aerostat Surface Spawner"
	faction = "aerostat_surface"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 30
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/jelly = 6,
		/mob/living/simple_mob/mechanical/viscerator = 6,
		/mob/living/simple_mob/vore/aggressive/corrupthound = 3
	)

/obj/structure/old_roboprinter
	name = "old drone fabricator"
	desc = "Built like a tank, still working after so many years."
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	anchored = TRUE
	density = TRUE

/obj/structure/metal_edge
	name = "metal underside"
	desc = "A metal wall that extends downwards."
	icon = 'icons/turf/cliff.dmi'
	icon_state = "metal"
	anchored = TRUE
	density = FALSE

// -- Turfs -- //

/turf/simulated/floor/sky/virgo2_sky
	name = "virgo 2 atmosphere"
	desc = "Be careful where you step!"
	color = "#eacd7c"
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2

/turf/simulated/floor/sky/virgo2_sky/Initialize(mapload)
	skyfall_levels = list(z+1)
	. = ..()

/turf/simulated/shuttle/wall/voidcraft/green/virgo2
	initial_gas_mix = ATMOSPHERE_ID_VIRGO2
	color = "#eacd7c"

/turf/simulated/shuttle/wall/voidcraft/green/virgo2/nocol
	color = null

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)

VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)

VIRGO2_TURF_CREATE(/turf/simulated/mineral)
/turf/simulated/mineral/virgo2/make_ore()
	if(mineral)
		return

	var/mineral_name = pickweight(list(MAT_MARBLE = 5, MAT_URANIUM = 5, MAT_PLATINUM = 5, MAT_HEMATITE = 5, MAT_CARBON = 5, MAT_DIAMOND = 5, MAT_GOLD = 5, MAT_SILVER = 5, MAT_LEAD = 5, MAT_VERDANTIUM = 5))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()

VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

// -- Areas -- //

// The aerostat shuttle
/area/shuttle/aerostat
	name = "\improper Aerostat Shuttle"

//The aerostat itself
/area/tether_away/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/tether_away/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/tether_away/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	dynamic_lighting = TRUE

/area/tether_away/aerostat/surface
	area_flags = AF_RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

/area/tether_away/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"

/area/tether_away/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"
