// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
GLOBAL_LIST_INIT(default_internal_channels, list(
//VOREStation Edit Start - Updating this for Virgo
	num2text(PUB_FREQ) = list(),
	num2text(AI_FREQ)  = list(access_synth),
	num2text(ENT_FREQ) = list(),
	num2text(ERT_FREQ) = list(access_cent_specops),
	num2text(COMM_FREQ)= list(access_heads),
	num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ)=list(access_medical_equip),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SEC_I_FREQ)=list(access_security),
	num2text(SCI_FREQ) = list(access_tox, access_robotics, access_xenobiology, access_explorer),
	num2text(SUP_FREQ) = list(access_cargo, access_mining_station),
	num2text(SRV_FREQ) = list(access_janitor, access_library, access_hydroponics, access_bar, access_kitchen),
	num2text(EXP_FREQ) = list(access_explorer, access_pilot, access_rd)
))

GLOBAL_LIST_INIT(default_medbay_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ) = list(access_medical_equip)
))

/obj/item/radio
	icon = 'icons/obj/radio_vr.dmi' //VOREStation Edit
	name = "shortwave radio" //VOREStation Edit
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "radio"

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = 0
	var/adhoc_fallback = FALSE //Falls back to 'radio' mode if subspace not available
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	var/centComm = 0//Holder to see if it's a CentCom encrypted radio
	var/bluespace_radio = FALSE
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	show_messages = 1

	matter = list("glass" = 25,DEFAULT_WALL_MATERIAL = 75)
	var/const/FREQ_LISTENING = 1
	var/list/internal_channels

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

/obj/item/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/radio/Initialize(mapload)
	. = ..()
	wires = new(src)
	internal_channels = GLOB.default_internal_channels.Copy()
	listening_objects += src
	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	set_frequency(frequency)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

/obj/item/radio/Destroy()
	qdel(wires)
	wires = null
	listening_objects -= src
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
		for (var/ch_name in channels)
			radio_controller.remove_object(src, radiochannels[ch_name])
	return ..()

/obj/item/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/radio/interact(mob/user)
	if(!user)
		return FALSE

	if(b_stat)
		wires.Interact(user)

	return nano_ui_interact(user)

/obj/item/radio/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = !!(chan_stat & FREQ_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "chan_span" = frequency_span_class(radiochannels[ch_name]))))

	return dat

/obj/item/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_name(text2num(internal_chan)), "chan_span" = frequency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/radio/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return FALSE

	if(!(freq in internal_channels))
		return FALSE

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/observer/dead/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/radio/proc/text_wires()
	if (b_stat)
		return wires.GetInteractWindow()
	return


/obj/item/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
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
		return TRUE

	usr.set_machine(src)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = 1

	else if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				usr << browse(null, "window=radio")
		. = 1
	else if (href_list["talk"])
		ToggleBroadcast()
		. = 1
	else if (href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if (!chan_name)
			ToggleReception()
		else
			if (channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING
		. = 1
	else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = 1
	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return TRUE

	if(.)
		SSnanoui.update_uis(src)

/obj/item/radio/proc/autosay(var/message, var/from, var/channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			//to_chat(world, "DEBUG: channel=\"[channel]\" switching to \"[channels[1]]\"")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return

	var/static/mob/living/silicon/ai/announcer/A = new /mob/living/silicon/ai/announcer(null, null, null, 1)
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

/obj/item/radio/talk_into(mob/living/M as mob, message, channel, var/verb = "says", var/datum/language/speaking = null)
	if(!on) return FALSE // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message) return FALSE

	if(speaking && (speaking.flags & (SIGNLANG|NONVERBAL))) return FALSE

	if(istype(M)) M.trigger_aiming(TARGET_CAN_RADIO)

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE

	if(!radio_connection)
		set_frequency(frequency)

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
			to_chat(M,"<span class='danger'>[icon2html(thing = src, target = M)] You hear the [distance <= 2 ? "loud hiss" : "soft hiss"] of static.</span>")
			return FALSE

		// First, we want to generate a new radio signal
		var/datum/signal/signal = new
		signal.transmission_method = 2 // 2 would be a subspace transmission.
									   // transmission_method could probably be enumerated through #define. Would be neater.

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

		for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in GLOB.telecomms_list)
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
	signal.transmission_method = 2


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

	for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
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
	if(!connection)	return FALSE	//~Carn

//VOREStation Add Start
	if(bluespace_radio)
		return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  0, signal.data["compression"], list(0), connection.frequency,verb,speaking)
//VOREStation Add End

	return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
					  src, message, displayname, jobname, real_name, M.voice_name,
					  filter_type, signal.data["compression"], GetConnectedZlevels(position.z), connection.frequency,verb,speaking)


