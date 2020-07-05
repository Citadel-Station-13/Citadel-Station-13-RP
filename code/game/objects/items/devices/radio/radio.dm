// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
GLOBAL_LIST_INIT(default_internal_channels, list(
//VOREStation Edit Start - Updating this for Virgo
	"[PUB_FREQ]" = list(),
	"[AI_FREQ]"  = list(access_synth),
	"[ENT_FREQ]" = list(),
	"[ERT_FREQ]" = list(access_cent_specops),
	"[COMM_FREQ]" = list(access_heads),
	"[ENG_FREQ]" = list(access_engine_equip, access_atmospherics),
	"[MED_FREQ]" = list(access_medical_equip),
	"[MED_I_FREQ]" =list(access_medical_equip),
	"[SEC_FREQ]" = list(access_security),
	"[SEC_I_FREQ]" =list(access_security),
	"[SCI_FREQ]" = list(access_tox, access_robotics, access_xenobiology, access_explorer),
	"[SUP_FREQ]" = list(access_cargo, access_mining_station),
	"[SRV_FREQ]" = list(access_janitor, access_library, access_hydroponics, access_bar, access_kitchen),
	"[EXP_FREQ]" = list(access_explorer, access_pilot, access_rd)
))

GLOBAL_LIST_INIT(default_medbay_channels, list(
	"[PUB_FREQ]" = list(),
	"[MED_FREQ]" = list(access_medical_equip),
	"[MED_I_FREQ]" = list(access_medical_equip)
))

/obj/item/radio
	icon = 'icons/obj/radio_vr.dmi' //VOREStation Edit
	name = "shortwave radio" //VOREStation Edit
	icon_state = "walkietalkie"
	item_state = "radio"
	desc = "A basic handheld radio that communicates with local telecommunication networks."
	suffix = "\[3\]" //the fuck is this

	slot_flags = SLOT_BELT
	matter = list("glass" = 25,DEFAULT_WALL_MATERIAL = 75)
	throw_speed = 3
	throw_range = 7
	w_class = ITEMSIZE_SMALL
	show_messages = 1 //??

	var/on = TRUE
	var/frequency = PUB_FREQ //FREQ_COMMON
	var/canhear_range = 3  // The range around the radio in which mobs can hear what it receives.
	var/emped = 0  // Tracks the number of EMPs currently stacked.

	var/broadcasting = FALSE  // Whether the radio will transmit dialogue it hears nearby.
	var/listening = TRUE  // Whether the radio is currently receiving.
	var/prison_radio = FALSE  // If true, the transmit wire starts cut.
	var/unscrewed = FALSE  // Whether wires are accessible. Toggleable by screwdrivering. Old var: b_stat
	var/freerange = FALSE  // If true, the radio has access to the full spectrum.
	var/subspace_transmission = FALSE  // If true, the radio transmits and receives on subspace exclusively.
	var/subspace_switchable = FALSE  // If true, subspace_transmission can be toggled at will.
	var/freqlock = FALSE  // Frequency lock to stop the user from untuning specialist radios.
	var/use_command = FALSE  // If true, broadcasts will be large and BOLD.
	var/command = FALSE  // If true, use_command can be toggled at will.
	var/commandspan = SPAN_COMMAND //allow us to set what the fuck we want for headsets

	// Encryption key handling
	var/obj/item/encryptionkey/keyslot //radios in general can now hold an EKey
	var/translate_binary = FALSE  // If true, can hear the special binary channel.
	var/independent = FALSE  // If true, can say/hear on the special CentCom channel. Old var: centComm
	var/syndie = FALSE  // If true, hears all well-known channels automatically, and can say/hear on the Syndicate channel.
	var/list/channels = list()  // Map from name (see communications.dm) to on/off. First entry is current department (:h).
	var/list/secure_radio_connections

	var/const/FREQ_LISTENING = 1
	//FREQ_BROADCASTING = 2

	//Old vars
	var/last_transmission
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/datum/wires/radio/wires = null //old wires
	var/adhoc_fallback = FALSE //Falls back to 'radio' mode if subspace not available
	var/list/internal_channels
	var/datum/radio_frequency/radio_connection

	//DEPRICATED VARS DO.NOT.USE.
	var/centComm = null //it's a null so if ever it isn't a null it means that it got VV'd in the mapeditor
	var/b_stat = null //about to be dead

