/*
Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.

node1, air1, network1 correspond to input
node2, air2, network2 correspond to output

Thus, the two variables affect pump operation are set in New():
	air1.volume
		This is the volume of gas available to the pump that may be transfered to the output
	air2.volume
		Higher quantities of this cause more air to be perfected later
			but overall network volume is also increased as this increases...
*/

/obj/machinery/atmospherics/component/binary/pump
	icon = 'icons/atmos/pump.dmi'
	icon_state = "map_off"
	construction_type = /obj/item/pipe/directional
	pipe_state = "pump"
	level = 1
	var/base_icon = "pump"

	name = "gas pump"
	desc = "A pump"

	var/target_pressure = ONE_ATMOSPHERE

	//var/max_volume_transfer = 10000

	use_power = USE_POWER_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	var/max_pressure_setting = 15000	//kPa

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

//Quick functions.
/obj/machinery/atmospherics/component/binary/pump/CtrlClick(mob/user)
	if (Adjacent(user))
		add_hiddenprint(user)
		if(powered())
			to_chat(user, "You toggle the power to the pump [use_power ? "Off" : "On"].")
			update_use_power(!use_power)
			update_icon()
		else
			to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/component/binary/pump/CtrlShiftClick(mob/user)
	if(Adjacent(user))
		add_hiddenprint(user)
		if (powered())
			to_chat(user, "You set the pressure of the pump to default.")
			target_pressure = ONE_ATMOSPHERE
		else
			to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/component/binary/pump/AltClick(mob/user)
	if(Adjacent(user))
		add_hiddenprint(user)
		if (powered())
			to_chat(user, "You set the pressure of the pump to max.")
			target_pressure = max_pressure_setting
		else
			to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/component/binary/pump/Initialize(mapload)
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/component/binary/pump/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/component/binary/pump/on
	icon_state = "map_on"
	use_power = USE_POWER_IDLE

/obj/machinery/atmospherics/component/binary/pump/fuel
	icon_state = "map_off-fuel"
	base_icon = "pump-fuel"
	icon_connect_type = "-fuel"
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/component/binary/pump/fuel/on
	icon_state = "map_on-fuel"
	use_power = 1

/obj/machinery/atmospherics/component/binary/pump/aux
	icon_state = "map_off-aux"
	base_icon = "pump-aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX

/obj/machinery/atmospherics/component/binary/pump/aux/on
	icon_state = "map_on-aux"
	use_power = 1

/obj/machinery/atmospherics/component/binary/pump/update_icon()
	if(!powered())
		icon_state = "[base_icon]-off"
	else
		icon_state = "[use_power ? "[base_icon]-on" : "[base_icon]-off"]"

/obj/machinery/atmospherics/component/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, -180), node1?.icon_connect_type)
		add_underlay(T, node2, dir, node2?.icon_connect_type)

/obj/machinery/atmospherics/component/binary/pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/component/binary/pump/process(delta_time)
	last_power_draw = 0
	last_flow_rate = 0

	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

//Radio remote control

/obj/machinery/atmospherics/component/binary/pump/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/component/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = use_power,
		"target_output" = target_pressure,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/component/binary/pump/ui_interact(mob/user, datum/tgui/ui)
	if(machine_stat & (BROKEN|NOPOWER))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasPump", name)
		ui.open()

//This is the data which will be sent to the ui
/obj/machinery/atmospherics/component/binary/pump/ui_data(mob/user)
	var/list/data = list()

	data = list(
		"on" = use_power,
		"pressure_set" = round(target_pressure*100),
		"max_pressure" = max_pressure_setting,
		"last_flow_rate" = round(last_flow_rate*10),
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = power_rating,
	)

	return data

/obj/machinery/atmospherics/component/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return FALSE

	if(signal.data["power"])
		if(text2num(signal.data["power"]))
			update_use_power(USE_POWER_IDLE)
		else
			update_use_power(USE_POWER_OFF)

	if("power_toggle" in signal.data)
		update_use_power(!use_power)

	if(signal.data["set_output_pressure"])
		target_pressure = between(
			0,
			text2num(signal.data["set_output_pressure"]),
			ONE_ATMOSPHERE*50
		)

	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/component/binary/pump/attack_ghost(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/atmospherics/component/binary/pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

/obj/machinery/atmospherics/component/binary/pump/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			update_use_power(!use_power)
			. = TRUE
		if("set_press")
			var/press = params["press"]
			switch(press)
				if("min")
					target_pressure = 0
				if("max")
					target_pressure = max_pressure_setting
				if("set")
					var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure control",src.target_pressure) as num
					src.target_pressure = clamp( new_pressure, 0,  max_pressure_setting)
			. = TRUE

	update_icon()

/obj/machinery/atmospherics/component/binary/pump/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/atmospherics/component/binary/pump/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/pen))
		var/new_name = input(user, "Please enter the new name for this device:", "New Name")  as text|null
		new_name = trim(new_name)
		name = (new_name? new_name : name)
		return
	if (!W.is_wrench())
		return ..()
	if (!(machine_stat & NOPOWER) && use_power)
		to_chat(user, "<span class='warning'>You cannot unwrench this [src], turn it off first.</span>")
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
			"You hear ratchet.")
		deconstruct()
