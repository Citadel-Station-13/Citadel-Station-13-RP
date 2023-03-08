/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
	NOTE: This AIO device listens on *every* zlevel (it does not even check)
*/

/obj/machinery/telecomms/allinone
	name = "Telecommunications Mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "allinone"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	anchored = 1
	machinetype = 6
	produces_heat = 0
	var/intercept = 0 // if nonzero, broadcasts all messages to syndicate channel
	var/overmap_range = 0 //Same turf

	var/list/linked_radios_weakrefs = list()

/obj/machinery/telecomms/allinone/proc/link_radio(var/obj/item/radio/R)
	if(!istype(R))
		return
	linked_radios_weakrefs |= WEAKREF(R)

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/signal)

	// Has to be on to receive messages
	if(!on)
		return

	// Why did you use this subtype?
	if(!GLOB.using_map.use_overmap)
		return

	// Someone else handling it?
	if(signal.data["done"])
		return

	// Where are we able to hear from (and talk to, since we're AIO) anyway?
	var/map_levels = GLOB.using_map.get_map_levels(z, TRUE, overmap_range)

	//Bluespace can skip this check
	if(signal.transmission_method != TRANSMISSION_BLUESPACE)
		var/list/signal_levels = list()
		signal_levels += signal.data["level"] //If it's text/number, it'll be the only entry, if it's a list, it'll get combined
		var/list/overlap = map_levels & signal_levels //Returns a list of similar levels
		if(!overlap.len)
			return

	if(is_freq_listening(signal)) // detect subspace signals

		signal.data["done"] = 1 // mark the signal as being broadcasted since we're a broadcaster
		signal.data["compression"] = 0 // decompress since we're a processor

		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1

		// For some reason level is both used as a list and not a list, and now it needs to be a list.
		signal.data["level"] = map_levels

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		/* ###### Broadcast a message using signal.data ###### */

		var/datum/radio_frequency/connection = signal.data["connection"]

		var/list/forced_radios
		for(var/datum/weakref/wr in linked_radios_weakrefs)
			var/obj/item/radio/R = wr.resolve()
			if(istype(R))
				LAZYDISTINCTADD(forced_radios, R)

		Broadcast_Message(
			signal.data["connection"],
			signal.data["mob"],
			signal.data["vmask"],
			signal.data["vmessage"],
			signal.data["radio"],
			signal.data["message"],
			signal.data["name"],
			signal.data["job"],
			signal.data["realname"],
			signal.data["vname"],
			DATA_NORMAL,
			signal.data["compression"],
			signal.data["level"],
			connection.frequency,
			signal.data["verb"],
			signal.data["language"],
			forced_radios
		)

//Antag version with unlimited range (doesn't even check) and uses no power, to enable antag comms to work anywhere.
/obj/machinery/telecomms/allinone/antag
	use_power = USE_POWER_OFF
	idle_power_usage = 0

/obj/machinery/telecomms/allinone/antag/receive_signal(datum/signal/signal)
	if(!on) // has to be on to receive messages
		return

	if(is_freq_listening(signal)) // detect subspace signals

		//signal.data["done"] = 1 // mark the signal as being broadcasted since we're a broadcaster
		signal.data["compression"] = 0

		/*
		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1
		*/

		// For some reason level is both used as a list and not a list, and now it needs to be a list.
		// Because this is a 'all in one' machine, we're gonna just cheat.
		//signal.data["level"] = GLOB.using_map.contact_levels.Copy()

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		/* ###### Broadcast a message using signal.data ###### */

		var/datum/radio_frequency/connection = signal.data["connection"]

		var/list/forced_radios
		for(var/datum/weakref/wr in linked_radios_weakrefs)
			var/obj/item/radio/R = wr.resolve()
			if(istype(R))
				LAZYDISTINCTADD(forced_radios, R)

		if(connection.frequency in ANTAG_FREQS) // if antag broadcast, just
			Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"], DATA_NORMAL,
							  signal.data["compression"], list(0), connection.frequency,
							  signal.data["verb"], signal.data["language"], forced_radios)
		else
			if(intercept)
				Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"], DATA_ANTAG,
							  signal.data["compression"], list(0), connection.frequency,
							  signal.data["verb"], signal.data["language"], forced_radios)

//ERT version with unlimited range (doesn't even check) and uses no power, to enable ert comms to work anywhere.
/obj/machinery/telecomms/allinone/ert
	use_power = USE_POWER_OFF
	idle_power_usage = 0

/obj/machinery/telecomms/allinone/ert/receive_signal(datum/signal/signal)
	if(!on) // has to be on to receive messages
		return

	if(is_freq_listening(signal)) // detect subspace signals

		//signal.data["done"] = 1 // mark the signal as being broadcasted since we're a broadcaster
		signal.data["compression"] = 0

		/*
		// Search for the original signal and mark it as done as well
		var/datum/signal/original = signal.data["original"]
		if(original)
			original.data["done"] = 1
		*/

		// For some reason level is both used as a list and not a list, and now it needs to be a list.
		// Because this is a 'all in one' machine, we're gonna just cheat.
		//signal.data["level"] = GLOB.using_map.contact_levels.Copy()

		if(signal.data["slow"] > 0)
			sleep(signal.data["slow"]) // simulate the network lag if necessary

		/* ###### Broadcast a message using signal.data ###### */

		var/datum/radio_frequency/connection = signal.data["connection"]

		var/list/forced_radios
		for(var/datum/weakref/wr in linked_radios_weakrefs)
			var/obj/item/radio/R = wr.resolve()
			if(istype(R))
				LAZYDISTINCTADD(forced_radios, R)

		if(connection.frequency in CENT_FREQS) // if ert broadcast, just
			Broadcast_Message(signal.data["connection"], signal.data["mob"],
							  signal.data["vmask"], signal.data["vmessage"],
							  signal.data["radio"], signal.data["message"],
							  signal.data["name"], signal.data["job"],
							  signal.data["realname"], signal.data["vname"], DATA_NORMAL,
							  signal.data["compression"], list(0), connection.frequency,
							  signal.data["verb"], signal.data["language"], forced_radios)
