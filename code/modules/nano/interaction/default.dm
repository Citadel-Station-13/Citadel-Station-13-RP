/var/global/datum/topic_state/default/default_state = new()

/datum/topic_state/default/href_list(var/mob/user)
	return list()

/datum/topic_state/default/can_use_topic(var/src_object, var/mob/user)
	return user.nano_default_can_use_topic(src_object)

/mob/proc/nano_default_can_use_topic(var/src_object)
	return UI_CLOSE // By default no mob can do anything with NanoUI

/mob/observer/dead/nano_default_can_use_topic(var/src_object)
	if(can_admin_interact())
		return UI_INTERACTIVE							// Admins are more equal
	if(!client || get_dist(src_object, src)	> client.view)	// Preventing ghosts from having a million windows open by limiting to objects in range
		return UI_CLOSE
	return UI_UPDATE									// Ghosts can view updates

/mob/living/silicon/pai/nano_default_can_use_topic(var/src_object)
	if((src_object == src || src_object == radio || src_object == communicator) && !stat)
		return UI_INTERACTIVE
	else
		return ..()

/mob/living/silicon/robot/nano_default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. <= UI_DISABLED)
		return

	// robots can interact with things they can see within their view range
	if((src_object in view(src)) && get_dist(src_object, src) <= src.client.view)
		return UI_INTERACTIVE	// interactive (green visibility)
	return UI_DISABLED			// no updates, completely disabled (red visibility)

/mob/living/silicon/ai/nano_default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. != UI_INTERACTIVE)
		return

	// Prevents the AI from using Topic on admin levels (by for example viewing through the court/thunderdome cameras)
	// unless it's on the same level as the object it's interacting with.
	var/turf/T = get_turf(src_object)
	if(!T || !(z == T.z || (T.z in GLOB.using_map.player_levels)))
		return UI_CLOSE

	// If an object is in view then we can interact with it
	if(src_object in view(client.view, src))
		return UI_INTERACTIVE

	// If we're installed in a chassi, rather than transfered to an inteliCard or other container, then check if we have camera view
	if(is_in_chassis())
		//stop AIs from leaving windows open and using then after they lose vision
		if(GLOB.cameranet && !GLOB.cameranet.checkTurfVis(get_turf(src_object)))
			return UI_CLOSE
		return UI_INTERACTIVE
	else if(get_dist(src_object, src) <= client.view)	// View does not return what one would expect while installed in an inteliCard
		return UI_INTERACTIVE

	return UI_CLOSE

//Some atoms such as vehicles might have special rules for how mobs inside them interact with NanoUI.
/atom/proc/contents_nano_distance(var/src_object, var/mob/living/user)
	return user.shared_living_nano_distance(src_object)

/mob/living/proc/shared_living_nano_distance(var/atom/movable/src_object)
	if (!(src_object in view(4, src))) 	// If the src object is not in visable, disable updates
		return UI_CLOSE

	var/dist = get_dist(src_object, src)
	if (dist <= 1)
		return UI_INTERACTIVE	// interactive (green visibility)
	else if (dist <= 2)
		return UI_UPDATE 		// update only (orange visibility)
	else if (dist <= 4)
		return UI_DISABLED 		// no updates, completely disabled (red visibility)
	return UI_CLOSE

/mob/living/nano_default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != UI_CLOSE)
		if(loc)
			. = min(., loc.contents_nano_distance(src_object, src))
/*
	if(UI_INTERACTIVE)
		return UI_UPDATE
*/

/mob/living/carbon/human/nano_default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != UI_CLOSE)
		. = min(., shared_living_nano_distance(src_object))
		if(. == UI_UPDATE && (TK in mutations))	// If we have telekinesis and remain close enough, allow interaction.
			return UI_INTERACTIVE