/obj/item/radio/hear_talk(mob/M as mob, msg, var/verb = "says", var/datum/language/speaking = null)
	if (broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg,null,verb,speaking)


/*
/obj/item/radio/proc/accept_rad(obj/item/radio/R as obj, message)

	if ((R.frequency == frequency && message))
		return TRUE
	else if

	else
		return null
	return
*/


/obj/item/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if (wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1
	if(is_jammed(src))
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if((!position || !(position.z in level)) && !bluespace_radio) //VOREStation Edit
			return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if(freq in CENT_FREQS)
		if(!(src.centComm))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if (!on)
		return -1
	if (!freq) //recieved on main frequency
		if (!listening)
			return -1
	else
		var/accept = (freq==frequency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if (RF && RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
					accept = 1
					break
		if (!accept)
			return -1
	return canhear_range

/obj/item/radio/proc/send_hear(freq, level)

	var/range = receive_range(freq, level)
	if(range > -1)
		return get_mobs_or_objects_in_view(canhear_range, src)


/obj/item/radio/examine(mob/user)
	. = ..()
	if ((in_range(src, user) || loc == user))
		if (b_stat)
			. += "<span class='notice'>\The [src] can be attached and modified!</span>"
		else
			. += "<span class='notice'>\The [src] can not be modified or attached!</span>"
	return

/obj/item/radio/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.set_machine(src)
	if (!W.is_screwdriver())
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/radio/beacon))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can now be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can no longer be modified or attached!</span>")
		updateDialog()
			//Foreach goto(83)
		add_fingerprint(user)
		return
	else return

/obj/item/radio/emp_act(severity)
	broadcasting = 0
	listening = 0
	for (var/ch_name in channels)
		channels[ch_name] = 0
	..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/radio/borg
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	var/shut_up = 1
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = 1

/obj/item/radio/borg/Destroy()
	myborg = null
	return ..()

/obj/item/radio/borg/list_channels(var/mob/user)
	return list_secure_channels(user)

/obj/item/radio/borg/talk_into()
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/radio/borg/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if (!(W.is_screwdriver() || istype(W, /obj/item/encryptionkey)))
		return

	if(W.is_screwdriver())
		if(keyslot)


			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.loc = T
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")
			playsound(src, W.usesound, 50, 1)

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_item()
			W.loc = src
			keyslot = W

		recalculateChannels()

	return

/obj/item/radio/borg/proc/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(D.module)
		for(var/ch_name in D.module.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += D.module.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			src.syndie = 1

	for (var/ch_name in src.channels)
		if(!radio_controller)
			src.name = "CONTACT CODERS: NO RADIO CONTROLLER"
			return

		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	return

/obj/item/radio/borg/Topic(href, href_list)
	if(..())
		return TRUE
	if (href_list["mode"])
		var/enable_subspace_transmission = text2num(href_list["mode"])
		if(enable_subspace_transmission != subspace_transmission)
			subspace_transmission = !subspace_transmission
			if(subspace_transmission)
				to_chat(usr, "<span class='notice'>Subspace Transmission is enabled</span>")
			else
				to_chat(usr, "<span class='notice'>Subspace Transmission is disabled</span>")

			if(subspace_transmission == 0)//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
				channels = list()
			else
				recalculateChannels()
		. = 1
	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list["shutup"])
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, "<span class='notice'>Loadspeaker disabled.</span>")
			else
				canhear_range = 3
				to_chat(usr, "<span class='notice'>Loadspeaker enabled.</span>")
		. = 1

	if(.)
		SSnanoui.update_uis(src)