/obj/item/radio/proc/set_frequency(new_frequency)
	// SEND_SIGNAL(src, COMSIG_RADIO_NEW_FREQUENCY, args) //what if... unless?
	// remove_radio(src, frequency)
	// frequency = add_radio(src, new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT) //ew

/obj/item/radio/proc/recalculateChannels() //does not recalculate internal_channels
	channels = list()
	translate_binary = FALSE //not set
	syndie = FALSE
	independent = FALSE //not set, CC

	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(!(ch_name in channels))
				channels[ch_name] = keyslot.channels[ch_name]

		if(keyslot.translate_binary)
			translate_binary = TRUE
		if(keyslot.syndie)
			syndie = TRUE
		// if(keyslot.independent)
		// 	independent = TRUE

	for(var/ch_name in channels) //assuming shitty radio controler gets loaded first (datums are new while this is init)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT) //add_radio(src, GLOB.radiochannels[ch_name])

/obj/item/radio/proc/make_syndie() // Turns normal radios into Syndicate radios!
	qdel(keyslot)
	keyslot = new /obj/item/encryptionkey/syndicate
	syndie = TRUE
	recalculateChannels()

/obj/item/radio/Destroy()
	// remove_radio_all(src) //Just to be sure
	QDEL_NULL(wires)
	QDEL_NULL(keyslot)

	listening_objects -= src //?
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	return ..()

/obj/item/radio/Initialize(mapload)
	if(centComm != null && mapload)
		log_mapping("WARNING: [src] has a centComm var which is depricated. Location: [COORD(src)], centComm value: [centComm]")
	if(b_stat != null && mapload)
		log_mapping("WARNING: [src] has a b_stat var which is depricated. Location: [COORD(src)], b_stat value: [b_stat]")
	//Yes, these should run first
	wires = new /datum/wires/radio(src)
	if(prison_radio)
		wires.CutWireIndex(WIRE_TRANSMIT) //cut(WIRE_TX) // OH GOD WHY
	secure_radio_connections = new
	. = ..()
	var/salt = freerange ? MIN_FREE_FREQ : MIN_FREQ
	var/pepper = freerange ? MAX_FREE_FREQ : MAX_FREQ
	frequency = sanitize_frequency(frequency, salt, pepper) //freerange, if that big pr of mine gets merged.
	set_frequency(frequency)
	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	internal_channels = GLOB.default_internal_channels.Copy() //better way of implementing this soon(never)
	listening_objects |= src // ??

/obj/item/radio/ComponentInitialize()
	. = ..()
	// AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)

/obj/item/radio/interact(mob/user)
	if(unscrewed && !isAI(user))
		wires.Interact(user)
		add_fingerprint(user)
	else
		// ui_interact(user)
		..()

/obj/item/radio/attack_self(mob/user)
	user.set_machine(src)
	ui_interact(user)

//stolen from the TGUI department
/obj/item/radio/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = FALSE, \
										datum/nanoui/master_ui = null, datum/topic_state/state = inventory_state)
	. = ..()
	//very fucking evil that nanoui dosen't use ui_data
	var/list/data = list()

	data["broadcasting"] = broadcasting
	data["listening"] = listening
	data["frequency"] = frequency
	data["minFrequency"] = freerange ? MIN_FREE_FREQ : MIN_FREQ
	data["maxFrequency"] = freerange ? MAX_FREE_FREQ : MAX_FREQ
	data["freqlock"] = freqlock
	data["channels"] = list()
	for(var/channel in channels)
		data["channels"][channel] = channels[channel] & FREQ_LISTENING
	data["command"] = command
	data["useCommand"] = use_command
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["headset"] = istype(src, /obj/item/radio/headset)

	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	data["useSyndMode"] = syndie

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		var/ui_width = 450  //360
		var/ui_height = 231 //106
		if(subspace_transmission)
			if(channels.len > 0)
				ui_height += 6 + channels.len * 21 //Fancy&trade;
			else
				ui_height += 24
		ui = new(user, src, ui_key, "radio_basic.tmpl", name, ui_width, ui_height)//, master_ui, state)
		ui.set_initial_data(data)
		ui.open()
	else
		ui.push_data(data) //ui gets updated but the data isn't, theoraticaly causing all data to null

