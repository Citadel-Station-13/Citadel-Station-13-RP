/atom/proc/DefaultTopicState()
	return GLOB.default_state

/atom/Topic(href, href_list, var/datum/topic_state/state = default_state)
	if(usr && ..())
		return TRUE

	state = state || DefaultTopicState() || GLOB.default_state

	// In the far future no checks are made in an overriding Topic() beyond if(..()) return
	// Instead any such checks are made in CanUseTopic()
	if(CanUseTopic(usr, state, href_list) == UI_INTERACTIVE)
		CouldUseTopic(usr)
		return FALSE

	CouldNotUseTopic(usr)
	return TRUE

/obj/CanUseTopic(var/mob/user, var/datum/topic_state/state = default_state)
	if(user.CanUseObjTopic(src))
		return ..()
	to_chat(user, "<span class='danger'>[icon2html(thing = src, target = user)] Access Denied!</span>")
	return UI_CLOSE

/mob/living/silicon/CanUseObjTopic(var/obj/O)
	var/id = src.GetIdCard()
	return O.check_access(id)

/mob/proc/CanUseObjTopic()
	return TRUE

/atom/proc/CouldUseTopic(var/mob/user)
	var/atom/host = nano_host()
	host.add_hiddenprint(user)

/atom/proc/CouldNotUseTopic(var/mob/user)
	// Nada
