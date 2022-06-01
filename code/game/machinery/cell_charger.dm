/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	power_channel = EQUIP
	idle_power_usage = 5
	active_power_usage = 30000 //60 kW. (this the power drawn when charging)
	/// Will provide the modified power rate when upgraded.
	var/efficiency = 30000
	/// base power draw
	var/base_power_draw = 50000
	var/chargelevel = -1
	var/obj/item/cell/charging = null
	circuit = /obj/item/circuitboard/cell_charger

/obj/machinery/cell_charger/Initialize(mapload, newdir)
	. = ..()
	default_apply_parts()

/obj/machinery/cell_charger/update_icon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(machine_stat & (BROKEN|NOPOWER)))

		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		//to_chat(world, "nl: [newlevel]")

		if(chargelevel != newlevel)

			cut_overlays()
			add_overlay("ccharger-o[newlevel]")

			chargelevel = newlevel
	else
		cut_overlays()

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("[charging ? "[charging]" : "Nothing"] is in [src].")
	if(charging)
		. += SPAN_NOTICE("Current charge: [charging.charge] / [charging.maxcharge]")

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(machine_stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(istype(W, /obj/item/cell/device))
			to_chat(user, SPAN_WARNING("\The [src] isn't fitted for that type of cell."))
			return

		if(charging)
			to_chat(user, SPAN_WARNING("There is already [charging] in [src]."))
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, SPAN_WARNING("\The [src] blinks red as you try to insert [W]!"))
				return

			user.drop_item()
			W.loc = src
			charging = W
			user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")
			chargelevel = -1
		update_icon()
	else if(W.is_wrench())
		if(charging)
			to_chat(user, SPAN_WARNING("Remove [charging] first!"))
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground.")
		playsound(src, W.usesound, 75, TRUE)

	else if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

/obj/machinery/cell_charger/attack_hand(mob/user)
	add_fingerprint(user)

	if(charging)
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.update_icon()
		user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
		charging = null
		chargelevel = -1
		update_icon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(charging)
			user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
			charging.forceMove(loc)
			charging.update_icon()
			charging = null
			update_icon()

/obj/machinery/cell_charger/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/process(delta_time)
	if((machine_stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
		return

	if(charging && !charging.fully_charged())
		charging.give(DYNAMIC_W_TO_CELL_UNITS(efficiency, 1))
		update_use_power(USE_POWER_ACTIVE)

		update_icon()
	else
		update_use_power(USE_POWER_IDLE)


/obj/machinery/cell_charger/RefreshParts()
	var/E = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating
	update_active_power_usage(base_power_draw * E)
	efficiency = active_power_usage * RECHARGER_CHEAT_FACTOR

//cit change starts
/obj/item/cell_charger_kit
	name = "cell charger kit"
	desc = "A box with the parts for a heavy-duty cell charger inside of it. Use it in-hand to deploy a cell charger."
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
		)
	item_state = "syringe_kit"
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 4000, MAT_GLASS = 1000)

/obj/item/cell_charger_kit/attack_self(mob/user)
		to_chat(user, SPAN_NOTICE("You assemble and deploy the cell charger in place."))
		playsound(user, 'sound/machines/click.ogg', 50, TRUE)
		var/obj/machinery/cell_charger/C = new(user.loc)
		C.add_fingerprint(user)
		qdel(src)
