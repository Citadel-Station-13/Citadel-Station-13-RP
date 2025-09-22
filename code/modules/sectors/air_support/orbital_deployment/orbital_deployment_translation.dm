//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_translation
	var/list/turf_overlap_coord_x = list()
	var/list/turf_overlap_coord_y = list()
	var/list/atom/movable/crush_and_obliterate = list()

	var/turf/dest_lower_left
	var/turf/dest_upper_right
	#warn hook these

/datum/orbital_deployment_translation/proc/on_turf_overlap(turf/from_turf, turf/to_turf)
	if(to_turf.density)
		turf_overlap_coord_x += to_turf.x
		turf_overlap_coord_y += to_turf.y

/datum/orbital_deployment_translation/proc/on_movable_overlap(atom/movable/victim, turf/from_turf, turf/to_turf)
	var/throw_aside_and_crush = FALSE
	if(victim.integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		throw_aside_and_crush = TRUE
	else if(ismob(victim))
		throw_aside_and_crush = TRUE
	else
		var/full_obliteration_chance = 20
		if(isitem(victim))
			var/obj/item/item_victim = victim
			full_obliteration_chance = 100 - (item_victim.w_class - 1) * 20
		if(!prob(full_obliteration_chance))
			throw_aside_and_crush = TRUE
	if(throw_aside_and_crush)
		crush_and_obliterate += victim
	else
		qdel(victim)

/datum/orbital_deployment_translation/proc/get_unordered_dest_turfs()
	return block(dest_lower_left, dest_upper_right)

/datum/orbital_deployment_translation/proc/run_aftereffects()
	// First, gather, as this doesn't CHECK_TICK
	var/list/obj/to_damage_objs = list()
	var/list/mob/to_damage_mobs = list()
	for(var/turf/T as anything in get_dest_turfs())
		for(var/obj/O in T)
			to_damage_objs += O
			if(isvehicle(O))
				var/obj/vehicle/no_cheating = O
				for(var/mob/in_vehicle in no_cheating)
					to_damage_mobs += in_vehicle
		for(var/mob/M in T)
			to_damage_mobs += M

	// turfs that shouldn't be there result in a small explosion
	for(var/tuple_i in 1 to length(turf_overlap_coord_x))
		var/turf/impacted_turf = locate(
			turf_overlap_coord_x[tuple_i],
			turf_overlap_coord_y[tuple_i],
			dest_lower_left.z,
		)
		explosion(impacted_turf, 0, rand(1, 2), 3)
		CHECK_TICK

	// movables that shouldn't be there and weren't immediately deleted
	// will be pushed out of the way and obliterated
	// -- this is not 'as anything' as some movables can be obliterated by being moved to nullspace --
	// TODO: if only this was ss14. is there a way to throw the components away from us if they are
	//       destroyed in the process?
	for(var/atom/movable/victim in crush_and_obliterate)
		var/turf/where = get_random_outside_turf(5)
		victim.forceMove(where)
		if(ismob(victim))
			var/mob/living/living_victim = victim
			for(var/i in 1 to 15)
				// TODO: it's probably faster to run damage instance all at once and apply it over 15 areas,
				//       rather than treat it as 15 instances
				living_victim.run_damage_instance(
					500 / 15,
					DAMAGE_TYPE_BRUTE,
					5,
					ARMOR_MELEE,
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
					hit_zone = pick(global.all_body_zones),
				)
		else
			victim.run_damage_instance(
				500,
				DAMAGE_TYPE_BRUTE,
				6,
				ARMOR_MELEE,
			)
		CHECK_TICK

	// surely you didn't ride an orbital drop.
	// TODO: these should be `/atom/movable/proc/on_orbital_drop()`, this is shitcode
	// TODO: when this is done make sure you can't escape it by exiting vehicle during
	//       the CHECK_TICK
	for(var/obj/O as anything in to_damage_objs)
		O.run_damage_instance(rand(15, 70), DAMAGE_TYPE_BRUTE, 4, ARMOR_BOMB)
		CHECK_TICK
	for(var/mob/M as anything in to_damage_mobs)
		if(isliving(M))
			var/mob/living/L = M
			for(var/i in 1 to 15)
				// probably should've thought it through
				L.run_damage_instance(
					rand(10, 30),
					DAMAGE_TYPE_BRUTE,
					5,
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
					ARMOR_BOMB,
					hit_zone = pick(global.all_body_zones),
				)
				CHECK_TICK


/**
 * get random turf outside of edge
 */
/datum/orbital_deployment_translation/proc/get_random_outside_turf(radius = 1)
	#warn impl
