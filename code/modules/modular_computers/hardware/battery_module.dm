/obj/item/computer_hardware/battery
	name = "power cell controller"
	desc = "A charge controller for standard power cells, used in all kinds of modular computers."
	icon_state = "cell_con"
	#warn fixme cell icon state
	critical = TRUE
	malfunction_probability = 1
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	var/obj/item/cell/battery
	device_type = MC_CELL

/obj/item/computer_hardware/battery/get_cell()
	return battery

/obj/item/computer_hardware/battery/Initialize(mapload, battery_type)
	. = ..()
	if(battery_type)
		battery = new battery_type(src)

/obj/item/computer_hardware/battery/Destroy()
	battery = null
	return ..()

///What happens when the battery is removed (or deleted) from the module, through try_eject() or not.
/obj/item/computer_hardware/battery/Exited(atom/movable/gone, direction)
	if(battery == gone)
		battery = null
		if(holder?.enabled && !holder.use_power())
			holder.shutdown_computer()
	return ..()

/obj/item/computer_hardware/battery/try_insert(obj/item/I, mob/living/user = null)
	if(!holder)
		return FALSE

	if(!istype(I, /obj/item/cell))
		return FALSE

	if(battery)
		to_chat(user, SPAN_WARNING("You try to connect \the [I] to \the [src], but its connectors are occupied."))
		return FALSE

	if(I.w_class > holder.max_hardware_size)
		to_chat(user, SPAN_WARNING("This power cell is too large for \the [holder]!"))
		return FALSE

	if(user && !user.transfer_item_to_loc(I, src))
		return FALSE

	battery = I
	to_chat(user, SPAN_NOTICE("You connect \the [I] to \the [src]."))

	return TRUE

/obj/item/computer_hardware/battery/try_eject(mob/living/user, forced = FALSE)
	if(!battery)
		to_chat(user, SPAN_WARNING("There is no power cell connected to \the [src]."))
		return FALSE
	else
		if(user)
			user.put_in_hands(battery)
			to_chat(user, SPAN_NOTICE("You detach \the [battery] from \the [src]."))
		else
			battery.forceMove(drop_location())
		return TRUE

/obj/item/cell/computer
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. It's rating is 750."
	icon = 'icons/obj/modular_components.dmi'
	icon_state = "battery_normal"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	w_class = WEIGHT_CLASS_TINY
	maxcharge = 750

/obj/item/cell/computer/advanced
	name = "advanced battery"
	desc = "An advanced power cell, often used in most laptops. It is too large to be fitted into smaller devices. It's rating is 1100."
	icon_state = "battery_advanced"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 1500

/obj/item/cell/computer/super
	name = "super battery"
	desc = "A very advanced power cell, often used in high-end devices, or as uninterruptable power supply for important consoles or servers. It's rating is 1500."
	icon_state = "battery_super"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 2000

/obj/item/cell/computer/ultra
	name = "ultra battery"
	desc = "A very advanced large power cell. It's often used as uninterruptable power supply for critical consoles or servers. It's rating is 2000."
	icon_state = "battery_ultra"
	origin_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	w_class = WEIGHT_CLASS_SMALL
	maxcharge = 2500

/obj/item/cell/computer/micro
	name = "micro battery"
	desc = "A small power cell, commonly seen in most portable microcomputers. It's rating is 500."
	icon_state = "battery_micro"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	maxcharge = 500

/obj/item/cell/computer/nano
	name = "nano battery"
	desc = "A tiny power cell, commonly seen in low-end portable microcomputers. It's rating is 300."
	icon_state = "battery_nano"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	maxcharge = 300
