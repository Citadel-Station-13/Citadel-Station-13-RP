/obj/machinery/portable_atmospherics/powered
	/// power rating in watts
	var/power_maximum = 7500
	/// power setting in watts
	var/power_setting
	/// power usage current
	var/power_current = 0

	/// efficiency multiplier
	var/efficiency_multiplier = 1

	var/last_power_draw_legacy = 0
	var/obj/item/cell/cell
	var/use_cell = TRUE
	var/removeable_cell = TRUE

/obj/machinery/portable_atmospherics/powered/Initialize(mapload)
	. = ..()
	if(isnull(power_setting))
		power_setting = power_maximum

/obj/machinery/portable_atmospherics/powered/process(delta_time)
	..()
	power_current = 0

/obj/machinery/portable_atmospherics/powered/powered()
	if(use_power) //using area power
		return ..()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/portable_atmospherics/powered/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["useCharge"] = TRUE
	.["maxCharge"] = isnull(cell)? 0 : cell.maxcharge
	.["powerRating"] = power_maximum
	.["useCell"] = use_cell

/obj/machinery/portable_atmospherics/powered/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["charge"] = isnull(cell)? 0 : cell.charge
	if(atmos_portable_ui_flags & (ATMOS_PORTABLE_UI_SEE_POWER | ATMOS_PORTABLE_UI_SET_POWER))
		.["powerCurrent"] = power_current
	.["hasCell"] = !isnull(cell)

/obj/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(use_cell && istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return

		var/obj/item/cell/C = I

		C.add_fingerprint(user)
		cell = C
		user.visible_message("<span class='notice'>[user] opens the panel on [src] and inserts [C].</span>", "<span class='notice'>You open the panel on [src] and insert [C].</span>")
		power_change()
		update_static_data()
		return

	if(I.is_screwdriver() && removeable_cell)
		if(!cell)
			to_chat(user, "<span class='warning'>There is no power cell installed.</span>")
			return

		user.visible_message("<span class='notice'>[user] opens the panel on [src] and removes [cell].</span>", "<span class='notice'>You open the panel on [src] and remove [cell].</span>")
		playsound(src, I.tool_sound, 50, 1)
		cell.add_fingerprint(user)
		cell.forceMove(drop_location())
		cell = null
		power_change()
		update_static_data()
		return
	..()

/obj/machinery/portable_atmospherics/powered/use_power(amount, chan, dt)
	if(!use_cell)
		return ..()
	else if(!cell)
		return 0
	. = cell.use(DYNAMIC_W_TO_CELL_UNITS(amount, dt))
	if(!cell.charge)
		power_change()
		update_icon()
