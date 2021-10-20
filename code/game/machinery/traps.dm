//Place traps here. Crossbow trap as basis?

#define TRAP_CONTROL_RANGE 30

obj/machinery/trap
	name = "strange area"
	desc = "The dust hangs strangely in the air here."
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "trap_frame"
	anchored = 1 //About time someone fixed this.
	density = 0
	var/id_tag
	var/frequency = RADIO_TRAP_FREQ
	var/datum/radio_frequency/radio_connection
	var/cur_command = null
	var/trap_floor_type = /turf/simulated/floor/water/acid
	var/tripped = FALSE
	var/code = 24

obj/machinery/trap/process(delta_time)
	if (..() == PROCESS_KILL && !cur_command)
		. = PROCESS_KILL
	else
		execute_current_command()

obj/machinery/trap/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


obj/machinery/trap/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

	update_icon()

obj/machinery/trap/Destroy()
	if(frequency && radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

obj/machinery/trap/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	cur_command = signal.data["command"]
	execute_current_command()
	if(cur_command)
		START_MACHINE_PROCESSING(src)


obj/machinery/trap/proc/execute_current_command()
	if (!cur_command)
		return

	spawn()
		do_command(cur_command)
		if (command_completed(cur_command))
			cur_command = null

obj/machinery/trap/proc/do_command(var/command)
	switch(command)
		if("trip")
			trip()

	send_status()

obj/machinery/trap/proc/command_completed(var/command)
	switch(command)
		if("tripped")
			return tripped
		if("set")
			return !tripped

	return 1	//Unknown command. Just assume it's completed.


obj/machinery/trap/proc/send_status(var/bumped = 0)
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["trap_status"] = tripped?("tripped"):("set")

		radio_connection.post_signal(src, signal, range = TRAP_CONTROL_RANGE, radio_filter = RADIO_TRAP)

obj/machinery/trap/proc/trip()
	if(tripped)
		return
	if(!tripped)
		tripped = TRUE
		fire()

obj/machinery/trap/proc/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

obj/machinery/trap/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"

#undef TRAP_CONTROL_RANGE


/*
Ideas:
Punji trap that does brute to feet.
Knee breaking trap.
Classic pitfall trap (teleports?)
Crossbow shooting wall trap.
Etc.
*/
