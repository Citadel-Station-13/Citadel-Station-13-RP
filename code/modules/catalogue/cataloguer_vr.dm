/obj/item/cataloguer/compact
	name = "compact cataloguer"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tricorder"
	action_button_name = "Toggle Cataloguer"
	var/deployed = TRUE
	scan_range = 1
	tool_speed = 1.2

/obj/item/cataloguer/compact/update_icon()
	if(busy)
		icon_state = "[initial(icon_state)]_s"
	else
		icon_state = initial(icon_state)

/obj/item/cataloguer/compact/ui_action_click()
	toggle()

/obj/item/cataloguer/compact/verb/toggle()
	set name = "Toggle Cataloguer"
	set category = "Object"

	if(busy)
		to_chat(usr, SPAN_WARNING( "\The [src] is currently scanning something."))
		return
	deployed = !(deployed)
	if(deployed)
		w_class = ITEMSIZE_NORMAL
		icon_state = "[initial(icon_state)]"
		to_chat(usr, SPAN_NOTICE("You flip open \the [src]."))
	else
		w_class = ITEMSIZE_SMALL
		icon_state = "[initial(icon_state)]_closed"
		to_chat(usr, SPAN_NOTICE("You close \the [src]."))

	if (ismob(usr))
		var/mob/M = usr
		M.update_action_buttons()

/obj/item/cataloguer/compact/afterattack(atom/target, mob/user, proximity_flag)
	if(!deployed)
		to_chat(user, SPAN_WARNING( "\The [src] is closed."))
		return
	return ..()

/obj/item/cataloguer/compact/pulse_scan(mob/user)
	if(!deployed)
		to_chat(user, SPAN_WARNING( "\The [src] is closed."))
		return
	return ..()

/obj/item/cataloguer/compact/pathfinder
	name = "pathfinder's cataloguer"
	icon_state = "tricorder_med"
	scan_range = 3
	tool_speed = 1
