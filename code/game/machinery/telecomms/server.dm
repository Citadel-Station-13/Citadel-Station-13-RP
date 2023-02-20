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
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/list/memory = list()	// stored memory
	var/rawcode = ""	// the code to compile (raw text)
	var/autoruncode = 0		// 1 if the code is set to run every time a signal is picked up

	var/encryption = "null" // encryption key: ie "password"
	var/salt = "null"		// encryption salt: ie "123comsat"
							// would add up to md5("password123comsat")
	var/obj/item/radio/headset/server_radio = null

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
				if(!(signal.data["name"] in stored_names))
					stored_names.Add(signal.data["name"])
				logs++
				signal.data["server"] = src

				// Give the log a name
				var/identifier = num2text( rand(-1000,1000) + world.time )
				log.name = "data packet ([md5(identifier)])"

			var/can_send = relay_information(signal, "/obj/machinery/telecomms/hub")
			if(!can_send)
				relay_information(signal, "/obj/machinery/telecomms/broadcaster")


/obj/machinery/telecomms/server/proc/setcode(var/t)
	if(t)
		if(istext(t))
			rawcode = t

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

// Simple log entry datum

/datum/comm_log_entry
	var/parameters = list() // carbon-copy to signal.data[]
	var/name = "data packet (#)"
	var/garbage_collector = 1 // if set to 0, will not be garbage collected
	var/input_type = "Speech File"
