//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Updates our base move delay
 */
/mob/proc/update_movespeed_base()
	#warn impl
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

#warn impl all

/**
 * Adds a movespeed modifier to a mob.
 *
 * @params
 * * modifier - typepath, or instance. text ID is only usable if its a hardcoded modifier.
 * * skip_update - do not update movespeed immediately
 *
 * @return TRUE / FALSE on success / failure
 */
/mob/proc/add_movespeed_modifier(datum/movespeed_modifier/modifier, skip_update)
	if(ispath(type_or_datum))
		if(!initial(type_or_datum.variable))
			type_or_datum = get_cached_movespeed_modifier(type_or_datum)
		else
			type_or_datum = new type_or_datum
	var/key = istext(modifier) ? modifier : modifier.id
	#warn impl
	var/datum/movespeed_modifier/existing = LAZYACCESS(movespeed_modifiers, key)
	if(existing)
		if(existing == type_or_datum)		//same thing don't need to touch
			return TRUE
		remove_movespeed_modifier(existing, TRUE)
	if(length(movespeed_modifiers))
		BINARY_INSERT(type_or_datum.id, movespeed_modifiers, /datum/movespeed_modifier, type_or_datum, priority, COMPARE_VALUE)
	LAZYSET(movespeed_modifiers, type_or_datum.id, type_or_datum)
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
 * Used for variable slowdowns like hunger/health loss/etc, works somewhat like the old list-based modification adds. Returns the modifier datum if successful
 * How this SHOULD work is:
 * 1. Ensures type_id_datum one way or another refers to a /variable datum. This makes sure it can't be cached. This includes if it's already in the modification list.
 * 2. Instantiate a new datum if type_id_datum isn't already instantiated + in the list, using the type. Obviously, wouldn't work for ID only.
 * 3. Add the datum if necessary using the regular add proc
 * 4. If any of the rest of the args are not null (see: multiplicative slowdown), modify the datum
 * 5. Update if necessary
 */
/mob/proc/update_movespeed_modifier(datum/movespeed_modifier/modifier, list/params, skip_update)
	var/modified = FALSE
	var/inject = FALSE
	var/datum/movespeed_modifier/applying
	if(istext(type_id_datum))
		applying = LAZYACCESS(movespeed_modifiers, type_id_datum)
		if(!applying)
			CRASH("Couldn't find existing modification when provided a text ID.")
	else if(ispath(type_id_datum))
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		applying = LAZYACCESS(movespeed_modifiers, initial(type_id_datum.id) || "[type_id_datum]")
		if(!applying)
			applying = new type_id_datum
			inject = TRUE
			modified = TRUE
	else
		if(!initial(type_id_datum.variable))
			CRASH("Not a variable modifier")
		applying = type_id_datum
		if(!LAZYACCESS(movespeed_modifiers, applying.id))
			inject = TRUE
			modified = TRUE
	if(applying.parse(params))
		modified = TRUE
	if(inject)
		add_movespeed_modifier(applying, FALSE)
	if(update && modified)
		update_movespeed(TRUE)
	return applying

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
	for(var/datum/movespeed_modifier/M in movespeed_modifiers)
		if(movespeed_modifier_immunities[M.id])
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
		add_or_update_variable_movespeed_modifier(
			/datum/movespeed_modifier/admin_varedit,
			params = list(
				MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = diff,
			)
		)
