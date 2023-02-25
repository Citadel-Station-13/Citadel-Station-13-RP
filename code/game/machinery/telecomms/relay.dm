/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "Telecommunication Relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 8
	produces_heat = 0
	circuit = /obj/item/circuitboard/telecomms/relay
	netspeed = 5
	long_range_link = 1
	var/broadcasting = 1
	var/receiving = 1

/obj/machinery/telecomms/relay/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/telecomms/relay/onTransitZ(old_z, new_z)
	. = ..()
	listening_level = z

/obj/machinery/telecomms/relay/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	// Add our level and send it back
	if(can_send(signal))
		signal.data["level"] |= GLOB.using_map.get_map_levels(listening_level)

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return 0
	if(!is_freq_listening(signal))
		return 0
	return 1

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return 0
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return 0
	return receiving
