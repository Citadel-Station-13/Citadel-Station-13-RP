/obj/machinery/mech_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "mechatronic sensor"
	desc = "Regulates mech movement."
	anchored = TRUE
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_CLICK
	use_power = USE_POWER_IDLE
	layer = ON_WINDOW_LAYER
	power_channel = EQUIP
	var/on = 0
	var/id_tag = null

	var/frequency = 1379
	var/datum/radio_frequency/radio_connection

/obj/machinery/mech_sensor/CanAllowThrough(atom/movable/mover, turf/target)
	if(!enabled())
		return TRUE
	if(!(get_dir(src, target) & dir))
		return TRUE
	if(!is_blocked(mover))
		return TRUE
	give_feedback(mover)
	return FALSE

/obj/machinery/mech_sensor/proc/is_blocked(atom/movable/AM)
	if(ismecha(AM))
		var/obj/mecha/M = AM
		if(istype(M, /obj/mecha/medical/odysseus))
			for(var/obj/item/mecha_parts/mecha_equipment/tool/sleeper/S in M.equipment)
				if(S.occupant)
					return FALSE
		return TRUE
	if(isvehicle(AM))
		return TRUE
	return FALSE

/obj/machinery/mech_sensor/proc/give_feedback(O as obj)
	var/block_message = "<span class='warning'>Movement control overridden. Area denial active.</span>"
	var/feedback_timer = 0
	if(feedback_timer)
		return

	if(istype(O, /obj/mecha))
		var/obj/mecha/R = O
		if(R && R.occupant)
			to_chat(R.occupant,block_message)
	else if(istype(O, /obj/vehicle_old/train/engine))
		var/obj/vehicle_old/train/engine/E = O
		if(E && E.load && E.is_train_head())
			to_chat(E.load,block_message)

	feedback_timer = 1
	spawn(50) //Without this timer the feedback becomes horribly spamy
		feedback_timer = 0

/obj/machinery/mech_sensor/proc/enabled()
	return on && !(machine_stat & NOPOWER)

/obj/machinery/mech_sensor/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/mech_sensor/update_icon(var/safety = 0)
	if (enabled())
		icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/mech_sensor/Initialize(mapload)
	. = ..()
	set_frequency(frequency)

/obj/machinery/mech_sensor/proc/set_frequency(new_frequency)
	if(radio_connection)
		radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency)

/obj/machinery/mech_sensor/receive_signal(datum/signal/signal)
	if(machine_stat & NOPOWER)
		return

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag))
		return

	if(signal.data["command"] == "enable")
		on = 1
	else if (signal.data["command"] == "disable")
		on = 0

	update_icon()
