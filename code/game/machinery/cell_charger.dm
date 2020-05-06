/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 60000	//60 kW. (this the power drawn when charging)
	var/efficiency = 60000 //will provide the modified power rate when upgraded
	power_channel = EQUIP
	var/obj/item/cell/charging = null
	var/chargelevel = -1
	circuit = /obj/item/circuitboard/cell_charger

/obj/machinery/cell_charger/New()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)
	RefreshParts()
	..()
	return

/obj/machinery/cell_charger/update_icon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(stat & (BROKEN|NOPOWER)))

		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		//world << "nl: [newlevel]"

		if(chargelevel != newlevel)

			overlays.Cut()
			overlays += "ccharger-o[newlevel]"

			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine(mob/user)
	if(!..(user, 5))
		return

	to_chat(user, "[charging ? "[charging]" : "Nothing"] is in [src].")
	if(charging)
		to_chat(user, "Current charge: [charging.charge] / [charging.maxcharge]")

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(istype(W, /obj/item/cell/device))
			to_chat(user, "<span class='warning'>\The [src] isn't fitted for that type of cell.</span>")
			return
		if(charging)
			to_chat(user, "<span class='warning'>There is already [charging] in [src].</span>")
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, "<span class='warning'>\The [src] blinks red as you try to insert [W]!</span>")
				return

			user.drop_item()
			W.loc = src
			charging = W
			user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")
			chargelevel = -1
		update_icon()
	else if(W.is_wrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground.")
		playsound(src, W.usesound, 75, 1)
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
			charging.loc = src.loc
			charging.update_icon()
			charging = null
			update_icon()


/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/process()
	//world << "ccpt [charging] [stat]"
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
		return

	if(charging && !charging.fully_charged())
		charging.give(efficiency*CELLRATE)
		update_use_power(USE_POWER_ACTIVE)

		update_icon()
	else
		update_use_power(USE_POWER_IDLE)


/obj/machinery/cell_charger/RefreshParts()
	var/E = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = active_power_usage * (1+(E-1)*0.5) * 10

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
	matter = list(DEFAULT_WALL_MATERIAL = 4000,"glass" = 1000)

/obj/item/cell_charger_kit/attack_self(mob/user)
		to_chat(user, "<span class='notice'>You assemble and deploy the cell charger in place.</span>")
		playsound(user, 'sound/machines/click.ogg', 50, 1)
		var/obj/machinery/cell_charger/C = new(user.loc)
		C.add_fingerprint(user)
		qdel(src)