//! shitcode in this file oop
/mob/living/throw_item(obj/item/I, atom/target, overhand, neat = a_intent == INTENT_HELP, force = throw_impulse, overhand = in_throw_mode == THROW_MODE_OVERHAND)
	if(!I)
		return FALSE
	throw_mode_off()
	// if we're not on a turf just don't
	if(!isturf(loc) || !(isturf(target) || isturf(target.loc)) || QDELETED(I))
		return FALSE
	if(!can_throw_item(I, target))
		return FALSE
	if(is_in_inventory(I) && !can_unequip(I))
		to_chat(src, SPAN_WARNING("You fail to throw [I] at [target]."))
		return FALSE
	var/atom/movable/throwing = I.throw_resolve_actual(src)
	// overhand stuff
	if(overhand)
		var/delay = throwing.overhand_throw_delay(src)
		visible_message(SPAN_WARNING("[src] starts preparing an overhand throw!"))
		if(!do_after(src, delay))
			return FALSE
	// make sure they didn't bamboozle us.
	if(QDELETED(throwing))
		to_chat(src, SPAN_WARNING("You fail to throw [I] at [target]."))
		return FALSE
	// make sure there's no special behavior
	if(!I.throw_resolve_override(throwing, src))
		// drop item
		if(is_in_inventory(I))
			if(!drop_item_to_ground(I))
				to_chat(src, SPAN_WARNING("You fail to throw [I] at [target]."))
				return FALSE
		else
			// just move it to our loc
			I.forceMove(get_turf(src))
	else
		if(!isturf(throwing.loc))
			CRASH("throw resolve override called but didn't move what we should throw to turf. this is bad practice.")
	// but also make sure it's on the ground
	if(!isturf(loc) || !(isturf(target) || isturf(target.loc)))
		return FALSE
	// point of no return
	// special: make message first
	if(overhand)
		visible_message(SPAN_WARNING("[src] throws [throwing] overhand."))
	else
		visible_message(SPAN_WARNING("[src] has thrown [throwing]."))
	I.throw_resolve_finalize(throwing, src)
	// if the thing deleted itself, we didn't fail, it disappeared
	if(QDELETED(throwing))
		return TRUE
	// point of no return but actually

	var/impulse = throw_impulse
	// overhand throws are weak
	if(overhand)
		impulse *= (1 / OVERHAND_THROW_FORCE_REDUCTION_FACTOR)

	//! stupid shit
	var/the_range = throwing.throw_range
	if(ismob(throwing))
		var/mob/M = throwing
		the_range = round(M.throw_range * min(mob_size / M.mob_size, 1))
	//! stupid shit end, refactor grabs when?

	newtonian_move(get_dir(target, src))

	throwing.throw_at(target, the_range, null, (a_intent == INTENT_HELP? THROW_AT_IS_NEAT : NONE) | (overhand? THROW_AT_OVERHAND : NONE), src, force = impulse)

	trigger_aiming(TARGET_CAN_CLICK)
	return TRUE

/mob/living/throw_at(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force)
	. = ..()
	if(!.)
		return
	var/turf/T = get_turf(target)
	if(ismob(thrower))
		add_attack_logs(thrower, src, "Thrown via grab to [COORD(T)]")
