//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/component/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "map_injector"
	pipe_state = "injector"

	name = "air injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

	use_power = USE_POWER_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000	//15000 W ~ 20 HP

	var/injecting = 0

	var/volume_rate = 50	//flow rate limit

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	level = 1

/obj/machinery/atmospherics/component/unary/outlet_injector/Initialize(mapload)
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500	//Give it a small reservoir for injecting. Also allows it to have a higher flow rate limit than vent pumps, to differentiate injectors a bit more.

/obj/machinery/atmospherics/component/unary/outlet_injector/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/component/unary/outlet_injector/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

/obj/machinery/atmospherics/component/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/component/unary/outlet_injector/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/atmospherics/component/unary/outlet_injector/process(delta_time)
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/datum/gas_mixture/environment = loc.return_air()

	if(environment && air_contents.temperature > 0)
		var/transfer_moles = (volume_rate/air_contents.volume)*air_contents.total_moles //apply flow rate limit
		power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network)
			network.update = 1

	return 1

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/inject()
	if(injecting || (machine_stat & NOPOWER))
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	if (!environment)
		return 0

	injecting = 1

	if(air_contents.temperature > 0)
		var/power_used = pump_gas(src, air_contents, environment, air_contents.total_moles, power_rating)
		use_power(power_used)

		if(network)
			network.update = 1

	flick("inject", src)

/obj/machinery/atmospherics/component/unary/outlet_injector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", name)
		ui.open()

/obj/machinery/atmospherics/component/unary/outlet_injector/ui_data()
	var/data = list()
	data["on"] = injecting
	data["rate"] = round(volume_rate)
	data["max_rate"] = round(air_contents.volume)
	return data

/obj/machinery/atmospherics/component/unary/outlet_injector/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("power")
			toggle_injecting()
			investigate_log("was turned [injecting ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = air_contents.volume
				. = TRUE
			else if(rate == "input")
				rate = input("New transfer rate (0-[air_contents.volume] L/s):", name, volume_rate) as num|null
				if(!isnull(rate) && !..())
					. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				volume_rate = clamp(rate, 0, air_contents.volume)
				investigate_log("was set to [volume_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
	update_icon()
	broadcast_status()

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency)

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AO",
		"power" = use_power,
		"volume_rate" = volume_rate,
		"sigtype" = "status"
	 )

	radio_connection.post_signal(src, signal)

	return 1

/obj/machinery/atmospherics/component/unary/outlet_injector/Initialize(mapload)
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/component/unary/outlet_injector/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"])
		update_use_power(text2num(signal.data["power"]))

	if(signal.data["power_toggle"])
		update_use_power(!use_power)

	if(signal.data["inject"])
		spawn inject()
		return

	if(signal.data["set_volume_rate"])
		var/number = text2num(signal.data["set_volume_rate"])
		volume_rate = clamp( number, 0,  air_contents.volume)

	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/component/unary/outlet_injector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/component/unary/outlet_injector/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/component/unary/outlet_injector/proc/toggle_injecting()
	injecting = !injecting
	update_use_power(injecting ? USE_POWER_IDLE : USE_POWER_OFF)
	update_icon()

/obj/machinery/atmospherics/component/unary/outlet_injector/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/airlock_electronics))
		if(!src.allowed(user)) // ID check, otherwise you could just wipe the access with any board.
			to_chat(user, "<span class='warning'>Access denied.</span>")
			return 1
		to_chat(user, "<span class='notice'>You begin to upload access data to \the [src]...</span>")
		if (do_after(user, 20))
			var/obj/item/airlock_electronics/E = W
			if(E.one_access)
				req_access = null
				req_one_access = E.conf_access
			else
				req_access = E.conf_access
				req_one_access = null
			user.visible_message( \
				"<span class='notice'>\The [user] uploads access data to \the [src].</span>", \
				"<span class='notice'>You copied access data from \the [W] to \the [src].</span>", \
				"You hear a faint beep.")
		return 0

	if(!W.is_wrench())
		return ..()

	if(!(machine_stat & NOPOWER) && use_power)
		to_chat(user, "<span class='warning'>You cannot unwrench this [src], turn it off first.</span>")
		return 1

	if(!src.allowed(user)) // Same as above, don't let any dingus with a wrench pull this thing up.
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return 1

	if(unsafe_pressure())
		to_chat(user, "<span class='warning'>You feel a gust of air blowing in your face as you try to unwrench [src]. Maybe you should reconsider..</span>")
	add_fingerprint(user)

	playsound(src, W.usesound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.toolspeed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		deconstruct()
