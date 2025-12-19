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

	var/use_cell = TRUE
	var/removeable_cell = TRUE

	var/cell_type = /obj/item/cell/basic/tier_1/medium
	var/cell_accept = CELL_TYPE_MEDIUM | CELL_TYPE_SMALL | CELL_TYPE_WEAPON | CELL_TYPE_LARGE

/obj/machinery/portable_atmospherics/powered/Initialize(mapload)
	. = ..()
	if(use_cell)
		init_cell_slot_easy_machine(cell_type, cell_accept)
	if(isnull(power_setting))
		power_setting = power_maximum

/obj/machinery/portable_atmospherics/powered/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot, silent, datum/event_args/actor/actor)
	return removeable_cell && ..()

/obj/machinery/portable_atmospherics/powered/object_cell_slot_removed(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	power_change()
	update_static_data()

/obj/machinery/portable_atmospherics/powered/object_cell_slot_inserted(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	power_change()
	update_static_data()

/obj/machinery/portable_atmospherics/powered/process(delta_time)
	..()
	power_current = 0

/obj/machinery/portable_atmospherics/powered/powered()
	var/obj/item/cell/cell = obj_cell_slot?.cell
	if(use_power) //using area power
		return ..()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/portable_atmospherics/powered/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/item/cell/cell = obj_cell_slot?.cell
	.["useCharge"] = TRUE
	.["maxCharge"] = isnull(cell)? 0 : cell.max_charge
	.["powerRating"] = power_maximum
	.["useCell"] = use_cell

/obj/machinery/portable_atmospherics/powered/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	var/obj/item/cell/cell = obj_cell_slot?.cell
	.["charge"] = isnull(cell)? 0 : cell.charge
	if(atmos_portable_ui_flags & (ATMOS_PORTABLE_UI_SEE_POWER | ATMOS_PORTABLE_UI_SET_POWER))
		.["powerCurrent"] = power_current
	.["hasCell"] = !isnull(cell)

/obj/machinery/portable_atmospherics/powered/use_power(amount, chan, dt)
	var/obj/item/cell/cell = obj_cell_slot?.cell
	if(!use_cell)
		return ..()
	else if(!cell)
		return 0
	. = cell.use(DYNAMIC_W_TO_CELL_UNITS(amount, dt))
	if(!cell.charge)
		power_change()
		update_icon()
