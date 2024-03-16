/*
	This state always returns UI_INTERACTIVE
*/
/var/global/datum/topic_state/interactive/interactive_state = new()

/datum/topic_state/interactive/can_use_topic(src_object, mob/user)
	return UI_INTERACTIVE
