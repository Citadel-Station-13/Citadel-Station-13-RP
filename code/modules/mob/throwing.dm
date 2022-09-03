/mob/proc/throw_item(atom/target)
	return

/mob/proc/toggle_throw_mode()
	if(throw_mode_check())
		throw_mode_off()
	else
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
