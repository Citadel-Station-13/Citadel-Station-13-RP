/mob/proc/throw_item(obj/item/I, atom/target, overhand, neat = a_intent == INTENT_HELP, force = THROW_FORCE_DEFAULT)
	return

/mob/proc/toggle_throw_mode(overhand)
	if(overhand)
		switch(in_throw_mode)
			if(THROW_MODE_ON)
				throw_mode_overhand()
			if(THROW_MODE_OVERHAND)
				throw_mode_off()
			if(THROW_MODE_OFF)
				throw_mode_overhand()
	else
		switch(in_throw_mode)
			if(THROW_MODE_ON)
				throw_mode_off()
			if(THROW_MODE_OVERHAND)
				throw_mode_on()
			if(THROW_MODE_OFF)
				throw_mode_on()

/mob/proc/throw_mode_off()
	in_throw_mode = THROW_MODE_OFF
	throw_icon?.update_icon()

/mob/proc/throw_mode_on()
	in_throw_mode = THROW_MODE_ON
	throw_icon?.update_icon()

/mob/proc/throw_mode_overhand()
	in_throw_mode = THROW_MODE_OVERHAND
	throw_icon?.update_icon()

/mob/proc/throw_mode_check()
	return in_throw_mode != THROW_MODE_OFF

/mob/proc/throw_active_held_item(atom/target)
	var/obj/item/held = get_active_held_item()
	if(!held)
		return
	return throw_item(held, target)

/mob/proc/can_throw_item(obj/item/I, atom/target)
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't throw things right now!"))
		return FALSE
	return TRUE

/mob/overhand_throw_delay(mob/user)
	return OVERHAND_THROW_MOB_DELAY
