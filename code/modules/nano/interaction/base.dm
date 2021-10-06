/datum/proc/nano_host()
	return src

/datum/proc/nano_container()
	return src

/datum/proc/CanUseTopic(var/mob/user, var/datum/topic_state/state)
	var/src_object = nano_host()
	if(IsAdminGhost(user))
		return UI_INTERACTIVE
	return state.can_use_topic(src_object, user)

/datum/topic_state/proc/href_list(var/mob/user)
	return list()

/datum/topic_state/proc/can_use_topic(var/src_object, var/mob/user)
	return UI_CLOSE

/mob/proc/shared_nano_interaction()
	if (src.stat || !client)
		return UI_CLOSE						// no updates, close the interface
	else if (incapacitated())
		return UI_UPDATE					// update only (orange visibility)
	return UI_INTERACTIVE

/mob/living/silicon/ai/shared_nano_interaction()
	if(lacks_power())
		return UI_CLOSE
	if (check_unable(1, 0))
		return UI_CLOSE
	return ..()

/mob/living/silicon/robot/shared_nano_interaction()
	. = UI_INTERACTIVE
	if(!has_power)
		return UI_CLOSE
	if(lockdown)
		. = UI_DISABLED
	return min(., ..())
