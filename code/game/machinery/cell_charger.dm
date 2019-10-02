/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 60000	//60 kW. (this the power drawn when charging)
	power_channel = EQUIP
	var/obj/item/weapon/cell/charging = null
	var/chargelevel = -1

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

	user << "There's [charging ? "a" : "no"] cell in the charger."
	if(charging)
		user << "Current charge: [charging.charge]"

/obj/machinery/cell_charger/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/weapon/cell) && anchored)
		if(istype(W, /obj/item/weapon/cell/device))
			user << "<span class='warning'> The charger isn't fitted for that type of cell.</span>"
			return
		if(charging)
			user << "<span class='warning'>There is already a cell in the charger.</span>"
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				user << "<span class='warning'>The [name] blinks red as you try to insert the cell!</span>"
				return

			user.drop_item()
			W.loc = src
			charging = W
			user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
			chargelevel = -1
		update_icon()
	else if(W.is_wrench())
		if(charging)
			user << "<span class='warning'>Remove the cell first!</span>"
			return

		anchored = !anchored
		user << "You [anchored ? "attach" : "detach"] the cell charger [anchored ? "to" : "from"] the ground"
		playsound(src, W.usesound, 75, 1)

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.update_icon()

		charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		update_icon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(!charging)
			return

		charging.loc = src.loc
		charging.update_icon()
		charging = null
		update_icon()
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")


/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/process()
	//world << "ccpt [charging] [stat]"
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(0)
		return

	if(charging && !charging.fully_charged())
		charging.give(active_power_usage*CELLRATE)
		update_use_power(2)

		update_icon()
	else
		update_use_power(1)
//cit change starts
/obj/item/cell_charger_kit
	name = "cell charger kit"
	desc = "A box with the parts for a heavy-duty cell charger inside of it. Use it in-hand to deploy a cell charger."
	icon = 'modular_citadel/icons/obj/storage.dmi'
	icon_state = "box"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
		)
	item_state = "syringe_kit"
	w_class = ITEMSIZE_NORMAL
	matter = list(MATERIAL_ID_STEEL = 4000,MATERIAL_ID_GLASS = 1000)

/obj/item/cell_charger_kit/attack_self(mob/user)
		to_chat(user, "<span class='notice'>You assemble and deploy the cell charger in place.</span>")
		playsound(user, 'sound/machines/click.ogg', 50, 1)
		var/obj/machinery/cell_charger/C = new(user.loc)
		C.add_fingerprint(user)
		qdel(src)