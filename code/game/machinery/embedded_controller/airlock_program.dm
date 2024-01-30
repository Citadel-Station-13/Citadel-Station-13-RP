//Handles the control of airlocks

/// Never try to pump to pure vacuum, its not happening.
#define MIN_TARGET_PRESSURE (ONE_ATMOSPHERE * 0.01)


/datum/computer/file/embedded_program/airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_airlock_mech_sensor
	var/tag_shuttle_mech_sensor

	var/state = STATE_CLOSED

	//var/tag_pump_out_external not part of basic airlocks
	//var/tag_pump_out_internal

/datum/computer/file/embedded_program/airlock/New(var/obj/machinery/embedded_controller/M)
	..(M)

	memory["chamber_sensor_pressure"] = ONE_ATMOSPHERE
	memory["external_sensor_pressure"] = 0					//assume vacuum for simple airlock controller
	memory["internal_sensor_pressure"] = ONE_ATMOSPHERE
	memory["exterior_status"] = list(state = "closed", lock = "locked")		//assume closed and locked in case the doors dont report in
	memory["interior_status"] = list(state = "closed", lock = "locked")
	memory["pump_status"] = "unknown"
	memory["target_pressure"] = ONE_ATMOSPHERE
	memory["purge"] = 0
	memory["secure"] = 0

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock))	//if our controller is an airlock controller than we can auto-init our tags
		var/obj/machinery/embedded_controller/radio/airlock/controller = M
		tag_exterior_door = controller.tag_exterior_door? controller.tag_exterior_door : "[id_tag]_outer"
		tag_interior_door = controller.tag_interior_door? controller.tag_interior_door : "[id_tag]_inner"
		tag_airpump = controller.tag_airpump? controller.tag_airpump : "[id_tag]_pump"
		tag_chamber_sensor = controller.tag_chamber_sensor? controller.tag_chamber_sensor : "[id_tag]_sensor"
		tag_exterior_sensor = controller.tag_exterior_sensor || "[id_tag]_exterior_sensor"
		tag_interior_sensor = controller.tag_interior_sensor || "[id_tag]_interior_sensor"
		tag_airlock_mech_sensor = controller.tag_airlock_mech_sensor? controller.tag_airlock_mech_sensor : "[id_tag]_airlock_mech"
		tag_shuttle_mech_sensor = controller.tag_shuttle_mech_sensor? controller.tag_shuttle_mech_sensor : "[id_tag]_shuttle_mech"
		memory["secure"] = controller.tag_secure

		spawn(10)
			signalDoor(tag_exterior_door, "update")		//signals connected doors to update their status
			signalDoor(tag_interior_door, "update")

