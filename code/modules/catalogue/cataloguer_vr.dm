/obj/item/cataloguer/compact
	name = "compact cataloguer"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tricorder"
	item_action_name = "Toggle Cataloguer"
	var/deployed = TRUE
	scan_range = 1
	tool_speed = 1.2
	// we do our own, sorry!
	snowflake_dont_update_icon_state = TRUE

/obj/item/cataloguer/compact/update_icon_state()
	var/base_state = base_icon_state || initial(icon_state)
	if(!deployed)
		icon_state = "[base_state]_closed"
	else if(busy)
		icon_state = "[base_state]_s"
	else
		icon_state = base_state
	return ..()

/obj/item/cataloguer/compact/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	toggle()

/obj/item/cataloguer/compact/verb/toggle()
	set name = "Toggle Cataloguer"
	set category = VERB_CATEGORY_OBJECT
	set src in usr

	if(busy)
		to_chat(usr, SPAN_WARNING( "\The [src] is currently scanning something."))
		return
	deployed = !(deployed)
	if(deployed)
		set_weight_class(WEIGHT_CLASS_NORMAL)
		to_chat(usr, SPAN_NOTICE("You flip open \the [src]."))
	else
		set_weight_class(WEIGHT_CLASS_SMALL)
		to_chat(usr, SPAN_NOTICE("You close \the [src]."))

	update_full_icon()

/obj/item/cataloguer/compact/afterattack(atom/target, mob/user, clickchain_flags, list/params)
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
