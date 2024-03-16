/*
	This state checks that the src_object is the same the as user
*/
/var/global/datum/topic_state/self_state/self_state = new()

/datum/topic_state/self_state/can_use_topic(src_object, mob/user)
	if(src_object != user)
		return UI_CLOSE
	return user.shared_nano_interaction()
