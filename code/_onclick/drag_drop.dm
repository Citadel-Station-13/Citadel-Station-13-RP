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
	SHOULD_NOT_OVERRIDE(TRUE)
	// cache incase thsi somehow gets lost
	var/user = usr
	if(!user || !over_object)
		return

	// first check legacy behaviors - this one always runs
	// if it doesn't call parent skip everything else
	if(OnMouseDropLegacy(over_object, src_location, over_location, src_control, over_control, params) != -1)
		return

	// shit proximity check, refactor later
	var/proximity = Adjacent(usr) && over_object.Adjacent(usr)
	if(proximity)
		// this one only runs if the above pass. legacy behavior.
		over_object.MouseDroppedOnLegacy(src, user, params)

	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over_object, user, proximity, params) & COMPONENT_NO_MOUSEDROP)
		return
	if(OnMouseDrop(over_object, user, proximity, params) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(SEND_SIGNAL(over_object, COMSIG_MOUSEDROPPED_ONTO, src, user, proximity, params) & COMPONENT_NO_MOUSEDROP)
		return
	over_object.MouseDroppedOn(src, user, params)

// todo: less shit naming convenions for these

/**
 * user dropped us onto an atom mouse-drag-drop
 *
 * @params
 * - over - the atom that is being dropped onto us
 * - user - the person dropping it
 * - proximity - can we reach the thing?
 * - params - click params
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
	var/list/atom/selected_target[2]
	var/obj/item/active_mousedown_item = null
	var/mouseParams = ""
	var/mouseLocation = null
	var/mouseObject = null
	var/mouseControlObject = null
	var/middragtime = 0
	var/atom/middragatom

/client/MouseDown(object, location, control, params)
	/*
	if (mouse_down_icon)
		mouse_pointer_icon = mouse_down_icon
	*/
	var/delay = mob.CanMobAutoclick(object, location, params)
	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)
	active_mousedown_item = mob.canMobMousedown(object, location, params)
	if(active_mousedown_item)
		active_mousedown_item.onMouseDown(object, location, params, mob)

/client/MouseUp(object, location, control, params)
	/*
	if (mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	*/
	selected_target[1] = null
	if(active_mousedown_item)
		active_mousedown_item.onMouseUp(object, location, params, mob)
		active_mousedown_item = null

/mob/proc/CanMobAutoclick(object, location, params)

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_held_item()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/mob/proc/canMobMousedown(atom/object, location, params)

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	var/obj/item/H = get_active_held_item()
	if(H)
		. = H.canItemMouseDown(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)

/obj/item/proc/canItemMouseDown(object, location, params)
	if(canMouseDown)
		return src

/obj/item/proc/onMouseDown(object, location, params, mob)
	return

/obj/item/proc/onMouseUp(object, location, params, mob)
	return

/obj/item
	var/canMouseDown = FALSE

/obj/item/gun
	var/automatic = 0 //can gun use it, 0 is no, anything above 0 is the delay between clicks in ds

/obj/item/gun/CanItemAutoclick(object, location, params)
	. = automatic

/atom/proc/IsAutoclickable()
	. = 1

/atom/movable/screen/IsAutoclickable()
	. = 0

/atom/movable/screen/click_catcher/IsAutoclickable()
	. = 1

//Please don't roast me too hard
/client/MouseMove(object,location,control,params)
	mouseParams = params
	mouseLocation = location
	mouseObject = object
	mouseControlObject = control
	/*
	if(mob && LAZYLEN(mob.mousemove_intercept_objects))
		for(var/datum/D in mob.mousemove_intercept_objects)
			D.onMouseMove(object, location, control, params)
	*/
	if(!show_popup_menus && mob)	//CIT CHANGE - passes onmousemove() to mobs
		mob.onMouseMove(object, location, control, params)	//CIT CHANGE - ditto
	..()

/datum/proc/onMouseMove(object, location, control, params)
	return

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
	if(selected_target[1] && over_object && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params
	if(active_mousedown_item)
		active_mousedown_item.onMouseDrag(src_object, over_object, src_location, over_location, params, mob)


/obj/item/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return

/client/MouseDrop(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if (middragatom == src_object)
		middragtime = 0
		middragatom = null
	..()
