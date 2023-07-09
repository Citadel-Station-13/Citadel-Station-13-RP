/obj/item/stock_parts/computer/drive_slot
	name = "removable drive slot"
	desc = "Slot that allows this computer to accept removable drives."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	var/obj/item/stock_parts/computer/hard_drive/portable/stored_drive = null

/obj/item/stock_parts/computer/drive_slot/diagnostics()
	. = ..()
	. += "[name] status: [stored_drive ? "Drive Inserted" : "Drive Not Present"]\n"

/obj/item/stock_parts/computer/drive_slot/proc/eject_drive(mob/user)
	if(!stored_drive)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_drive] from [src].")
		user.put_in_hands(stored_drive)
	else
		dropInto(loc)
	stored_drive = null

	return TRUE

/obj/item/stock_parts/computer/drive_slot/proc/insert_drive(var/obj/item/stock_parts/computer/hard_drive/portable/I, mob/user)
	if(!istype(I))
		return FALSE

	if(stored_drive)
		to_chat(user, "You try to insert [I] into [src], but its portable drive slot is occupied.")
		return FALSE

	if(user && !user.transfer_item_to_loc(I, src, user=user))
		return FALSE

	stored_drive = I
	to_chat(user, "You insert [I] into [src].")
	if(isobj(loc))
		holder2.update_verbs()
	return TRUE

/obj/item/stock_parts/computer/drive_slot/attackby(obj/item/stock_parts/computer/hard_drive/portable/I, mob/user)
	if(!istype(I))
		return
	insert_drive(I, user)
	return TRUE

/obj/item/stock_parts/computer/drive_slot/Destroy()
	if(stored_drive)
		QDEL_NULL(stored_drive)
	return ..()
