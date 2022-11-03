/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	//blocks_emissive = FALSE
	var/processing = FALSE

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_range_on = 2
	var/light_power_on = 1
	var/overlay_layer

	clicksound = "keyboard"

/obj/machinery/computer/Initialize(mapload)
	overlay_layer = layer
	. = ..()
	power_change()
	update_icon()

/obj/machinery/computer/process(delta_time)
	if(machine_stat & (NOPOWER|BROKEN))
		return FALSE
	return TRUE

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken()
	..()

/obj/machinery/computer/blob_act()
	legacy_ex_act(2)

/obj/machinery/computer/update_icon()
	cut_overlays()

	. = list()

	// Connecty //TODO: Use TG Smoothing.
	if(initial(icon_state) == "computer")
		var/append_string = ""
		var/left = turn(dir, 90)
		var/right = turn(dir, -90)
		var/turf/L = get_step(src, left)
		var/turf/R = get_step(src, right)
		var/obj/machinery/computer/LC = locate() in L
		var/obj/machinery/computer/RC = locate() in R
		if(LC && LC.dir == dir && initial(LC.icon_state) == "computer")
			append_string += "_L"
		if(RC && RC.dir == dir && initial(RC.icon_state) == "computer")
			append_string += "_R"
		icon_state = "computer[append_string]"

	if(icon_keyboard)
		if(machine_stat & NOPOWER)
			playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
			return add_overlay("[icon_keyboard]_off")
		. += icon_keyboard

	// This whole block lets screens ignore lighting and be visible even in the darkest room
	var/overlay_state = icon_screen
	if(machine_stat & BROKEN)
		overlay_state = "[icon_state]_broken"
	. += mutable_appearance(icon, overlay_state)
	//. += emissive_appearance(icon, overlay_state)
	playsound(src, 'sound/machines/terminal_on.ogg', 50, 1)

	add_overlay(.)

/obj/machinery/computer/power_change()
	..()
	update_icon()
	if(machine_stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/computer/proc/set_broken()
	machine_stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		if(istype(I,/obj/item/gripper)) //Behold, Grippers and their horribleness. If ..() is called by any computers' attackby() now or in the future, this should let grippers work with them appropriately.
			var/obj/item/gripper/B = I	//B, for Borg.
			if(!B.get_item())
				to_chat(user, "\The [B] is not holding anything.")
				return
			else
				var/B_held = B.get_item()
				to_chat(user, "You use \the [B] to use \the [B_held] with \the [src].")
				playsound(src, "keyboard", 100, 1, 0)
				attackby(B.get_item(), user, params, clickchain_flags, damage_multiplier)
			return
		return ..()
