/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "Subspace Receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	machinetype = 1
	produces_heat = 0
	circuit = /obj/item/circuitboard/telecomms/receiver
	//Vars only used if you're using the overmap
	var/overmap_range = 0
	var/overmap_range_min = 0
	var/overmap_range_max = 5

	var/list/linked_radios_weakrefs = list()

/obj/machinery/telecomms/receiver/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/telecomms/receiver/proc/link_radio(var/obj/item/radio/R)
	if(!istype(R))
		return
	linked_radios_weakrefs |= WEAKREF(R)

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/signal)
	if(!on) // has to be on to receive messages
		return
	if(!signal)
		return
	if(!check_receive_level(signal))
		return

	if(signal.transmission_method == TRANSMISSION_SUBSPACE)

		if(is_freq_listening(signal)) // detect subspace signals

			//Remove the level and then start adding levels that it is being broadcasted in.
			signal.data["level"] = list()

			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub") // ideally relay the copied information to relays
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/bus") // Send it to a bus instead, if it's linked to one

/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/signal)
	// If it's a direct message from a bluespace radio, we eat it and convert it into a subspace signal locally
	if(signal.transmission_method == TRANSMISSION_BLUESPACE)
		var/obj/item/radio/R = signal.data["radio"]

		//Who're you?
		if(!(WEAKREF(R) in linked_radios_weakrefs))
			signal.data["reject"] = 1
			return 0

		//We'll resend this for you
		signal.data["level"] = z
		signal.transmission_method = TRANSMISSION_SUBSPACE
		return 1

	//Where can we hear?
	var/list/listening_levels = GLOB.using_map.get_map_levels(listening_level, TRUE, overmap_range)

	// We couldn't 'hear' it, maybe a relay linked to our hub can 'hear' it
	if(!(signal.data["level"] in listening_levels))
		for(var/obj/machinery/telecomms/hub/H in links)
			var/list/relayed_levels = list()
			for(var/obj/machinery/telecomms/relay/R in H.links)
				if(R.can_receive(signal))
					relayed_levels |= R.listening_level
			if(signal.data["level"] in relayed_levels)
				return 1
		return 0
	return 1