/datum/computer/file/embedded_program/airlock/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag) return

	if(receive_tag==tag_chamber_sensor)
		if(signal.data["pressure"])
			memory["chamber_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_sensor)
		memory["external_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_interior_sensor)
		memory["internal_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_door)
		memory["exterior_status"]["state"] = signal.data["door_status"]
		memory["exterior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_interior_door)
		memory["interior_status"]["state"] = signal.data["door_status"]
		memory["interior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_airpump)
		if(signal.data["power"])
			memory["pump_status"] = signal.data["direction"]
		else
			memory["pump_status"] = "off"

	else if(receive_tag==id_tag)
		receive_user_command(signal.data["command"])

/datum/computer/file/embedded_program/airlock/receive_user_command(command)
	. = TRUE
	switch(command)
		if("cycle_ext")
			state = STATE_CYCLING_OUT
			memory["processing"] = TRUE
		if("cycle_int")
			state = STATE_CYCLING_IN
			memory["processing"] = TRUE
		if("secure")
			state = STATE_SEALING
			memory["processing"] = TRUE
		if("force_ext")
			state = STATE_UNDEFINED
			memory["processing"] = FALSE
			if(memory["exterior_status"]["state"] == "open")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
			else if(memory["exterior_status"]["state"] == "closed")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "open")
		if("force_int")
			state = STATE_UNDEFINED
			memory["processing"] = FALSE
			if(memory["interior_status"]["state"] == "open")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			else if(memory["interior_status"]["state"] == "closed")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "open")
		if("abort")
			stop_everything()
		if("purge")
			toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
			toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			signalPump(tag_airpump, 1, 0, MIN_TARGET_PRESSURE)
			state = STATE_UNDEFINED
		if("bypass")
			memory["secure"] = !memory["secure"]
			if(memory["secure"])
				signalDoor(tag_interior_door, "lock")
				signalDoor(tag_exterior_door, "lock")
			else
				signalDoor(tag_interior_door, "unlock")
				signalDoor(tag_exterior_door, "unlock")
		else
			. = FALSE

/datum/computer/file/embedded_program/airlock/process()
	switch(state)
		if(STATE_OPEN_OUT)
			return 1
		if(STATE_OPEN_IN)
			return 1
		if(STATE_CLOSED)
			return 1
		if(STATE_BYPASS)
			return 1
		if(STATE_CYCLING_IN)
			if(memory["exterior_status"]["state"] == "open")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
			else if(fuzzy_smaller_check(memory["chamber_sensor_pressure"], memory["internal_sensor_pressure"]))
				signalPump(tag_airpump, 1, 1, memory["target_pressure"]+0.1)
				memory["processing"] = TRUE
			else
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "open")
				signalPump(tag_airpump, 0, 1, memory["external_sensor_pressure"])//Turn the pump off
				state = STATE_OPEN_IN
				memory["processing"] = FALSE
		if(STATE_CYCLING_OUT)
			if(memory["interior_status"]["state"] == "open")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			else if(fuzzy_smaller_check(MIN_TARGET_PRESSURE, memory["chamber_sensor_pressure"]))
				signalPump(tag_airpump, 1, 0, MIN_TARGET_PRESSURE) // siphon air out to avoid being pulled from your feet
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
		if(STATE_BYPASSING)
			signalDoor(tag_interior_door, "unlock")
			signalDoor(tag_exterior_door, "unlock")
			state = STATE_BYPASS

		else
			state = STATE_UNDEFINED
	return 1

//these are here so that other types don't have to make so many assuptions about our implementation

/datum/computer/file/embedded_program/airlock/proc/close_doors()
	toggleDoor(memory["interior_status"], tag_interior_door, 1, "close")
	toggleDoor(memory["exterior_status"], tag_exterior_door, 1, "close")


/datum/computer/file/embedded_program/airlock/proc/signalDoor(var/tag, var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = tag
	signal.data["command"] = command
	post_signal(signal, RADIO_AIRLOCK)

/datum/computer/file/embedded_program/airlock/proc/signalPump(var/tag, var/power, var/direction, var/pressure)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"power" = power,
		"direction" = direction,
		"set_external_pressure" = pressure
	)
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/signalScrubber(var/tag, var/power)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"power" = "[power]",
	)
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/signal_mech_sensor(command, sensor)
	var/datum/signal/signal = new
	signal.data["tag"] = sensor
	signal.data["command"] = command
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/enable_mech_regulation()
	signal_mech_sensor("enable", tag_shuttle_mech_sensor)
	signal_mech_sensor("enable", tag_airlock_mech_sensor)

/datum/computer/file/embedded_program/airlock/proc/disable_mech_regulation()
	signal_mech_sensor("disable", tag_shuttle_mech_sensor)
	signal_mech_sensor("disable", tag_airlock_mech_sensor)

/datum/computer/file/embedded_program/airlock/proc/stop_everything()
	signalPump(tag_airpump, 0, 1, memory["target_pressure"])//Stop the pumps
	state = STATE_UNDEFINED
	memory["processing"] = FALSE

/datum/computer/file/embedded_program/airlock/proc/delta_check(var/to_check, var/target_value, var/delta)
	return (abs(to_check - target_value) <= delta)

/datum/computer/file/embedded_program/airlock/proc/fuzzy_smaller_check(var/to_check, var/target_value, var/fuzz = 0.1)
	return (to_check < (target_value - fuzz))
/*----------------------------------------------------------
toggleDoor()

Sends a radio command to a door to either open or close. If
the command is 'toggle' the door will be sent a command that
reverses it's current state.
Can also toggle whether the door bolts are locked or not,
depending on the state of the 'secure' flag.
Only sends a command if it is needed, i.e. if the door is
already open, passing an open command to this proc will not
send an additional command to open the door again.
----------------------------------------------------------*/
/datum/computer/file/embedded_program/airlock/proc/toggleDoor(var/list/doorStatus, var/doorTag, var/secure, var/command)
	var/doorCommand = null

	if(command == "toggle")
		if(doorStatus["state"] == "open")
			command = "close"
		else if(doorStatus["state"] == "closed")
			command = "open"

	switch(command)
		if("close")
			if(secure)
				if(doorStatus["state"] == "open")
					doorCommand = "secure_close"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "open")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag, "unlock")
					doorCommand = "close"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

		if("open")
			if(secure)
				if(doorStatus["state"] == "closed")
					doorCommand = "secure_open"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "closed")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag,"unlock")
					doorCommand = "open"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

	if(doorCommand)
		signalDoor(doorTag, doorCommand)

/datum/computer/file/embedded_program/airlock/access_controll/process()
	switch(state)
		if(STATE_OPEN_OUT)
			return 1
		if(STATE_OPEN_IN)
			return 1
		if(STATE_CLOSED)
			return 1
		if(STATE_BYPASS)
			return 1
		if(STATE_CYCLING_IN)
			if(memory["exterior_status"]["state"] == "open")
				toggleDoor(memory["exterior_status"],tag_exterior_door, 1, "close")
			else
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "open")
				state = STATE_OPEN_IN
				memory["processing"] = FALSE
		if(STATE_CYCLING_OUT)
			if(memory["interior_status"]["state"] == "open")
				toggleDoor(memory["interior_status"],tag_interior_door, 1, "close")
			else
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
		if(STATE_BYPASSING)
			signalDoor(tag_interior_door, "unlock")
			signalDoor(tag_exterior_door, "unlock")
			state = STATE_BYPASS

		else
			state = STATE_UNDEFINED
	return 1
