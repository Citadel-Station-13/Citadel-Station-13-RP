/obj/item/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers"
	description_info = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the floor mounted variant does. It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
	w_class = ITEMSIZE_SMALL
	var/obj/item/cell/device/cell = /obj/item/cell/device
	var/enabled = 0


/obj/item/shield_diffuser/Initialize(mapload)
	. = ..()
	if(cell)
		cell = new cell(src)

/obj/item/shield_diffuser/Destroy()
	QDEL_NULL(cell)
	if(enabled)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/shield_diffuser/get_cell()
	return cell

/obj/item/shield_diffuser/process()
	if(!enabled)
		return

	for(var/direction in GLOB.cardinals)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/energy_field/S in shielded_tile)
			if(istype(S) && cell.checked_use(10 KILOWATTS * CELLRATE))
				qdel(S)

/obj/item/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/shield_diffuser/attack_self()
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/shield_diffuser/examine()
	. = ..()
	to_chat(usr, "The charge meter reads [cell ? cell.percent() : 0]%")
	to_chat(usr, "It is [enabled ? "enabled" : "disabled"].")

/obj/item/shield_diffuser/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			enabled = 0
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/shield_diffuser/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/cell))
		if(istype(W, /obj/item/cell/device))
			if(!cell)
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
				playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
				update_icon()
			else
				to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] cannot use that type of cell.</span>")