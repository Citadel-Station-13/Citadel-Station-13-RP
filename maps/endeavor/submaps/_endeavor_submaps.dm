// This causes endeavor submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.

/obj/effect/step_trigger/zlevel_fall
	var/target_z

//////////////////////////////////////////////////////////////////////////////
/// Static Load
#include "endeavor_ships.dmm"
#include "endeavor_misc.dmm"
/*
/datum/map_template/endeavor_lateload/endeavor_misc
	name = "Endeavor - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'endeavor_misc.dmm'

	associated_map_datum = /datum/map_z_level/endeavor_lateload/ships
*/
/datum/map_z_level/endeavor_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED
/*
/datum/map_template/endeavor_lateload/Endeavor_ships
	name = "Endeavor - Ships"
	desc = "Ship transit map and whatnot."
	mappath = 'endeavor_ships.dmm'

	associated_map_datum = /datum/map_z_level/endeavor_lateload/ships
*/
/datum/map_z_level/endeavor_lateload/ships
	name = "Ships"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED

//////////////////////////////////////////////////////////////////////////////


/// Away Missions
#include "odin5a-desert/odin5a.dm"

#include "odin5a-desert/odin5a-beach.dmm"//Things are weird if they aren't compiled with the rest of the maps. Look into this later
#include "odin5a-desert/odin5a-cave.dmm"

//Closest moon to the Odin 5 gas giant. Desert world torn by tidal forces and covered in raging oceans, widespread deserts, and deadly volcanoes
/*don't double load
/datum/map_template/endeavor_lateload/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = 'odin5a-desert/odin5a-beach.dmm'
	associated_map_datum = /datum/map_z_level/endeavor_lateload/away_beach
*/
/datum/map_z_level/endeavor_lateload/away_beach
	name = "Away Mission - Desert Beach"
	z = Z_LEVEL_ODIN5A_BEACH
/*don't double load
/datum/map_template/endeavor_lateload/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = 'odin5a-desert/odin5a-cave.dmm'
	associated_map_datum = /datum/map_z_level/endeavor_lateload/away_beach_cave
*/
/datum/map_z_level/endeavor_lateload/away_beach_cave
	name = "Away Mission - Desert Cave"
	z = Z_LEVEL_ODIN5A_CAVE

/*
#include "alienship/_alienship.dm"
/datum/map_template/endeavor_lateload/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	mappath = 'alienship/alienship.dmm'
	associated_map_datum = /datum/map_z_level/endeavor_lateload/away_alienship

/datum/map_z_level/endeavor_lateload/away_alienship
	name = "Away Mission - Alien Ship"


#include "aerostat/_aerostat.dm"
/datum/map_template/endeavor_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = 'aerostat/aerostat.dmm'
	associated_map_datum = /datum/map_z_level/endeavor_lateload/away_aerostat

/datum/map_z_level/endeavor_lateload/away_aerostat
	name = "Away Mission - Aerostat"

/datum/map_template/endeavor_lateload/away_aerostat_surface
	name = "Remmi Aerostat - Z2 Surface"
	desc = "The surface from the Virgo 2 Aerostat."
	mappath = 'aerostat/surface.dmm'
	associated_map_datum = /datum/map_z_level/endeavor_lateload/away_aerostat_surface

/datum/map_z_level/endeavor_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"


//////////////////////////////////////////////////////////////////////////////////////
// Admin-use z-levels for loading whenever an admin feels like
#if AWAY_MISSION_TEST
#include "admin_use/spa.dmm"
#endif

#include "admin_use/fun.dm"
/datum/map_template/endeavor_lateload/fun/spa
	name = "Space Spa"
	desc = "A pleasant spa located in a spaceship."
	mappath = 'admin_use/spa.dmm'

	associated_map_datum = /datum/map_z_level/endeavor_lateload/fun/spa

/datum/map_z_level/endeavor_lateload/fun/spa
	name = "Spa"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED

*/

//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Endeavor lateload maps
/datum/map_template/endeavor_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/endeavor_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_z_level/endeavor_lateload
	z = 0
	flags = MAP_LEVEL_SEALED

/datum/map_z_level/endeavor_lateload/New(var/datum/map/map, mapZ)
	if(mapZ)
		z = mapZ
	return ..(map)

