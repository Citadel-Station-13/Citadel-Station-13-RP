/*
	This state only checks if user is conscious.
*/
/var/global/datum/topic_state/conscious_state/conscious_state = new()

/datum/topic_state/conscious_state/can_use_topic(src_object, mob/user)
	return user.stat == CONSCIOUS ? UI_INTERACTIVE : UI_CLOSE
