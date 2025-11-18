//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_translation
	var/list/turf_overlap_coord_x = list()
	var/list/turf_overlap_coord_y = list()
	var/list/atom/movable/crush_and_obliterate = list()

	var/turf/dest_lower_left
	var/turf/dest_upper_right
	var/list/atom/movable/falling_out_of_the_sky = list()

	var/datum/orbital_deployment_transit/transit

/datum/orbital_deployment_translation/New(datum/orbital_deployment_transit/from_transit)
	transit = from_transit

/datum/orbital_deployment_translation/Destroy()
	transit = null
	turf_overlap_coord_x = turf_overlap_coord_y = null
	crush_and_obliterate = null
	dest_lower_left = dest_upper_right = null
	falling_out_of_the_sky = null
	QDEL_LIST(falling_out_of_the_sky)
	return ..()

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
		victim.forceMove(get_random_outside_turf())
	else
		qdel(victim)

/datum/orbital_deployment_translation/proc/get_unordered_dest_turfs()
	return block(dest_lower_left, dest_upper_right)

/datum/orbital_deployment_translation/proc/run_aftereffects(area/orbital_deployment_area/transported_area)
	// First, gather, as this doesn't CHECK_TICK
	var/list/obj/to_damage_objs = list()
	var/list/mob/to_damage_mobs = list()
	for(var/turf/T as anything in block(dest_lower_left, dest_upper_right))
		if(T.loc != transported_area)
			continue
		for(var/obj/O in T)
			to_damage_objs += O
	// cheat this, explo
	var/mob_query_dist = ceil(
		max(
			abs(dest_upper_right.x - dest_lower_left.x),
			abs(dest_upper_right.y - dest_lower_left.y),
		) * 0.5
	)
	var/turf/mob_query_center = locate(dest_lower_left.x + mob_query_dist, dest_lower_left.y + mob_query_dist, dest_lower_left.z)
	for(var/mob/try_and_cheat_this_explo in SSspatial_grids.living.range_query(mob_query_center, mob_query_dist))
		var/turf/where = get_turf(try_and_cheat_this_explo)
		if(where.x < dest_lower_left.x)
			continue
		if(where.x > dest_upper_right.x)
			continue
		if(where.y < dest_lower_left.y)
			continue
		if(where.y > dest_upper_right.y)
			continue
		to_damage_mobs += try_and_cheat_this_explo

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
		if(ismob(victim))
			var/mob/living/living_victim = victim
			var/dmg_sides = living_victim.mind?.ckey ? transit.c_impact_mob_dmg_sides : transit.c_impact_mob_dmg_sides_for_those_without_plot_armor
			for(var/i in 1 to transit.c_impact_mob_dmg_cnt)
				// TODO: it's probably faster to run damage instance all at once and apply it over 15 areas,
				//       rather than treat it as 15 instances
				living_victim.run_damage_instance(
					transit.c_impact_mob_dmg_base + rand(1, dmg_sides),
					DAMAGE_TYPE_BRUTE,
					5,
					ARMOR_MELEE,
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
					hit_zone = pick(global.all_body_zones),
				)
		else
			for(var/i in 1 to transit.c_impact_obj_dmg_cnt)
				victim.run_damage_instance(
					transit.c_impact_obj_dmg_base + rand(1, transit.c_impact_obj_dmg_sides),
					DAMAGE_TYPE_BRUTE,
					6,
					ARMOR_MELEE,
				)
		CHECK_TICK

	// people who were stupid and didn't keep their hands and feet in the vehicle
	for(var/atom/movable/victim as anything in falling_out_of_the_sky)
		var/turf/drop_at = get_random_outside_turf(7)
		victim.forceMove(drop_at)
		// fuck you take double damage
		if(ismob(victim))
			to_damage_mobs += victim
			to_damage_mobs += victim
		else if(isobj(victim))
			to_damage_objs += victim
			to_damage_objs += victim

	// surely you didn't ride an orbital drop.
	// TODO: these should be `/atom/movable/proc/on_orbital_drop()`, this is shitcode
	// TODO: when this is done make sure you can't escape it by exiting vehicle during
	//       the CHECK_TICK
	for(var/obj/O as anything in to_damage_objs)
		for(var/i in 1 to transit.c_landing_obj_dmg_cnt)
			O.run_damage_instance(
				transit.c_landing_obj_dmg_base + rand(1, transit.c_landing_obj_dmg_sides),
				DAMAGE_TYPE_BRUTE,
				4,
				ARMOR_BOMB,
			)
		CHECK_TICK
	for(var/mob/M as anything in to_damage_mobs)
		if(isliving(M))
			var/mob/living/L = M
			for(var/i in 1 to transit.c_landing_mob_dmg_cnt)
				// probably should've thought it through
				L.run_damage_instance(
					transit.c_landing_mob_dmg_base + rand(1, transit.c_landing_mob_dmg_sides),
					DAMAGE_TYPE_BRUTE,
					5,
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
					ARMOR_BOMB,
					hit_zone = pick(global.all_body_zones),
				)
				CHECK_TICK

#warn log the shit out of ... everything

/**
 * get random turf outside of edge
 */
/datum/orbital_deployment_translation/proc/get_random_outside_turf(radius = 1)

	#warn impl
