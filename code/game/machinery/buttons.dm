/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for something."
	var/id = null
	var/active = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	// todo: remove when this is constructible (and all its subtypes are)
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/button/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/button/attackby(obj/item/W, mob/user)
	return attack_hand(user)

/obj/machinery/button/attack_hand(obj/item/W, mob/user)
	if(..())
		return TRUE
	playsound(src, 'sound/machines/button.ogg', 100, TRUE)

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user, list/params)
	if (..())
		return TRUE
	else
		toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_appearance()

	for (var/obj/structure/window/reinforced/polarized/target_window in range(src, range))
		if (target_window.id == id || !target_window.id)
			INVOKE_ASYNC(target_window, TYPE_PROC_REF(/obj/structure/window/reinforced/polarized, toggle))

/obj/machinery/button/windowtint/power_change()
	..()
	if (active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon_state()
	. = ..()
	icon_state = "light[active]"

/obj/machinery/button/windowtint/attackby(obj/item/object, mob/user)
	if (istype(object, /obj/item/multitool))
		var/obj/item/multitool/MT = object
		if (!id)
			// If no ID is set yet (newly built button?) let them select an ID for first-time use!
			var/new_id = tgui_input_text(
				user = user,
				message = "Enter the ID for the window.",
				title = name,
			)
			if (new_id && user.get_active_held_item() != object && in_range(src, user))
				id = new_id
				to_chat(user, SPAN_NOTICE("The new ID of \the [src] is [id]"))
		if (id)
			// It already has an ID (or they just set one), buffer it for copying to windows.
			to_chat(user, SPAN_NOTICE("You store \the [src] in \the [MT]'s buffer!"))
			MT.connectable = src
			MT.update_appearance()
		return TRUE
	return ..()

/obj/machinery/button/windowtint/multitint
	name = "tint control"
	desc = "A remote control switch for polarized windows and doors."

/obj/machinery/button/windowtint/multitint/toggle_tint()
	use_power(5)
	active = !active
	update_icon()

	var/in_range = range(src,range)
	for(var/obj/structure/window/reinforced/polarized/W in in_range)
		if(W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
	for(var/obj/machinery/door/airlock/D in in_range)
		if(D.glass && (D.id_tint == src.id))
			spawn(0)
				D.toggle()
