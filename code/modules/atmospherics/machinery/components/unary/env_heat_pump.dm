



/obj/machinery/atmospherics/component/unary/env_heat_pump
	name = "Room heat exchanger"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "env_heat_pump"
	density = 1
	anchored = 1
	use_power = USE_POWER_OFF
	idle_power_usage = 5			// 5 Watts for thermostat related circuitry
	pipe_flags = PIPE_FLAG_ONE_PER_TURF
	connect_types = CONNECT_TYPE_AUX
	var/env_temp

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection
	var/id_tag

	power_rating = 30000 // standard for machinery (including normal pumps) is 7500, heatpumps have 15000

	var/target_temp = T20C
	efficiency_multiplier = 1.5 //Bigger device probably works a bit better than the small cramped one

/obj/machinery/atmospherics/component/unary/env_heat_pump/Initialize(mapload)
	. = ..()
	START_MACHINE_PROCESSING(src)

/obj/machinery/atmospherics/component/unary/env_heat_pump/atmos_init()
	. = ..()
	if(frequency)
		var/radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
		radio_connection = register_radio(src, frequency, frequency, radio_filter_in)
		src.broadcast_status()

/obj/machinery/atmospherics/component/unary/env_heat_pump/Destroy()
	. = ..()
	STOP_MACHINE_PROCESSING(src)

/obj/machinery/atmospherics/component/unary/env_heat_pump/update_icon()
	. = ..()
	if(use_power)
		if(env_temp > target_temp+0.001)//We dont work on such minor
			icon_state = "env_heat_pump_cool"
		else if(env_temp < target_temp-0.001)
			icon_state = "env_heat_pump_heat"
		else
			if(use_power > 1)
				icon_state = "env_heat_pump_on"
			else
				icon_state = "env_heat_pump"
	else
		icon_state = "env_heat_pump"

/obj/machinery/atmospherics/component/unary/env_heat_pump/process(delta_time)
	. = ..()
	update_icon()
	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		use_power = USE_POWER_OFF //We cant operate so we might as well turn off
		return

	var/datum/gas_mixture/env = return_air()

	if(!air_contents || !env || !istype(env))
		use_power = USE_POWER_OFF //We cant operate so we might as well turn off
		return

	//If there is no air_contents or env the temperature is assumed 0 Kelvin which allows for
	if((air_contents.temperature < 1) ||  (env.temperature < 1))
		use_power = USE_POWER_OFF //We cant operate so we might as well turn off
		return

	env_temp = env.temperature

	//Now we are at the point where we need to actively pump
	var/power_draw = pump_heat(target_temp, air_contents, env, power_rating)

	if (power_draw >= 0)
		last_power_draw_legacy = power_draw
		use_power(power_draw)
		network?.update = 1

/obj/machinery/atmospherics/component/unary/env_heat_pump/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(!isnull(signal.data["power"]))
		if(text2num(signal.data["power"]) != 0)
			use_power = USE_POWER_ACTIVE
		else
			use_power = USE_POWER_OFF
	if(!isnull(signal.data["target_temperature"]))
		target_temp = text2num(signal.data["target_temperature"])
	spawn(2)
		broadcast_status()
	if(signal.data["status"] == null)
		update_icon()


/obj/machinery/atmospherics/component/unary/env_heat_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"device" = "EHP",
		"power" = use_power,
		"target_temp" = target_temp,
		"timestamp" = world.time,
		"sigtype" = "status",
		"power_draw" = last_power_draw_legacy,
		"flow_rate" = last_flow_rate_legacy,
	)

	radio_connection.post_signal(src, signal, null)

	return 1
