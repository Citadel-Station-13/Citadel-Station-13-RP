//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/orbital_deployment_translation
	var/list/turf_overlap_coord_x = list()
	var/list/turf_overlap_coord_y = list()
	var/list/atom/movable/crush_and_obliterate = list()

	var/turf/dest_lower_left
	var/turf/dest_upper_right
	/// computed in initialize()
	var/turf/dest_center
	/// computed in initialize()
	var/dest_width
	/// computed in initialize()
	var/dest_height

	var/area/structural_area

	var/list/atom/movable/falling_out_of_the_sky = list()

	var/datum/orbital_deployment_transit/transit
	var/datum/event_args/actor/launching_actor

	var/list/types_crushed = list()
	var/list/types_dropped = list()
	var/list/mob/important_mobs_crushed = list()
	var/list/mob/important_mobs_dropped = list()

	/// cached list of turf mappings for throws
	var/list/impact_throw_to_mappings = list()
	/// cached list of valid interior turfs that weren't part of the landing
	var/list/turf/interior_turfs_not_part_of_landing = list()

	/// length of interior turfs not part of landing over exterior turfs valid
	/// for 'get random outside turf' times 100 for prob()
	var/random_outside_interior_turfs_weighting
	/// all corner tiles over all exterior tiles
	var/random_outside_exterior_corner_weighting
	/// all width (top/bottom) tiles over all non-corner exterior tiles
	var/random_outside_exterior_width_weighting

	var/outside_turf_border = 3

/datum/orbital_deployment_translation/New(datum/orbital_deployment_transit/from_transit)
	transit = from_transit
	structural_area = from_transit.structural_area
	launching_actor = transit.launching_actor

/datum/orbital_deployment_translation/Destroy()
	transit = null
	turf_overlap_coord_x = turf_overlap_coord_y = null
	crush_and_obliterate = null
	dest_lower_left = dest_upper_right = null
	falling_out_of_the_sky = null
	QDEL_LIST(falling_out_of_the_sky)
	types_crushed = types_dropped = null
	important_mobs_crushed = important_mobs_dropped = null
	return ..()

/datum/orbital_deployment_translation/proc/initialize()
	dest_center = locate(
		floor((dest_upper_right.y - dest_lower_left.y) / 2),
		floor((dest_upper_right.x - dest_lower_left.x) / 2),
		dest_lower_left.z,
	)
	dest_width = dest_upper_right.x - dest_lower_left.x + 1
	dest_height = dest_upper_right.y - dest_lower_left.y + 1

/datum/orbital_deployment_translation/proc/on_turf_overlap(turf/from_turf, turf/to_turf)
	if(to_turf.density)
		turf_overlap_coord_x += to_turf.x
		turf_overlap_coord_y += to_turf.y
		++types_crushed[to_turf.type]

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
	++types_crushed[victim.type]
	if(ismob(victim))
		var/mob/mob_victim = victim
		if(mob_victim.is_potentially_important_for_logs())
			important_mobs_crushed += mob_victim
	if(throw_aside_and_crush)
		crush_and_obliterate += victim
		victim.forceMove(get_crush_move_turf_mapping(victim.loc))
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
			interior_turfs_not_part_of_landing += T
			continue
		for(var/obj/O in T)
			to_damage_objs += O
			++types_dropped[O.type]
	// 3 radius, times width or length, times sides, plus corners
	var/outside_turf_corner_turfs_per = outside_turf_border ** 2
	var/estimated_valid_outside_turfs = outside_turf_border * (dest_width * 2 + dest_height * 2) + outside_turf_corner_turfs_per * 4
	random_outside_interior_turfs_weighting = length(interior_turfs_not_part_of_landing) / (length(interior_turfs_not_part_of_landing + estimated_valid_outside_turfs)) * 100
	random_outside_exterior_corner_weighting = (outside_turf_corner_turfs_per * 4) / estimated_valid_outside_turfs * 100
	random_outside_exterior_width_weighting = (dest_width * outside_turf_border * 2) / (estimated_valid_outside_turfs - outside_turf_corner_turfs_per * 4) * 100

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
		if(where.loc != transported_area)
			continue
		to_damage_mobs += try_and_cheat_this_explo
		if(try_and_cheat_this_explo.is_potentially_important_for_logs())
			important_mobs_crushed += try_and_cheat_this_explo
		++types_dropped[try_and_cheat_this_explo.type]

	// render log output incase people get deleted from anything when we start doing stuff
	var/list/rendered_important_mobs_crushed = list()
	var/list/rendered_important_mobs_dropped = list()
	for(var/mob/entity as anything in important_mobs_crushed)
		rendered_important_mobs_crushed += key_name(entity)
	for(var/mob/entity as anything in important_mobs_dropped)
		rendered_important_mobs_dropped += key_name(entity)

	// log
	CHECK_TICK
	log_orbital_deployment(
		launching_actor,
		"orbital drop landed",
		list(
			"dropTypes" = types_dropped,
			"impactTypes" = types_crushed,
			"dropImportantMobs" = rendered_important_mobs_dropped,
			"impactImportantMobs" = rendered_important_mobs_crushed,
		),
	)

	// scream at everyone
	var/list/mob/to_notify_mobs = list()
	for(var/mob/outside in SSspatial_grids.living.range_query(mob_query_center, mob_query_dist + world_view_max_number()))
		to_notify_mobs += outside
	to_notify_mobs -= to_damage_mobs

	for(var/mob/notifying in to_notify_mobs)
		to_chat(notifying, SPAN_DANGER("You feel the ground lurch beneath you as the massive structure lands from orbit!"))
		shake_camera(notifying, 2 SECONDS, 0.5 * WORLD_ICON_SIZE)

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
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
				)
		CHECK_TICK

	// people who were stupid and didn't keep their hands and feet in the vehicle
	for(var/atom/movable/victim as anything in falling_out_of_the_sky)
		if(QDELETED(victim))
			continue
		var/turf/drop_at = get_random_outside_turf()
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
				DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
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
					ARMOR_BOMB,
					DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
					hit_zone = pick(global.all_body_zones),
				)
				CHECK_TICK

