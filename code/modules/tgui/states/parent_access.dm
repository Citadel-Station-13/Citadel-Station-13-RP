GLOBAL_DATUM_INIT(never_state, /datum/ui_state/never_state, new)

/datum/ui_state/never_state/can_use_topic(src_object, mob/user)
	return UI_CLOSE
/datum/ui_state/default/can_use_topic(src_object, mob/user)
	return user.default_can_use_topic(src_object) // Call the individual mob-overridden procs.
//i don't know if I'll use this
