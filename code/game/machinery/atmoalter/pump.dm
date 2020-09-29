/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "psiphon:0"
	density = 1
	w_class = ITEMSIZE_NORMAL

	var/on = 0
	var/direction_out = 0 //0 = siphoning, 1 = releasing
	var/target_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = 10 * ONE_ATMOSPHERE

	volume = 1000

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/powered/pump/New()
	..()
	cell = new/obj/item/cell/apc(src)

	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(/datum/gas/oxygen, air_mix[/datum/gas/oxygen], /datum/gas/nitrogen, air_mix[/datum/gas/nitrogen])

/obj/machinery/portable_atmospherics/powered/pump/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holding)
		overlays += "siphon-open"

	if(connected_port)
		overlays += "siphon-connector"

	return

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on

	if(prob(100/severity))
		direction_out = !direction_out

	target_pressure = rand(0,1300)
	update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/pump/process()
	..()
	var/power_draw = -1

	if(on && cell && cell.charge)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/pressure_delta
		var/output_volume
		var/air_temperature
		if(direction_out)
			pressure_delta = target_pressure - environment.return_pressure()
			output_volume = environment.volume * environment.group_multiplier
			air_temperature = environment.temperature? environment.temperature : air_contents.temperature
		else
			pressure_delta = environment.return_pressure() - target_pressure
			output_volume = air_contents.volume * air_contents.group_multiplier
			air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

		if (pressure_delta > 0.01)
			if (direction_out)
				power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
			else
				power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge)
			power_change()
			update_icon()

	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/pump/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/pump/attack_ai(var/mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_ghost(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1)
	var/list/data[0]
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["targetpressure"] = round(target_pressure)
	data["pump_dir"] = direction_out
	data["minpressure"] = round(pressuremin)
	data["maxpressure"] = round(pressuremax)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = on ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portpump.tmpl", "Portable Pump", 480, 410, state = physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/powered/pump/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["power"])
		on = !on
		. = 1
	if(href_list["direction"])
		direction_out = !direction_out
		. = 1
	if (href_list["remove_tank"])
		if(holding)
			holding.loc = loc
			holding = null
		. = 1
	if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		target_pressure = min(10*ONE_ATMOSPHERE, max(0, target_pressure+diff))
		. = 1

	if(.)
		update_icon()

/obj/machinery/portable_atmospherics/powered/pump/huge
	name = "Huge Air Pump"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "siphon:0"
	anchored = 1
	volume = 500000

	use_power = USE_POWER_IDLE
	idle_power_usage = 50		// Internal circuitry, friction losses and stuff
	active_power_usage = 1000	// Blowers running
	power_rating = 100000		// 100 kW ~ 135 HP

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/pump/huge/New()
	..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/pump/huge/attack_hand(var/mob/user)
	to_chat(user, "<span class='notice'>You can't directly interact with this machine. Use the pump control console.</span>")

/obj/machinery/portable_atmospherics/powered/pump/huge/update_icon()
	overlays.Cut()

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "siphon:1"
	else
		icon_state = "siphon:0"

/obj/machinery/portable_atmospherics/powered/pump/huge/power_change()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/pump/huge/process()
	if(!anchored || (stat & (NOPOWER|BROKEN)))
		on = 0
		last_flow_rate = 0
		last_power_draw = 0
		update_icon()
	var/new_use_power = 1 + on
	if(new_use_power != use_power)
		update_use_power(new_use_power)
	if(!on)
		return

	var/power_draw = -1

	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_delta
	var/output_volume
	var/air_temperature
	if(direction_out)
		pressure_delta = target_pressure - environment.return_pressure()
		output_volume = environment.volume * environment.group_multiplier
		air_temperature = environment.temperature? environment.temperature : air_contents.temperature
	else
		pressure_delta = environment.return_pressure() - target_pressure
		output_volume = air_contents.volume * air_contents.group_multiplier
		air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

	var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)

	if(pressure_delta > 0.01)
		if(direction_out)
			power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
		else
			power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/pump/huge/attackby(var/obj/item/I, var/mob/user)
	if(I.is_wrench())
		if(on)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
			return

		anchored = !anchored
		playsound(get_turf(src), I.usesound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return

	// Doesn't use power cells
	if(istype(I, /obj/item/cell))
		return
	if (I.is_screwdriver())
		return

	// Doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	..()


/obj/machinery/portable_atmospherics/powered/pump/huge/stationary
	name = "Stationary Air Pump"

/obj/machinery/portable_atmospherics/powered/pump/huge/stationary/attackby(var/obj/item/I, var/mob/user)
	if(I.is_wrench())
		to_chat(user, "<span class='warning'>The bolts are too tight for you to unscrew!</span>")
		return

	..()

/obj/machinery/portable_atmospherics/powered/pump/huge/stationary/purge
	on = 1
	start_pressure = 0
	target_pressure = 0

/obj/machinery/portable_atmospherics/powered/pump/huge/stationary/purge/power_change()
	..()
	if(!(stat & (NOPOWER|BROKEN)))
		on = 1
		update_icon()
