//! shitcode in this file oop
/mob/living/proc/throw_item(obj/item/I, atom/target, overhand, neat = a_intent == INTENT_HELP, force = throw_impulse, overhand = in_throw_mode == THROW_MODE_OVERHAND)
	if(!I)
		return FALSE
	throw_mode_off()
	if(!can_throw_item(I, target))
		return FALSE
	if(is_in_inventory(I))
		if(!drop_item_to_ground(I))
			to_chat(src, SPAN_WARNING("You try and fail to throw [I] at [target]."))
		return FALSE
	var/atom/movable/throwing = I.throw_resolve_actual()

	// overhand stuff
	if(overhand)
		var/delay = throwing.overhand_throw_delay(src)
		visible_message(SPAN_WARNING("[src] starts preparing an overhand throw!"))
		if(!do_after(src, delay, throwing))
			return FALSE

	I.forceMove(drop_location())
	if(QDELETED(throwing))
		return FALSE
	throwing.forceMove(get_turf(src))
	if(!isturf(target) && !isturf(target.loc))
		return FALSE
	if(!isturf(loc) || !isturf(throwing.loc))
		return FALSE

	//! stupid shit
	var/the_range = throwing.throw_range
	if(ismob(throwing))
		the_range = round(M.throw_range * min(mob_size / M.mob_size, 1))
	//! stupid shit end, refactor grabs when?

	if(overhand)
		visible_message(SPAN_WARNING("[src] throws [throwing] overhand."))
	else
		visible_message(SPAN_WARNING("[src] has thrown [throwing]."))
	newtonian_move(get_dir(target, src))

	throwing.throw_at(target, the_range, null, (a_intent == INTENT_HELP? THROW_AT_IS_NEAT : NONE) | (overhand? THROW_AT_OVERHAND : NONE), src, force = throw_impulse)

/mob/living/throw_at(atom/target, range, speed, flags, atom/thrower, datum/callback/on_hit, datum/callback/on_land, force)
	. = ..()
	if(!.)
		return
	var/turf/T = get_turf(target)
	add_attack_logs(thrower, src, "Thrown via grab to [COORD(T)]")
