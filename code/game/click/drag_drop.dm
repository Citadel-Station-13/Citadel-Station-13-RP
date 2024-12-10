/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/

/atom/proc/CanMouseDrop(atom/over, var/mob/user = usr)
	if(!user || !over)
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE

/atom/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	// no clickdrag to self
	if(over_object == src)
		return
	// cache incase thsi somehow gets lost
	var/user = usr
	if(!user || !over_object)
		return

	// first check legacy behaviors - this one always runs
	// if it doesn't call parent skip everything else
	if(OnMouseDropLegacy(over_object, src_location, over_location, src_control, over_control, params) != -1)
		return

	// shit proximity check, refactor later
	var/proximity = usr.Reachability(src) && ((over_object == usr) || usr.Reachability(over_object))
	if(proximity)
		// this one only runs if the above pass. legacy behavior.
		if(over_object.MouseDroppedOnLegacy(src, user, params) & CLICKCHAIN_DO_NOT_PROPAGATE)
			return

	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over_object, user, proximity, params) & COMPONENT_NO_MOUSEDROP)
		return
	if(OnMouseDrop(over_object, user, proximity, params) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(SEND_SIGNAL(over_object, COMSIG_MOUSEDROPPED_ONTO, src, user, proximity, params) & COMPONENT_NO_MOUSEDROP)
		return
	over_object.MouseDroppedOn(src, user, proximity, params)

// todo: less shit naming convenions for these
// todo: just completely rework everything god damn mousedown / mousedrag / mousemove handling is ass

/**
 * user dropped us onto an atom mouse-drag-drop
 *
 * @params
 * - over - the atom that is being dropped onto us
 * - user - the person dropping it
 * - proximity - can we reach the thing?
 * - params - click params
 *
 * @return clickchain flags
 */
/atom/proc/OnMouseDrop(atom/over, mob/user, proximity, params)
	return NONE

/**
 * we were dropped onto over object
 * do not continue overriding this proc, use OnMouseDrop
 * base proc returns -1 to signal we should continue onto new procs
 * this is awful but whatever
 */
/atom/proc/OnMouseDropLegacy(atom/over_object, src_location, over_location, src_control, over_control, params)
	return -1

/**
 * user dropped an atom on us with mouse-drag-drop
 *
 * @params
 * - dropping - the atom that is being dropped onto us
 * - user - the person dropping it
 * - proximity - can we reach the thing?
 * - params - click params
 *
 * @return clickchain flags
 */
/atom/proc/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	return NONE

/**
 * user dropped an atom on us with mouse-drag-drop
 * legacy because this doesn't have checks for proximity param
 * do not continue overriding this
 */
/atom/proc/MouseDroppedOnLegacy(atom/dropping, mob/user, params)
	return

/client
	var/mouseParams = ""
	var/mouseLocation = null
	var/mouseObject = null
	var/mouseControlObject = null
	var/middragtime = 0
	var/atom/middragatom

/client/MouseDown(object, location, control, params)

/client/MouseUp(object, location, control, params)

//Please don't roast me too hard
/client/MouseMove(object,location,control,params)
	mouseParams = params
	mouseLocation = location
	mouseObject = object
	mouseControlObject = control
	..()

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	var/list/L = params2list(params)
	if (L["middle"])
		if (src_object && src_location != over_location)
			middragtime = world.time
			middragatom = src_object
		else
			middragtime = 0
			middragatom = null
	mouseParams = params
	mouseLocation = over_location
	mouseObject = over_object
	mouseControlObject = over_control

/client/MouseDrop(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if (middragatom == src_object)
		middragtime = 0
		middragatom = null
	..()
