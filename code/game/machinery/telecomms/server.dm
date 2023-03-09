/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 100 logs and then deletes them.
*/


/obj/machinery/telecomms/server
	name = "Telecommunication Server"
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	machinetype = 4
	circuit = /obj/item/circuitboard/telecomms/server
	var/list/log_entries = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/obj/item/radio/headset/server_radio = null

	//? triangulation
	/// enabled?
	var/triangulating = FALSE
	/// tracking source tags to /datum/network_triangulation
	var/list/triangulation
	/// accuracy loss per decisecond
	var/triangulation_falloff = 1 / 60
	/// accuracy loss per tile
	var/triangulation_stickyness = 5 / 20
	/// triangulation efficiency multiplier
	var/triangulation_efficiency = 1

/obj/machinery/telecomms/server/Initialize(mapload)
	. = ..()
	server_radio = new()

/obj/machinery/telecomms/server/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/telecomms/server/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)

	if(signal.data["message"])

		if(is_freq_listening(signal))

			if(traffic > 0)
				totaltraffic += traffic // add current traffic to total traffic

			//Is this a test signal? Bypass logging
			if(signal.data["type"] != SIGNAL_TEST)
				if(signal.data["radio"] && triangulating)
					triangulate(signal.data["radio"], update_name = signal.data["name"])

				// If signal has a message and appropriate frequency

				update_logs()

				var/datum/comm_log_entry/log = new
				var/mob/M = signal.data["mob"]

				// Copy the signal.data entries we want
				log.parameters["mobtype"] = signal.data["mobtype"]
				log.parameters["job"] = signal.data["job"]
				log.parameters["key"] = signal.data["key"]
				log.parameters["vmessage"] = signal.data["message"]
				log.parameters["vname"] = signal.data["vname"]
				log.parameters["message"] = signal.data["message"]
				log.parameters["name"] = signal.data["name"]
				log.parameters["realname"] = signal.data["realname"]
				log.parameters["timecode"] = worldtime2stationtime(world.time)

				var/race = "unknown"
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					race = "[H.species.name]"
					log.parameters["intelligible"] = 1
				else if(isbrain(M))
					race = "Brain"
					log.parameters["intelligible"] = 1
				else if(M.isMonkey())
					race = "Monkey"
				else if(issilicon(M))
					race = "Artificial Life"
					log.parameters["intelligible"] = 1
				else if(isslime(M))
					race = "Slime"
				else if(isanimal(M))
					race = "Domestic Animal"

				log.parameters["race"] = race

				if(!istype(M, /mob/new_player) && M)
					log.parameters["uspeech"] = M.universal_speak
				else
					log.parameters["uspeech"] = 0

				// If the signal is still compressed, make the log entry gibberish
				if(signal.data["compression"] > 0)
					log.parameters["message"] = Gibberish(signal.data["message"], signal.data["compression"] + 50)
					log.parameters["job"] = Gibberish(signal.data["job"], signal.data["compression"] + 50)
					log.parameters["name"] = Gibberish(signal.data["name"], signal.data["compression"] + 50)
					log.parameters["realname"] = Gibberish(signal.data["realname"], signal.data["compression"] + 50)
					log.parameters["vname"] = Gibberish(signal.data["vname"], signal.data["compression"] + 50)
					log.input_type = "Corrupt File"

				// Log and store everything that needs to be logged
				log_entries.Add(log)
				logs++
				signal.data["server"] = src

				// Give the log a name
				var/identifier = num2text( rand(-1000,1000) + world.time )
				log.name = "data packet ([md5(identifier)])"

			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub")
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/broadcaster")

/obj/machinery/telecomms/server/proc/update_logs()
	// start deleting the very first log entry
	if(logs >= 400)
		for(var/i = 1, i <= logs, i++) // locate the first garbage collectable log entry and remove it
			var/datum/comm_log_entry/L = log_entries[i]
			if(L.garbage_collector)
				log_entries.Remove(L)
				logs--
				break

/obj/machinery/telecomms/server/proc/add_entry(var/content, var/input)
	var/datum/comm_log_entry/log = new
	var/identifier = num2text( rand(-1000,1000) + world.time )
	log.name = "[input] ([md5(identifier)])"
	log.input_type = input
	log.parameters["message"] = content
	log.parameters["timecode"] = stationtime2text()
	log_entries.Add(log)
	update_logs()

/obj/machinery/telecomms/server/proc/triangulation_data()
	. = list()
	if(!triangulation)
		return
	for(var/key in triangulation)
		var/datum/network_triangulation/T = triangulation[key]
		. += list(list(
			"name" = T.scan_name,
			"x" = T.random_x,
			"y" = T.random_y,
			"z" = SSmapping.level_id(T.random_z),
			"accuracy" = T.accuracy,
			"last" = world.time - T.last_updated,
			"tag" = key,
		))

/obj/machinery/telecomms/server/proc/triangulate(atom/movable/victim, reduction_factor = 1.8, update_name)
	if(isnull(triangulation))
		triangulation = list()

	reduction_factor *= triangulation_efficiency

	// if victim isn't even on a turf...
	var/turf/location = get_turf(victim)
	if(isnull(location))
		return

	// generate tag
	var/triangulation_tag = ismob(victim)? victim.tag : ref(victim)

	// grab or make entry, update location
	var/datum/network_triangulation/entry = triangulation[triangulation_tag]
	if(!entry)
		triangulation[triangulation_tag] = (entry = new)
		// starting at..
		entry.accuracy = round(max(world.maxx, world.maxy) / reduction_factor, 1)
	else
		// narrow down
		var/time_falloff = max(world.time - entry.last_updated, 0) * triangulation_falloff
		var/dist_falloff = entry.last_turf ? get_dist(entry.last_turf, location) * triangulation_stickyness : 0
		entry.accuracy = min(
			round(max(world.maxx, world.maxy) / reduction_factor, 1), // don't get worse than a first attempt
			(entry.accuracy + time_falloff + dist_falloff) / reduction_factor
		)

	// update name
	if(update_name)
		entry.scan_name = update_name

	entry.last_turf = location
	entry.last_updated = world.time
	entry.randomize(location)

/obj/machinery/telecomms/server/proc/set_triangulating(state)
	triangulating = state
	if(!state)
		triangulation = null

// Simple log entry datum

/datum/comm_log_entry
	var/parameters = list() // carbon-copy to signal.data[]
	var/name = "data packet (#)"
	var/garbage_collector = 1 // if set to 0, will not be garbage collected
	var/input_type = "Speech File"

/datum/network_triangulation
	/// name of target
	var/scan_name
	/// last x
	var/random_x
	/// last y
	var/random_y
	/// last real z index
	var/random_z
	/// last accuracy
	var/accuracy
	/// last update time
	var/last_updated
	/// last turf
	var/turf/last_turf

/datum/network_triangulation/proc/randomize(turf/real_loc)
	var/angle = rand(0, 360)
	var/dist = accuracy * sqrt(rand(1, 10000) * 0.0001)
	random_x = round(cos(angle) * dist, 1) + real_loc.x
	random_y = round(sin(angle) * dist, 1) + real_loc.y
	random_z = real_loc.z
