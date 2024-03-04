/obj/item/computer_hardware/recharger
	critical = 1
	enabled = 1
	var/charge_rate = 100
	device_type = MC_CHARGE

/obj/item/computer_hardware/recharger/proc/use_power(amount, charging=0)
	if(charging)
		return TRUE
	return FALSE

/obj/item/computer_hardware/recharger/process()
	..()
	var/obj/item/computer_hardware/battery/battery_module = holder.all_components[MC_CELL]
	if(!holder || !battery_module || !battery_module.battery)
		return

	var/obj/item/cell/cell = battery_module.battery
	if(cell.charge >= cell.maxcharge)
		return

	if(use_power(charge_rate, charging=1))
		holder.give_power(charge_rate * GLOB.cellrate)

/obj/item/computer_hardware/recharger/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	icon_state = "teslalink"
	w_class = WEIGHT_CLASS_TINY
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)

/obj/item/computer_hardware/recharger/tesla_link/use_power(amount, charging=0)
	if(ismachinery(holder.physical))
		var/obj/machinery/M = holder.physical
		if(M.powered())
			M.use_power(amount)
			return TRUE

	else
		var/area/A = get_area(src)
		if(!istype(A))
			return FALSE

		if(A.powered(EQUIP))
			A.use_power_oneoff(amount, EQUIP)
			return TRUE
	return FALSE

// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/computer_hardware/recharger/lambda
	name = "lambda coil"
	desc = "A very complex device that draws power from its own bluespace dimension."
	icon_state = "charger_lambda"
	w_class = WEIGHT_CLASS_TINY
	charge_rate = 100000

/obj/item/computer_hardware/recharger/lambda/use_power(amount, charging=0)
	return TRUE
