//
// Objects for making phoron airlocks work
// Instructions: Choose a base tag, and include equipment with tags as follows:
// Phoron Lock Controller (/obj/machinery/embedded_controller/radio/airlock/phoron), id_tag = "[base]"
// 		Don't set any other tag vars, they will be auto-populated
// Internal Sensor (obj/machinery/airlock_sensor/phoron), id_tag = "[base]_sensor"
//		Make sure it is actually located inside the airlock, not on a wall turf.  use pixel_x/y
// Exterior doors: (obj/machinery/door/airlock), id_tag = "[base]_outer"
// Interior doors: (obj/machinery/door/airlock), id_tag = "[base]_inner"
// Exterior access button: (obj/machinery/access_button/airlock_exterior),  master_tag = "[base]"
// Interior access button: (obj/machinery/access_button/airlock_interior),  master_tag = "[base]"
// Srubbers: (obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary), frequency = "1379", scrub_id = "[base]_scrubber"
// Pumps: (obj/machinery/atmospherics/component/unary/vent_pump/high_volume), frequency = 1379 id_tag = "[base]_pump"
//

/obj/machinery/airlock_sensor/phoron
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "phoronlock sensor"

/obj/machinery/airlock_sensor/phoron/airlock_interior
	command = "cycle_int"

/obj/machinery/airlock_sensor/phoron/airlock_exterior
	command = "cycle_ext"


// Radio remote control
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	var/frequency = 0
	var/datum/radio_frequency/radio_connection
	scrubbing_ids = list("phoron", "co2")

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/Initialize(mapload)
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, radio_filter = RADIO_ATMOSIA)

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != scrub_id) || (signal.data["sigtype"] != "command"))
		return 0
	if(signal.data["power"])
		on = text2num(signal.data["power"]) ? TRUE : FALSE
	if("power_toggle" in signal.data)
		on = !on
	if(signal.data["status"])
		spawn(2)
			broadcast_status()
		return //do not update_icon
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/proc/broadcast_status()
	if(!radio_connection)
		return 0
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	signal.data = list(
		"tag" = scrub_id,
		"power" = on,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal, radio_filter = RADIO_AIRLOCK)
	return 1

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/phoronlock		//Special scrubber with bonus inbuilt heater
	active_power_usage = 2000
	efficiency_multiplier = 4
	var/target_temp = T20C
	var/heating_power = 150000

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/phoronlock/heater //Variant for use on rift
	name = "Stationary Air Heater"
	active_power_usage = 1000

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/phoronlock/process()
	..()

	if(on)
		var/datum/gas_mixture/env = loc.return_air()
		if(env && abs(env.temperature - target_temp) > 0.1)
			var/datum/gas_mixture/removed = env.remove_ratio(0.99)
			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(target_temp)
				removed.adjust_thermal_energy(clamp(heat_transfer,-heating_power,heating_power))
				env.merge(removed)

//
// PHORON LOCK CONTROLLER
//
/obj/machinery/embedded_controller/radio/airlock/phoron/Initialize(mapload)
	. = ..()
	program = new/datum/computer/file/embedded_program/airlock/phoron(src)

//Advanced airlock controller for when you want a more versatile airlock controller - useful for turning simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/phoron
	name = "Phoron Lock Controller"
	valid_actions = list("cycle_ext", "cycle_int", "force_ext", "force_int", "abort", "secure")
	var/tag_scrubber

/obj/machinery/embedded_controller/radio/airlock/phoron/ui_data(mob/user, datum/tgui/ui)
	. = list(
		"chamber_pressure" = program.memory["chamber_sensor_pressure"],
		"chamber_phoron" = program.memory["chamber_sensor_phoron"],
		"chamber_temperature" = round(program.memory["chamber_sensor_temperature"] - 273.15, 0.1),
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"],
		"internalTemplateName" = "AirlockConsolePhoron",
	)

//
// PHORON LOCK CONTROLLER PROGRAM
//

//Handles the control of airlocks

/datum/computer/file/embedded_program/airlock/phoron
	var/tag_scrubber

/datum/computer/file/embedded_program/airlock/phoron/New(var/obj/machinery/embedded_controller/M)
	..(M)
	memory["chamber_sensor_phoron"] = 0
	// warning: hardcode alert
	// values tuned to v3b right now!!!
	memory["external_sensor_pressure"] = 82.4
	memory["external_sensor_phoron"] = (82.4*CELL_VOLUME) / (8.134 * 234) // n = pv/rt
	memory["internal_sensor_phoron"] = 0
	memory["target_temperature"] = T20C
	memory["scrubber_status"] = "unknown"
	memory["target_phoron"] = 0.1
	memory["secure"] = 1

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock/phoron))	//if our controller is an airlock controller than we can auto-init our tags
		var/obj/machinery/embedded_controller/radio/airlock/phoron/controller = M
		tag_scrubber = controller.tag_scrubber ? controller.tag_scrubber : "[id_tag]_scrubber"