/datum/orbital_deployment_translation/proc/get_random_outside_turf()
	if(prob(random_outside_interior_turfs_weighting))
		return pick(interior_turfs_not_part_of_landing)
	if(prob(random_outside_exterior_corner_weighting))
		var/x = rand(1, outside_turf_border)
		var/y = rand(1, outside_turf_border)
		switch(rand(1, 4))
			// lower left
			if(1)
				return locate(dest_lower_left.x - x, dest_lower_left.y - y, dest_lower_left.z)
			// upper left
			if(2)
				return locate(dest_lower_left.x - x, dest_upper_right.y + y , dest_lower_left.z)
			// upper right
			if(3)
				return locate(dest_upper_right.x + x, dest_upper_right.y + y, dest_lower_left.z)
			// lower right
			if(4)
				return locate(dest_upper_right.x + x, dest_lower_left.y - y, dest_lower_left.z)
	if(prob(random_outside_exterior_width_weighting))
		var/x = rand(1, dest_width)
		var/y = rand(1, outside_turf_border)
		if(prob(50))
			// top
			return locate(dest_lower_left.x + x - 1, dest_upper_right.y + y, dest_lower_left.z)
		else
			// bottom
			return locate(dest_lower_left.x + x - 1, dest_lower_left.y - y, dest_lower_left.z)
	else
		var/x = rand(1, outside_turf_border)
		var/y = rand(1, dest_height)
		if(prob(50))
			// left
			return locate(dest_lower_left.x - x, dest_lower_left.y + y - 1, dest_lower_left.z)
		else
			// right
			return locate(dest_upper_right.x + x, dest_lower_left.y + y - 1, dest_lower_left.z)

/datum/orbital_deployment_translation/proc/get_crush_move_turf_mapping(turf/origin)
	// cached for speed
	var/list/impact_throw_to_mappings = src.impact_throw_to_mappings
	. = impact_throw_to_mappings[origin]
	if(.)
		return
	var/escape_dir = get_dir(dest_center, origin)
	if(!escape_dir)
		escape_dir = ALL
	else if(!ISDIAGONALDIR(escape_dir))
		escape_dir |= turn(escape_dir, 45) | turn(escape_dir, -45)
	var/shortest = INFINITY
	for(var/dir in global.alldirs)
		if(!(dir & escape_dir))
			continue
		var/turf/iterating = origin
		var/list/turf/iterated = list()
		for(var/i in 1 to 35)
			iterating = get_step(iterating, dir)
			iterated += iterating
			if(iterating.loc == structural_area)
				continue
			// found something outside
			for(var/turf/T as anything in iterated)
				if(impact_throw_to_mappings[T])
					if(prob(50))
						impact_throw_to_mappings[T] = iterating
				else
					impact_throw_to_mappings[T] = iterating
			if(shortest > i)
				shortest = min(shortest, i)
				. = iterating
			else if(shortest == i)
				if(prob(50))
					. = iterating
			break

	if(!.)
		CRASH("failed to get crush move turf mapping, an orbital deployment zone is probably way too big")
