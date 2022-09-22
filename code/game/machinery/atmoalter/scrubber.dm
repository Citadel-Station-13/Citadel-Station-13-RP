/obj/machinery/portable_atmospherics/powered/scrubber
	name = "Portable Air Scrubber"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = 1
	w_class = ITEMSIZE_NORMAL

	var/on = 0
	var/volume_rate = 800

	volume = 750

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = 10 * ONE_ATMOSPHERE

	var/list/scrubbing_gas = list(/datum/gas/carbon_dioxide, /datum/gas/volatile_fuel, /datum/gas/phoron, /datum/gas/nitrous_oxide,
		/datum/gas/helium, /datum/gas/carbon_monoxide, /datum/gas/methyl_bromide, /datum/gas/nitrodioxide, /datum/gas/nitricoxide,
		/datum/gas/methane, /datum/gas/argon, /datum/gas/krypton, /datum/gas/neon, /datum/gas/ammonia, /datum/gas/xenon, /datum/gas/chlorine,
		/datum/gas/sulfur_dioxide, /datum/gas/hydrogen)

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize(mapload)
	. = ..()
	for(var/i in scrubbing_gas)
		if(!ispath(i))
			scrubbing_gas -= i
			var/path = gas_id2path(i)
			if(!path)
				stack_trace("Invalid gas id [i]")
			else
				scrubbing_gas += path
	cell = new/obj/item/cell/apc(src)

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/update_icon_state()
	. = ..()
	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/update_overlays()
	. = ..()
	if(holding)
		. += "scrubber-open"

	if(connected_port)
		. += "scrubber-connector"

/obj/machinery/portable_atmospherics/powered/scrubber/process(delta_time)
	..()

	var/power_draw = -1

	if(on && cell && cell.charge)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use_scaled(DYNAMIC_W_TO_CELL_UNITS(power_draw, 1))
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge)
			power_change()
			update_icon()

	//src.update_icon()
	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/scrubber/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ai(var/mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_ghost(var/mob/user)
	. = ..()
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/scrubber/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableScrubber", name)
		ui.open()

/obj/machinery/portable_atmospherics/powered/scrubber/ui_data(mob/user)
	var/list/data = list()

	data["on"] = on ? 1 : 0
	data["connected"] = connected_port ? 1 : 0
	data["pressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["rate"] = round(volume_rate)
	data["minrate"] = round(minrate)
	data["maxrate"] = round(maxrate)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		data["holding"]["pressure"] = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0)
	else
		data["holding"] = null

	return data

/obj/machinery/portable_atmospherics/powered/scrubber/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("eject")
			if(holding)
				holding.loc = loc
				holding = null
			. = TRUE
		if("volume_adj")
			volume_rate = clamp(text2num(params["vol"]), minrate, maxrate)
			. = TRUE

	update_icon()

//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	icon = 'icons/obj/atmos_vr.dmi'
	icon_state = "scrubber:0"
	anchored = TRUE
	volume = 500000
	volume_rate = 7000

	use_power = USE_POWER_IDLE
	idle_power_usage = 50		//internal circuitry, friction losses and stuff
	active_power_usage = 1000	// Blowers running
	power_rating = 100000	//100 kW ~ 135 HP

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Initialize(mapload)
	. = ..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		to_chat(user, "<span class='notice'>You can't directly interact with this machine. Use the scrubber control console.</span>")

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(machine_stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = machine_stat
	..()
	if (old_stat != machine_stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/process(delta_time)
	if(!anchored || (machine_stat & (NOPOWER|BROKEN)))
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

	var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(I.is_wrench())
		if(on)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
			return

		anchored = !anchored
		playsound(src.loc, I.tool_sound, 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return

	//doesn't use power cells
	if(istype(I, /obj/item/cell))
		return
	if(I.is_screwdriver())
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	..()


/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(I.is_wrench())
		to_chat(user, "<span class='warning'>The bolts are too tight for you to unscrew!</span>")
		return

	..()

// Tether tram air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram
	name = "\improper Tram Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram/powered()
	return TRUE // Always be powered

// Triumph shuttle air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle
	name = "\improper Shuttle Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/shuttle/powered()
	return TRUE // Always be powered
