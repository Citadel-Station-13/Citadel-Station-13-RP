// Shuttle Path for lava land

// -- Datums -- //
/*/obj/effect/overmap/visitable/sector/lavaland
	name = "Mineral Rich Planet"			// The name of the destination
	desc = "Sensors indicate that this is a world filled with minerals.  There seems to be a thin atmosphere on the planet."
	icon_state = "globe"
	color = "#4e4e4e"	// Bright yellow
	initial_generic_waypoints = list("poid_main")
*/
// POI Init
/obj/away_mission_init/lavaland
	name = "away mission initializer -  lava land"

/obj/away_mission_init/lavaland/Initialize()
	return INITIALIZE_HINT_QDEL

/area/shuttle/excursion/lavaland
	name = "Shuttle Landing Point"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	flags = RAD_SHIELDED

/area/triumph_away/lavaland
	name = "Lava Land"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/triumph_away/lavaland/horrors
	name = "Lava Land - Horrors"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/triumph_away/lavaland/dogs
	name = "Lava Land - Dogs"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/triumph_away/lavaland/idleruins
	name = "Lava Land - Idle Ruins"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/triumph_away/lavaland/bosses
	name = "Lava Land - Boss"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	requires_power = 0

/obj/effect/landmark/lavaland_entry
	name = "lavaland_entry"


/obj/effect/landmark/lavaland_exit
	name = "lavaland_exit"


/obj/machinery/lavaland_entryportal
	name = "Magmatic Rift Teleporter"
	desc = "A bluespace quantum-linked telepad used for teleporting objects to other quantum pads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	anchored = 1
	use_power = USE_POWER_IDLE
	interact_offline = 0

	attack_hand(mob/living/user as mob)
		if(inoperable(MAINT))
			return 1
		else if(do_after(user, 10))
			to_chat(user, "You feel reality shift around you.")
			do_teleport(user, pick(lavaland_entry), local = FALSE)
			move_object(user, pick(lavaland_entry))
		return

/obj/machinery/lavaland_entryportal/proc/move_object(atom/movable/AM, turf/T)
	if(AM.anchored && !istype(AM, /obj/mecha))
		return

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.pulling)
			var/atom/movable/P = L.pulling
			L.stop_pulling()
			P.forceMove(T)
			L.forceMove(T)
			L.start_pulling(P)
		else
			L.forceMove(T)
	else
		AM.forceMove(T)

/obj/effect/lavaland_exitportal // effect so it cant be removed by griefers
	name = "Magmatic Rift Teleporter"
	desc = "A bluespace quantum-linked telepad used for teleporting objects to other quantum pads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	anchored = 1


	attack_hand(mob/living/user as mob)
		if(do_after(user, 10))
			to_chat(user, "You feel reality shift around you.")
			do_teleport(user, pick(lavaland_exit), local = FALSE)
			move_object(user, pick(lavaland_exit))
		return

/obj/effect/lavaland_exitportal/proc/move_object(atom/movable/AM, turf/T)
	if(AM.anchored && !istype(AM, /obj/mecha))
		return

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.pulling)
			var/atom/movable/P = L.pulling
			L.stop_pulling()
			P.forceMove(T)
			L.forceMove(T)
			L.start_pulling(P)
		else
			L.forceMove(T)
	else
		AM.forceMove(T)

// lava land world areas
/area/triumph_away/lavaland
	name = "Lava Land"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	dynamic_lighting = 1
	

/area/triumph_away/lavaland/base
	name = "Lava Land - Mining Base"
	icon_state = "green"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	requires_power = 0

/area/triumph_away/lavaland/base/common
	name = "Lava Land - Mining Base"
	icon_state = "blue"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	requires_power = 0
/area/triumph_away/lavaland/explored
	name = "Lava Land - Thoroughfare"
	icon_state = "red"
	/turf/simulated/floor/outdoors/lavaland

/area/triumph_away/lavaland/unexplored
	name = "Lava Land - Unknown"
	icon_state = "yellow"
	base_turf = /turf/simulated/floor/outdoors/lavaland

// Lava Land turfs
/turf/simulated/floor/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	outdoors = 1
	flags = TURF_HAS_EDGES
	edge_blending_priority = 2
	base_icon_state = "asteroid"
	turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	initial_flooring = /decl/flooring/outdoors/lavaland

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/lavaland
	descriptor = "lava land mine ore distribution map"
	deep_val = 0.7 //More riches, normal is 0.7 and 0.8
	rare_val = 0.8

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/lavaland/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

//// Something is causing the ore spawn to error out, but still spawn ores for us so we'll need to keep tabs on why this is.
//// Hopefully the increased rarity val will cause the error to vanish, but we'll see. - Enzo 9/8/2020

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	admin_notice("RARE COUNT [rare_count]", R_DEBUG)
	admin_notice("SURFACE COUNT [surface_count]", R_DEBUG)
	admin_notice("DEEP COUNT [deep_count]", R_DEBUG)
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1
