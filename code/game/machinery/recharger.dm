/obj/machinery/recharger
	name = "recharger"
	desc = "A standard recharger for all devices that use power."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 40000	//10 kW
	var/efficiency = 10000 //will provide the modified power rate when upgraded
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/modular_computer, /obj/item/computer_hardware/battery_module, /obj/item/cell, /obj/item/flashlight, /obj/item/electronic_assembly, /obj/item/weldingtool/electric, /obj/item/ammo_magazine/smart, /obj/item/flash, /obj/item/ammo_casing/microbattery, /obj/item/shield_diffuser, /obj/item/ammo_magazine/cell_mag, /obj/item/gun/projectile/cell_loaded)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = TRUE
	/// base power draw
	var/base_power_draw = 20000
	circuit = /obj/item/circuitboard/recharger

/obj/machinery/recharger/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/recharger/examine(mob/user)
	. = ..()
	. += "<span class = 'notice'>[charging ? "[charging]" : "Nothing"] is in [src].</span>"
	if(charging)
		var/obj/item/cell/C = charging.get_cell()
		. += "<span class = 'notice'>Current charge: [C.charge] / [C.maxcharge]</span>"

/obj/machinery/recharger/attackby(obj/item/G, mob/user)
	var/allowed = FALSE
	for (var/allowed_type in allowed_devices)
		if(istype(G, allowed_type))
			allowed = TRUE

	if(allowed)
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>\The [src] blinks red as you try to insert [G]!</span>")
			return
		if(istype(G, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = G
			if(E.self_recharge)
				to_chat(user, "<span class='notice'>\The [E] has no recharge port.</span>")
				return
		else if(istype(G, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = G
			if(!C.battery_module)
				to_chat(user, "<span class='notice'>\The [C] does not have a battery installed. </span>")
				return
		else if(istype(G, /obj/item/melee/baton))
			var/obj/item/melee/baton/B = G
			if(B.use_external_power)
				to_chat(user, "<span class='notice'>\The [B] has no recharge port.</span>")
				return
		else if(istype(G, /obj/item/flash))
			var/obj/item/flash/F = G
			if(F.use_external_power)
				to_chat(user, "<span class='notice'>\The [F] has no recharge port.</span>")
				return
		else if(istype(G, /obj/item/weldingtool/electric))
			var/obj/item/weldingtool/electric/EW = G
			if(EW.use_external_power)
				to_chat(user, "<span class='notice'>\The [EW] has no recharge port.</span>")
				return
		else if(istype(G, /obj/item/ammo_magazine/cell_mag))
			var/obj/item/ammo_magazine/cell_mag/maggy = G
			if(maggy.stored_ammo.len < 1)
				to_chat(user, "\The [G] does not have any cells installed.")
				return
		else if(istype(G, /obj/item/gun/projectile/cell_loaded))
			var/obj/item/gun/projectile/cell_loaded/gunny = G
			if(gunny.ammo_magazine)
				var/obj/item/ammo_magazine/cell_mag/maggy = gunny.ammo_magazine
				if(maggy.stored_ammo.len < 1)
					to_chat(user, "\The [G] does not have any cell in its magazine installed.")
					return
			else
				to_chat(user, "\The [G] does not have a magazine installed..")
				return

		if(!user.attempt_insert_item_for_installation(G, src))
			return
		charging = G
		update_icon()
		user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")

	else if(portable && G.is_wrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] [src].")
		playsound(loc, G.tool_sound, 75, 1)
	else if(default_deconstruction_screwdriver(user, G))
		return
	else if(default_deconstruction_crowbar(user, G))
		return
	else if(default_part_replacement(user, G))
		return

/obj/machinery/recharger/attack_hand(mob/user)
	if(istype(user,/mob/living/silicon))
		return

	..()

	if(charging)
		user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(charging)
			user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
			charging.update_icon()
			charging.loc = src.loc
			charging = null
			update_icon()

/obj/machinery/recharger/process(delta_time)
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(USE_POWER_OFF)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(USE_POWER_IDLE)
		icon_state = icon_state_idle
	else
		if(istype(charging, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = charging
			if(!C.battery_module.battery.fully_charged())
				icon_state = icon_state_charging
				C.battery_module.battery.give(DYNAMIC_W_TO_CELL_UNITS(efficiency, 1))
				update_use_power(USE_POWER_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)
			return
		else if(istype(charging, /obj/item/computer_hardware/battery_module))
			var/obj/item/computer_hardware/battery_module/BM = charging
			if(!BM.battery.fully_charged())
				icon_state = icon_state_charging
				BM.battery.give(DYNAMIC_W_TO_CELL_UNITS(efficiency, 1))
				update_use_power(USE_POWER_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)
			return

		var/obj/item/cell/C = charging.get_cell()
		if(istype(C))
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(DYNAMIC_W_TO_CELL_UNITS(efficiency, 1))
				update_use_power(USE_POWER_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)

		// NSFW Batteries
		else if(istype(charging, /obj/item/ammo_casing/microbattery))
			var/obj/item/ammo_casing/microbattery/batt = charging
			if(batt.shots_left >= initial(batt.shots_left))
				batt.shots_left = initial(batt.shots_left)
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)
			else
				icon_state = icon_state_charging
				batt.shots_left++
				update_use_power(USE_POWER_ACTIVE)
			return

		else if(istype(charging, /obj/item/ammo_magazine/cell_mag))
			charge_mag(charging)

		else if(istype(charging, /obj/item/gun/projectile/cell_loaded))
			var/obj/item/gun/projectile/cell_loaded/gunny = charging
			charge_mag(gunny.ammo_magazine)

/obj/machinery/recharger/proc/charge_mag(obj/item/ammo_magazine/cell_mag/maggy)
	var/tally = maggy.stored_ammo.len
	for(var/obj/item/ammo_casing/microbattery/batt in maggy)
		if(batt.shots_left < initial(batt.shots_left))
			icon_state = icon_state_charging
			batt.shots_left++
			update_use_power(USE_POWER_ACTIVE)
		else
			tally -= 1
			if(tally == 0)
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)

/obj/machinery/recharger/emp_act(severity)
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(charging)
		var/obj/item/cell/C = charging.get_cell()
		if(istype(C))
			C.emp_act(severity)

	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/RefreshParts()
	var/E = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating
	update_active_power_usage(base_power_draw * E)
	efficiency = active_power_usage * RECHARGER_CHEAT_FACTOR

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A more powerful recharger designed for energy weapons."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	base_power_draw = 30000
	allowed_devices = list(/obj/item/gun/energy, /obj/item/gun/magnetic, /obj/item/melee/baton, /obj/item/flashlight, /obj/item/cell/device, /obj/item/ammo_casing/microbattery, /obj/item/ammo_magazine/cell_mag, /obj/item/gun/projectile/cell_loaded)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	circuit = /obj/item/circuitboard/recharger/wrecharger
