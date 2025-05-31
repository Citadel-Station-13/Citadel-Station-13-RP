//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Updates our base move delay
 */
/mob/proc/update_movespeed_base()
	update_movespeed_modifier(/datum/movespeed_modifier/base_movement_speed, list(MOVESPEED_PARAM_MOD_TILES_PER_SECOND = get_movespeed_base()), TRUE)
	update_movespeed()

/**
 * @return base movement speed in tiles per second
 */
/mob/proc/get_movespeed_base()
	return 20

/**
 * Gets list of string tags we count as in movespeed configuration overrides.
 *
 * @return ordered list with later elements overriding earlier ones
 */
/mob/proc/get_movespeed_config_tags()
	. = list("type-[replacetext("[type]", "/", "-")]")

/**
 * Adds a movespeed modifier to a mob.
 *
 * * Any existing ones will be overridden.
 * * If a variable modifier's typepath is passed in, a new one will be made no matter what,
 *   throwing out any old modifier.
 *
 * @params
 * * modifier - typepath, or instance.
 * * skip_update - do not update movespeed immediately
 *
 * @return TRUE / FALSE on success / failure
 */
/mob/proc/add_movespeed_modifier(datum/movespeed_modifier/modifier, skip_update)
	var/datum/movespeed_modifier/resolved
	if(modifier.variable)
		resolved = ispath(modifier) ? new modifier : modifier
	else
		resolved = ispath(modifier) ? get_cached_movespeed_modifier(modifier) : modifier
	if(movespeed_modifiers?[resolved.id])
		remove_movespeed_modifier(resolved.id, TRUE)
	if(length(movespeed_modifiers))
		BINARY_INSERT(resolved.id, movespeed_modifiers, /datum/movespeed_modifier, resolved, priority, COMPARE_VALUE)
	LAZYSET(movespeed_modifiers, resolved.id, resolved)
	if(!skip_update)
		update_movespeed()
	return TRUE

/**
 * Remove a movespeed modifier from a mob.
 *
 * @params
 * * modifier - typepath, id, or instance
 * * skip_update - do not update movespeed immediately
 *
 * @return TRUE / FALSE on success / failure
 */
/mob/proc/remove_movespeed_modifier(datum/movespeed_modifier/modifier, skip_update)
	var/key = istext(modifier) ? modifier : modifier.id
	if(!LAZYACCESS(movespeed_modifiers, key))
		return FALSE
	LAZYREMOVE(movespeed_modifiers, key)
	if(!skip_update)
		update_movespeed()
	return TRUE

/**
 * TODO: rewrite this comment
 *
 * Used for variable slowdowns like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
 * How this SHOULD work is:
 * 1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
 * 2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
 * 3. Add the datum if necessary using the regular add proc
 * 4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
 * 5. Update if necessary
 *
 * @params
 * * modifier - typepath, instance, or id. if id, it must already exist on us. if instance, it'll be modified.
 * * params - params to parse to modify the modifier.
 * * skip_update - do not update movespeed immediately
 *
 * @return TRUE / FALSE on success / failure
 */
/mob/proc/update_movespeed_modifier(datum/movespeed_modifier/modifier, list/params, skip_update)
	var/datum/movespeed_modifier/editing
	var/modified = FALSE
	if(modifier.variable)
		editing = movespeed_modifiers?[istext(modifier) ? modifier : modifier.id]
		if(!editing)
			editing = ispath(modifier) ? new modifier : modifier
			if(length(movespeed_modifiers))
				BINARY_INSERT(editing.id, movespeed_modifiers, /datum/movespeed_modifier, editing, priority, COMPARE_VALUE)
			LAZYSET(movespeed_modifiers, editing.id, editing)
			modified = TRUE
	else
		CRASH("attempted to update_movespeed_modifier on a non variable modifier.")
	if(editing.parse(params))
		modified = TRUE
	if(!skip_update && modified)
		update_movespeed(TRUE)
	return TRUE

/**
 * @params
 * * modifier - typepath, id, or instance
 *
 * @return TRUE / FALSE
 */
/mob/proc/has_movespeed_modifier(datum/movespeed_modifier/modifier)
	var/key = istext(modifier) ? modifier : modifier.id
	return movespeed_modifiers?[key] ? TRUE : FALSE

/// Go through the list of movespeed modifiers and calculate a final movespeed. ANY ADD/REMOVE DONE IN UPDATE_MOVESPEED MUST HAVE THE UPDATE ARGUMENT SET AS FALSE!
/mob/proc/update_movespeed()
	. = 0
	for(var/id in movespeed_modifiers)
		var/datum/movespeed_modifier/M = movespeed_modifiers[id]
		if(movespeed_modifier_immunities?[M.id])
			continue
		if(!(M.movetypes_allowed & movement_type)) // We don't affect any of these move types, skip
			continue
		if(M.movetypes_disallowed & movement_type) // There's a movetype here that disables this modifier, skip
			continue
		//! TODO: LEGACY - this should just check for floating
		if((M.movespeed_modifier_flags & MOVESPEED_MODIFIER_REQUIRES_GRAVITY) && !in_gravity)
			continue
		//! END
		. = M.apply_hyperbolic(., src)
	movespeed_hyperbolic = min(., 10 / MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND)
	if(!client)
		return
	var/diff = (last_self_move - move_delay) - movespeed_hyperbolic
	if(diff > 0)
		// your delay decreases, "give" the delay back to the client
		if(move_delay > world.time + 1.5)
			move_delay -= diff
#ifdef SMOOTH_MOVEMENT
		var/timeleft = world.time - move_delay
		var/elapsed = world.time - last_self_move
		var/glide_size_current = glide_size
		if((timeleft <= 0) || (elapsed > 20))
			SMOOTH_GLIDE_SIZE(src, 16, TRUE)
			return
		var/pixels_moved = glide_size_current * elapsed * (1 / world.tick_lag)
		// calculate glidesize needed to move to the next tile within timeleft deciseconds
		var/ticks_allowed = timeleft / world.tick_lag
		var/pixels_per_tick = pixels_moved / ticks_allowed
		SMOOTH_GLIDE_SIZE(src, pixels_per_tick * GLOB.glide_size_multiplier, TRUE)
#endif

/// Handles the special case of editing the movement var
/mob/vv_edit_var(var_name, var_value)
	var/slowdown_edit = (var_name == NAMEOF(src, movespeed_hyperbolic))
	var/diff
	if(slowdown_edit && isnum(movespeed_hyperbolic) && isnum(var_value))
		remove_movespeed_modifier(/datum/movespeed_modifier/admin_varedit)
		diff = var_value - movespeed_hyperbolic
	. = ..()
	if(. && slowdown_edit && isnum(diff))
		update_movespeed_modifier(
			/datum/movespeed_modifier/admin_varedit,
			params = list(
				MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = diff,
			)
		)