/datum/computer/file/embedded_program/airlock/phoron/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag) return
	if(..()) return 1

	if(receive_tag==tag_chamber_sensor)
		memory["chamber_sensor_phoron"] = round(text2num(signal.data["phoron"]), 0.1)
		memory["chamber_sensor_pressure"] = round(text2num(signal.data["pressure"]), 0.1)
		memory["chamber_sensor_temperature"] = round(text2num(signal.data["temperature"]), 0.1)

	else if(receive_tag==tag_exterior_sensor)
		memory["external_sensor_phoron"] = round(text2num(signal.data["phoron"]), 0.1)
		memory["external_sensor_pressure"] = round(text2num(signal.data["pressure"]), 0.1)
		memory["external_sensor_temperature"] = round(text2num(signal.data["temperature"]), 0.1)

	else if(receive_tag==tag_interior_sensor)
		memory["internal_sensor_phoron"] = round(text2num(signal.data["phoron"]), 0.1)
		memory["internal_sensor_pressure"] = round(text2num(signal.data["pressure"]), 0.1)
		memory["internal_sensor_temperature"] = round(text2num(signal.data["temperature"]), 0.1)

	else if(receive_tag==tag_scrubber)
		if(signal.data["power"])
			memory["scrubber_status"] = "on"
		else
			memory["scrubber_status"] = "off"

// Note: This code doesn't wait for pumps and scrubbers to be offline like other code does
// The idea is to make the doors open and close faster, since there isn't much harm really.
// But lets evaluate how it actually works in the game.
/datum/computer/file/embedded_program/airlock/phoron/process()
	switch(state)
		if(STATE_UNDEFINED)
			return
		if(STATE_CLOSED)//First the three stable states:
			return
		if(STATE_OPEN_IN)
			return
		if(STATE_OPEN_OUT)
			return
		if(STATE_CYCLING_IN)//Now the changing states:
			if(memory["exterior_status"]["state"] == "open")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
			else if(fuzzy_smaller_check(memory["target_phoron"], memory["chamber_sensor_phoron"], 0))//target phoron is already 0.1
				signalScrubber(tag_scrubber, 1) // Start cleaning
				signalPump(tag_airpump, 1, 1, memory["target_pressure"]) // And pressurizng to offset losses
				memory["processing"] = TRUE
			else if(fuzzy_smaller_check(memory["chamber_sensor_temperature"], memory["target_temperature"]))
				signalScrubber(tag_scrubber, 1)//the scrubbers also work as heats because fuck making sense
				memory["processing"] = TRUE
			else if(fuzzy_smaller_check(memory["chamber_sensor_pressure"], memory["internal_sensor_pressure"]))
				signalScrubber(tag_scrubber, 0) // stop cleaning
				signalPump(tag_airpump, 1, 1, memory["target_pressure"]) // continue pressurizng to offset losses
				memory["processing"] = TRUE
			else // both phoron and pressure levels are acceptable
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "open")
				signalScrubber(tag_scrubber, 0)
				signalPump(tag_airpump, 0, 1, memory["external_sensor_pressure"])//Turn the pump off
				state = STATE_OPEN_IN
				memory["processing"] = FALSE
		if(STATE_CYCLING_OUT)
			if(memory["interior_status"]["state"] == "open")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			else if((memory["chamber_sensor_pressure"] - memory["external_sensor_pressure"]) > 1 )
				signalPump(tag_airpump, 1, 0, memory["external_sensor_pressure"]) // siphon air out to avoid being pulled from your feet
				memory["processing"] = TRUE
			else if(memory["interior_status"]["state"] == "open") //double check
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			else  //  pressure levels are acceptable and interior doors are closed
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "open")
				signalPump(tag_airpump, 0, 1, memory["external_sensor_pressure"])//Turn the pump off
				state = STATE_OPEN_OUT
				memory["processing"] = FALSE
		if(STATE_SEALING)
			if(memory["interior_status"]["state"] == "open")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
				memory["processing"] = TRUE
			else if(memory["exterior_status"]["state"] == "open")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
				memory["processing"] = TRUE
			else
				state = STATE_CLOSED
				memory["processing"] = FALSE
	return 1

/datum/computer/file/embedded_program/airlock/phoron/stop_everything()
	. = ..()
	signalScrubber(tag_scrubber, 0)//Turn off scrubbers