/obj/item/radio/borg/interact(mob/user as mob)
	if(!on)
		return

	. = ..()

/obj/item/radio/borg/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	data["has_loudspeaker"] = 1
	data["loudspeaker"] = !shut_up
	data["has_subspace"] = 1
	data["subspace"] = subspace_transmission

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

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

/obj/item/radio/off
	listening = 0

/obj/item/radio/phone
	broadcasting = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	listening = 1
	name = "phone"
	anchored = FALSE

/obj/item/radio/phone/medbay
	frequency = MED_I_FREQ

/obj/item/radio/phone/medbay/Initialize(mapload)
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()

//Consolidation from radio_vr.
/obj/item/radio/phone
	subspace_transmission = 1
	canhear_range = 0
	adhoc_fallback = TRUE

/obj/item/radio/emergency
	name = "Medbay Emergency Radio Link"
	icon_state = "med_walkietalkie"
	frequency = MED_I_FREQ
	subspace_transmission = 1
	adhoc_fallback = TRUE

/obj/item/radio/emergency/Initialize(mapload)
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()

//Pathfinder's Subspace Radio
/obj/item/subspaceradio
	name = "subspace radio"
	desc = "A powerful new radio originally gifted to Nanotrasen from Ward Takahashi. Immensely expensive, this communications device has the ability to send and recieve transmissions from anywhere."
	catalogue_data = list()///datum/category_item/catalogue/information/organization/ward_takahashi)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	action_button_name = "Remove/Replace Handset"

	var/obj/item/radio/subspacehandset/linked/handset = /obj/item/radio/subspacehandset/linked

/obj/item/subspaceradio/Initialize(Mapload) //starts without a cell for rnd
	. = ..()
	handset = new(src, src)

/obj/item/subspaceradio/Destroy()
	. = ..()
	QDEL_NULL(handset)

/obj/item/subspaceradio/ui_action_click()
	toggle_handset()

/obj/item/subspaceradio/attack_hand(mob/user)
	if(loc == user)
		toggle_handset()
	else
		..()

/obj/item/subspaceradio/MouseDrop()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		if(!M.unEquip(src))
			return
		add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

/obj/item/subspaceradio/attackby(obj/item/W, mob/user, params)
	if(W == handset)
		reattach_handset(user)
	else
		return ..()

/obj/item/subspaceradio/verb/toggle_handset()
	set name = "Toggle Handset"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!handset)
		to_chat(user, "<span class='warning'>The handset is missing!</span>")
		return

	if(handset.loc != src)
		reattach_handset(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [handset].</span>")
	else
		if(!usr.put_in_hands(handset)) //Detach the handset into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the handset!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/subspaceradio/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/subspaceradio/dropped(mob/user)
	..()
	reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/subspaceradio/proc/reattach_handset(mob/user)
	if(!handset) return

	if(ismob(handset.loc))
		var/mob/M = handset.loc
		if(M.drop_from_inventory(handset, src))
			to_chat(user, "<span class='notice'>\The [handset] snaps back into the main unit.</span>")
	else
		handset.forceMove(src)

//Subspace Radio Handset
/obj/item/radio/subspacehandset
	name = "subspace radio handset"
	desc = "A large walkie talkie attached to the subspace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon_state = "signaller"
	slot_flags = null
	w_class = ITEMSIZE_LARGE

/obj/item/radio/subspacehandset/linked
	var/obj/item/subspaceradio/base_unit

/obj/item/radio/subspacehandset/linked/Initialize(mapload, obj/item/subspaceradio/radio)
	base_unit = radio
	return ..(mapload)

/obj/item/radio/subspacehandset/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.handset == src)
			base_unit.handset = null
		base_unit = null
	return ..()

/obj/item/radio/subspacehandset/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/subspaceradio/commerce
	name = "commercial subspace radio"
	desc = "Immensely expensive, this communications device has the ability to send and recieve transmissions from anywhere. Only a few of these devices have been sold by either Ward Takahashi or NanoTrasen. This device is incredibly rare and mind-numbingly expensive. Do not lose it."
