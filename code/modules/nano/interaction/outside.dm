/var/global/datum/topic_state/default/outside/outside_state = new()

/datum/topic_state/default/outside/can_use_topic(src_object, mob/user)
	if(user in src_object)
		return UI_CLOSE
	return ..()