/obj/item/radio/proc/list_channels(mob/user)
	return list_internal_channels(user)

/obj/item/radio/proc/list_secure_channels(mob/user)
	var/list/dat = list()

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = (chan_stat & FREQ_LISTENING)

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "chan_span" = frequency_span_class(radiochannels[ch_name]))))

	return dat

/obj/item/radio/proc/list_internal_channels(mob/user)
	var/list/dat = list()
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_name(text2num(internal_chan)), "chan_span" = frequency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/radio/proc/has_channel_access(mob/user, freq)
	if(!user)
		return FALSE

	if(!(freq in internal_channels))
		return FALSE

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(list/req_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/observer/dead/has_internal_radio_channel_access(list/req_one_accesses)
	return can_admin_interact()

/obj/item/radio/proc/text_wires() //who made this and why
	if(unscrewed)
		return wires.GetInteractWindow()

/obj/item/radio/proc/text_sec_channel(chan_name, chan_stat)
	var/canlisten = (chan_stat & FREQ_LISTENING) //for fuck sakes stop using internal vars REEEEEEEEEEEEEEEE
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=[REF(src)];ch_name=[chan_name];listen=[!canlisten]'>[canlisten ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/radio/proc/ToggleReception()
	listening = !listening && !(wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/radio/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if("frequency" in href_list) //the fuck, why are switches not working?
		if(freqlock)
			return
		var/tune = (frequency + text2num(href_list["freq"])) || MIN_FREQ
		if(href_list["input"]) //not access locked now, because that's fucking stupid
			var/min = format_frequency(freerange ? MIN_FREE_FREQ : MIN_FREQ)
			var/max = format_frequency(freerange ? MAX_FREE_FREQ : MAX_FREQ)
			tune = input("Tune frequency ([min]-[max]):", name, format_frequency(frequency)) as null|num //old input
			if(!isnull(tune) && !..())
				if (tune < MIN_FREE_FREQ && tune <= MAX_FREE_FREQ / 10)
					// allow typing 144.7 to get 1447
					tune *= 10
				. = TRUE
		else if(text2num(tune) != null)
			tune = tune
		. = TRUE
		if(.)
			var/salt = freerange ? MIN_FREE_FREQ : MIN_FREQ
			var/pepper = freerange ? MAX_FREE_FREQ : MAX_FREQ
			set_frequency(sanitize_frequency(tune, salt, pepper))
		if(hidden_uplink?.check_trigger(usr, frequency, traitor_frequency))
			usr << browse(null, "window=radio")
	else if("listen" in href_list)
		// listening = !listening
		ToggleReception()
		. = TRUE
	else if("broadcast" in href_list)
		// broadcasting = !broadcasting
		ToggleBroadcast()
		. = TRUE
	else if("channel" in href_list)
		var/channel = href_list["channel"]
		if(!(channel in channels))
			return
		if(channels[channel] & FREQ_LISTENING)
			channels[channel] &= ~FREQ_LISTENING
		else
			channels[channel] |= FREQ_LISTENING
		. = TRUE
	else if("command" in href_list)
		use_command = !use_command
		. = TRUE
	else if("subspace" in href_list)
		if(subspace_switchable)
			subspace_transmission = !subspace_transmission
			if(!subspace_transmission)
				channels = list()
			else
				recalculateChannels()
			. = TRUE
	else if("track" in href_list) //what?
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = TRUE

	if(.)
		SSnanoui.update_uis(src)

/obj/item/radio/proc/autosay(var/message, var/from, var/channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return

	var/static/mob/living/silicon/ai/announcer/A = new /mob/living/silicon/ai/announcer(src, null, null, 1)
	A.SetName(from)
	Broadcast_Message(connection, A,
						0, "*garbled automated announcement*", src,
						message, from, "Automated Announcement", from, "synthesized voice",
						4, 0, list(0), connection.frequency, "states")

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/radio/proc/handle_message_mode(mob/living/M as mob, message, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if (message_mode == "department") // Department radio shortcut
			message_mode = channels[1]

		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/radio/talk_into(mob/living/M, message, channel, var/verb = "says", datum/language/speaking)
	if(!on)
		return FALSE // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message)
		return FALSE

	if(speaking && (speaking.flags & (SIGNLANG|NONVERBAL)))
		return FALSE

	if(istype(M))
		M.trigger_aiming(TARGET_CAN_RADIO)

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE

	if(!radio_connection)
		set_frequency(frequency)

	//do some message magic because holy shit i'm not gonna port the telecomms rewrite (yet)
	if(use_command && command && commandspan)
		message = "<span class=[commandspan]>[message]</span>"

	/* Quick introduction:
		This new radio system uses a very robust FTL signaling technology unoriginally
		dubbed "subspace" which is somewhat similar to 'blue-space' but can't
		actually transmit large mass. Headsets are the only radio devices capable
		of sending subspace transmissions to the Communications Satellite.

		A headset sends a signal to a subspace listener/reciever elsewhere in space,
		the signal gets processed and logged, and an audible transmission gets sent
		to each individual headset.
	*/

	//#### Grab the connection datum ####//
	var/datum/radio_frequency/connection = handle_message_mode(M, message, channel)
	if (!istype(connection))
		return FALSE

	var/turf/position = get_turf(src)

	//#### Tagging the signal with all appropriate identity values ####//

	// ||-- The mob's name identity --||
	var/displayname = M.name	// grab the display name (name you get when you hover over someone's icon)
	var/real_name = M.real_name // mob's real name
	var/mobkey = "none" // player key associated with mob
	var/voicemask = 0 // the speaker is wearing a voice mask
	if(M.client)
		mobkey = M.key // assign the mob's key


	var/jobname // the mob's "job"

	// --- Human: use their actual job ---
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		jobname = H.get_assignment()

	// --- Carbon Nonhuman ---
	else if (iscarbon(M)) // Nonhuman carbon mob
		jobname = "No id"

	// --- AI ---
	else if (isAI(M))
		jobname = "AI"

	// --- Cyborg ---
	else if (isrobot(M))
		jobname = "Cyborg"

	// --- Personal AI (pAI) ---
	else if (istype(M, /mob/living/silicon/pai))
		jobname = "Personal AI"

	// --- Unidentifiable mob ---
	else
		jobname = "Unknown"


	// --- Modifications to the mob's identity ---

	// The mob is disguising their identity:
	if (ishuman(M) && M.GetVoice() != real_name)
		displayname = M.GetVoice()
		jobname = "Unknown"
		voicemask = 1



  /* ###### Radio headsets can only broadcast through subspace ###### */
	if(subspace_transmission)
		var/list/jamming = is_jammed(src)
		if(jamming)
			var/distance = jamming["distance"]
			to_chat(M,"<span class='danger'>[icon2html(src, M)] You hear the [distance <= 2 ? "loud hiss" : "soft hiss"] of static.</span>")
			return FALSE

		// First, we want to generate a new radio signal
		var/datum/signal/signal = new
		// >subspace signal
		// >> datum isn't even /datum/signal/subspace/vocal
		signal.transmission_method = TRANSMISSION_SUBSPACE

		// --- Finally, tag the actual signal with the appropriate values ---
		signal.data = list(
		  // Identity-associated tags:
			"mob" = M, // store a reference to the mob
			"mobtype" = M.type, 	// the mob's type
			"realname" = real_name, // the mob's real name
			"name" = displayname,	// the mob's display name
			"job" = jobname,		// the mob's job
			"key" = mobkey,			// the mob's key
			"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
			"vname" = M.voice_name, // the name to display if the voice wasn't understood
			"vmask" = voicemask,	// 1 if the mob is using a voice gas mask

			// We store things that would otherwise be kept in the actual mob
			// so that they can be logged even AFTER the mob is deleted or something

		  // Other tags:
			"compression" = rand(45,50), // compressed radio signal
			"message" = message, // the actual sent message
			"connection" = connection, // the radio connection to use
			"radio" = src, // stores the radio used for transmission
			"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
			"traffic" = 0, // dictates the total traffic sum that the signal went through
			"type" = 0, // determines what type of radio input it is: normal broadcast
			"server" = null, // the last server to log this signal
			"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting machinery
			"level" = position.z, // The source's z level
			"language" = speaking,
			"verb" = verb
		)
		signal.frequency = connection.frequency // Quick frequency set

	  //#### Sending the signal to all subspace receivers ####//

		for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
			R.receive_signal(signal)

		// Receiving code can be located in Telecommunications.dm
		if(signal.data["done"] && (position.z in signal.data["level"]))
			return TRUE //Huzzah, sent via subspace

		else if(adhoc_fallback) //Less huzzah, we have to fallback
			to_chat(loc,"<span class='warning'>\The [src] pings as it falls back to local radio transmission.</span>")
			subspace_transmission = FALSE
			return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  signal.transmission_method, signal.data["compression"], GetConnectedZlevels(position.z), connection.frequency,verb,speaking)

  /* ###### Intercoms and station-bounced radios ###### */

	var/filter_type = 2

	/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
	if(istype(src, /obj/item/radio/intercom))
		filter_type = 1


	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_SUBSPACE //this is the backup transmission, the define should be TRANSMISSION_RADIO

	/* --- Try to send a normal subspace broadcast first */

	signal.data = list(

		"mob" = M, // store a reference to the mob
		"mobtype" = M.type, 	// the mob's type
		"realname" = real_name, // the mob's real name
		"name" = displayname,	// the mob's display name
		"job" = jobname,		// the mob's job
		"key" = mobkey,			// the mob's key
		"vmessage" = pick(M.speak_emote), // the message to display if the voice wasn't understood
		"vname" = M.voice_name, // the name to display if the voice wasn't understood
		"vmask" = voicemask,	// 1 if the mob is using a voice gas mas

		"compression" = 0, // uncompressed radio signal
		"message" = message, // the actual sent message
		"connection" = connection, // the radio connection to use
		"radio" = src, // stores the radio used for transmission
		"slow" = 0,
		"traffic" = 0,
		"type" = 0,
		"server" = null,
		"reject" = 0,
		"level" = position.z,
		"language" = speaking,
		"verb" = verb
	)
	signal.frequency = connection.frequency // Quick frequency set

	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	if(signal.data["done"] && (position.z in signal.data["level"]))
		if(adhoc_fallback)
			to_chat(loc,"<span class='notice'>\The [src] pings as it reestablishes subspace communications.</span>")
			subspace_transmission = TRUE
		// we're done here.
		return TRUE

	// Oh my god; the comms are down or something because the signal hasn't been broadcasted yet in our level.
	// Send a mundane broadcast with limited targets:

	//THIS IS TEMPORARY. YEAH RIGHT
	if(!connection)
		return FALSE	//~Carn

//VOREStation Add Start
	if(bluespace_radio)
		return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  0, signal.data["compression"], list(0), connection.frequency,verb,speaking)
//VOREStation Add End

	return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  filter_type, signal.data["compression"], GetConnectedZlevels(position.z), connection.frequency,verb,speaking)


/obj/item/radio/hear_talk(mob/M, msg, var/verb = "says", datum/language/speaking = null)
	if (broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg, null, verb, speaking)

// Checks if this radio can receive on the given frequency.
/obj/item/radio/proc/can_receive(freq, level)
	// deny checks
	if(!on || !listening || wires.IsIndexCut(WIRE_RECEIVE))
		return FALSE
	if ((freq in ANTAG_FREQS) && !syndie)
		return FALSE
	if (freq in CENT_FREQS)
		return independent  // hard-ignores the z-level check
	if (!(0 in level))
		var/turf/position = get_turf(src)
		if((!position || !(position.z in level)) && !bluespace_radio) // >bluespace radio >we already have subspace ones
			return FALSE
	if(is_jammed(src))
		return FALSE

	// allow checks: are we listening on that frequency?
	if (freq == frequency)
		return TRUE
	for(var/ch_name in channels)
		// if(channels[ch_name] & FREQ_LISTENING)
			// the GLOB.radiochannels list is located in communications.dm
		// 	if(GLOB.radiochannels[ch_name] == text2num(freq) || syndie)
		// 		return TRUE
		var/datum/radio_frequency/RF = secure_radio_connections[ch_name] //the fuck is this crime
		if (RF?.frequency == freq && (channels[ch_name] & FREQ_LISTENING))
			return TRUE

	return FALSE

/obj/item/radio/proc/send_hear(freq, level)
	if(can_receive(freq, level))
		return get_mobs_or_objects_in_view(canhear_range, src)

/obj/item/radio/examine(mob/user)
	. = ..()
	if (unscrewed)
		. += "<span class='notice'>It can be attached and modified.</span>"
	else
		. += "<span class='notice'>It cannot be modified or attached.</span>"


/obj/item/radio/attackby(obj/item/W, mob/user)
	if (!W.is_screwdriver())
		unscrewed = !unscrewed
		if(unscrewed)
			to_chat(user, "<span class='notice'>The radio can now be attached and modified!</span>")
		else
			to_chat(user, "<span class='notice'>The radio can no longer be modified or attached!</span>")
	else
		return ..()

/obj/item/radio/emp_act(severity)
	. = ..()
	// if (. & EMP_PROTECT_SELF)
	// 	return
	emped++ //There's been an EMP; better count it
	var/curremp = emped //Remember which EMP this was
	if (listening && ismob(loc))	// if the radio is turned on and on someone's person they notice
		to_chat(loc, "<span class='warning'>\The [src] overloads.</span>")
	broadcasting = FALSE
	listening = FALSE
	for (var/ch_name in channels)
		channels[ch_name] = 0
	on = FALSE
	spawn(200)
		if(emped == curremp) //Don't fix it if it's been EMP'd again
			emped = 0
			if (!istype(src, /obj/item/radio/intercom)) // intercoms will turn back on on their own
				on = TRUE

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/radio/borg
	name = "cyborg radio"
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	subspace_switchable = TRUE
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks. no it's not dummy, src.loc is the borg already.

/obj/item/radio/borg/Initialize(mapload)
	if(myborg != null && mapload)
		log_mapping("WARNING: [src] has a myborg var which is depricated. Location: [COORD(src)], myborg value: [myborg]")
	. = ..()

/obj/item/radio/borg/Destroy()
	myborg = null
	return ..()

/obj/item/radio/borg/syndicate
	syndie = TRUE
	keyslot = new /obj/item/encryptionkey/syndicate

/obj/item/radio/borg/syndicate/Initialize()
	. = ..()
	set_frequency(FREQ_SYNDICATE)

/obj/item/radio/borg/list_channels(mob/user)
	return list_secure_channels(user)

/obj/item/radio/borg/talk_into()
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/radio/borg/attackby(obj/item/W, mob/user, params)

	if(W.is_screwdriver())
		if(keyslot)
			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.forceMove(T)
					keyslot = null

			recalculateChannels()
			playsound(src, W.usesound, 50, TRUE)
			to_chat(user, "<span class='notice'>You pop out the encryption key in the radio.</span>")

		else
			to_chat(user, "<span class='warning'>This radio doesn't have any encryption keys!</span>")

	else if(istype(W, /obj/item/encryptionkey/))
		if(keyslot)
			to_chat(user, "<span class='warning'>The radio can't hold another key!</span>")
			return

		if(!keyslot)
			// if(!user.transferItemToLoc(W, src))
			// 	return
			user.drop_item()
			W.loc = src
			keyslot = W

		recalculateChannels()

/obj/item/radio/proc/config(op)
	if(radio_controller)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	secure_radio_connections = new
	channels = op
	if(radio_controller)
		for (var/ch_name in op)
			secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
	return

/obj/item/radio/off	// Station bounced radios, their only difference is spawning with the speakers off, this was made to help the lag.
	listening = FALSE			// And it's nice to have a subtype too for future features.

/obj/item/radio/phone
	name = "phone" //he bought? domp-eet
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	broadcasting = FALSE
	listening = TRUE

/obj/item/radio/phone/medbay
	frequency = MED_I_FREQ

/obj/item/radio/phone/medbay/Initialize(mapload)
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()