/turf/unsimulated/wall/seperator //to block vision between transit zones
	name = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "1"

/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize()
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

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

/////////////////////////////
/obj/endeavor_away_spawner
	name = "RENAME ME, JERK"
	desc = "Spawns the mobs!"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101
	mouse_opacity = 0
	density = 0
	anchored = 1

	//Weighted with values (not %chance, but relative weight)
	//Can be left value-less for all equally likely
	var/list/mobs_to_pick_from

	//When the below chance fails, the spawner is marked as depleted and stops spawning
	var/prob_spawn = 100	//Chance of spawning a mob whenever they don't have one
	var/prob_fall = 5		//Above decreases by this much each time one spawns

	//Settings to help mappers/coders have their mobs do what they want in this case
	var/faction				//To prevent infighting if it spawns various mobs, set a faction
	var/atmos_comp			//TRUE will set all their survivability to be within 20% of the current air
	var/guard				//# will set the mobs to remain nearby their spawn point within this dist

	//Internal use only
	var/mob/living/simple_mob/my_mob
	var/depleted = FALSE

/obj/endeavor_away_spawner/Initialize()
	. = ..()

	if(!LAZYLEN(mobs_to_pick_from))
		error("Mob spawner at [x],[y],[z] ([get_area(src)]) had no mobs_to_pick_from set on it!")
		initialized = TRUE
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSobj, src)

/obj/endeavor_away_spawner/process()
	if(my_mob && my_mob.stat != DEAD)
		return //No need

	if(LAZYLEN(loc.human_mobs(world.view)))
		return //I'll wait.

	if(prob(prob_spawn))
		prob_spawn -= prob_fall
		var/picked_type = pickweight(mobs_to_pick_from)
		my_mob = new picked_type(get_turf(src))
		my_mob.low_priority = TRUE

		if(faction)
			my_mob.faction = faction

		if(atmos_comp)
			var/turf/T = get_turf(src)
			var/datum/gas_mixture/env = T.return_air()
			if(env)
				my_mob.minbodytemp = env.temperature * 0.8
				my_mob.maxbodytemp = env.temperature * 1.2

				var/list/gaslist = env.gas
				my_mob.min_oxy = gaslist[/datum/gas/oxygen] * 0.8
				my_mob.min_tox = gaslist[/datum/gas/phoron] * 0.8
				my_mob.min_n2 = gaslist[/datum/gas/nitrogen] * 0.8
				my_mob.min_co2 = gaslist[/datum/gas/carbon_dioxide] * 0.8
				my_mob.max_oxy = gaslist[/datum/gas/oxygen] * 1.2
				my_mob.max_tox = gaslist[/datum/gas/phoron] * 1.2
				my_mob.max_n2 = gaslist[/datum/gas/nitrogen] * 1.2
				my_mob.max_co2 = gaslist[/datum/gas/carbon_dioxide] * 1.2
/* //VORESTATION AI TEMPORARY REMOVAL
		if(guard)
			my_mob.returns_home = TRUE
			my_mob.wander_distance = guard
*/
		return
	else
		STOP_PROCESSING(SSobj, src)
		depleted = TRUE
		return

//Shadekin spawner. Could have them show up on any mission, so it's here.
//Make sure to put them away from others, so they don't get demolished by rude mobs.
/obj/endeavor_away_spawner/shadekin
	name = "Shadekin Spawner"
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "spawner"

	faction = "shadekin"
	prob_spawn = 1
	prob_fall = 1
	guard = 10 //Don't wander too far, to stay alive.
	mobs_to_pick_from = list(
		/mob/living/simple_mob/shadekin
	)

// Underdark mob spawners
/obj/endeavor_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/jelly = 3,
		/mob/living/simple_mob/animal/giant_spider/hunter = 1,
		/mob/living/simple_mob/animal/giant_spider/phorogenic = 1,
		/mob/living/simple_mob/animal/giant_spider/lurker = 1,
	)

/obj/endeavor_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1,
		/mob/living/simple_mob/vore/aggressive/rat = 1,
		/mob/living/simple_mob/animal/space/mimic = 1
	)

/obj/endeavor_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/dragon = 1
	)
