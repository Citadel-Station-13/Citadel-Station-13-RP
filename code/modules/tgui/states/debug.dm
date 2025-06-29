GLOBAL_DATUM_INIT(debug_state, /datum/ui_state/debug_state, new)

/datum/ui_state/debug_state/can_use_topic(datum/src_object, mob/user, datum/tgui/ui)
	if(check_rights_for(user.client, R_DEBUG))
		return UI_INTERACTIVE
	return UI_CLOSE
