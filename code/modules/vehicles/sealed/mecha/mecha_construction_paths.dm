/datum/construction/mecha

/datum/construction/mecha/custom_action(step, obj/item/I, mob/user)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.is_wrench())
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(I.is_screwdriver())
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(I.is_wirecutter())
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There's not enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/mecha

/datum/construction/reversible/mecha/custom_action(index as num, diff as num, obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.is_wrench())
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(I.is_screwdriver())
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(I.is_wirecutter())
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There's not enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1
