// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
GLOBAL_LIST_INIT(default_internal_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(AI_FREQ)  = list(ACCESS_SPECIAL_SILICONS),
	num2text(ENT_FREQ) = list(),
	num2text(ERT_FREQ) = list(ACCESS_CENTCOM_ERT),
	num2text(COMM_FREQ)= list(ACCESS_COMMAND_BRIDGE),
	num2text(ENG_FREQ) = list(ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_ATMOS),
	num2text(MED_FREQ) = list(ACCESS_MEDICAL_EQUIPMENT),
	num2text(MED_I_FREQ)=list(ACCESS_MEDICAL_EQUIPMENT),
	num2text(SEC_FREQ) = list(ACCESS_SECURITY_EQUIPMENT),
	num2text(SEC_I_FREQ)=list(ACCESS_SECURITY_EQUIPMENT),
	num2text(SCI_FREQ) = list(ACCESS_SCIENCE_FABRICATION, ACCESS_SCIENCE_ROBOTICS, ACCESS_SCIENCE_XENOBIO, ACCESS_GENERAL_EXPLORER),
	num2text(SUP_FREQ) = list(ACCESS_SUPPLY_BAY, ACCESS_SUPPLY_MINE_OUTPOST),
	num2text(SRV_FREQ) = list(ACCESS_GENERAL_JANITOR, ACCESS_GENERAL_LIBRARY, ACCESS_GENERAL_BOTANY, ACCESS_GENERAL_BAR, ACCESS_GENERAL_KITCHEN),
	num2text(EXP_FREQ) = list(ACCESS_GENERAL_EXPLORER, ACCESS_GENERAL_PILOT, ACCESS_SCIENCE_RD)
))

GLOBAL_LIST_INIT(default_medbay_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(ACCESS_MEDICAL_EQUIPMENT),
	num2text(MED_I_FREQ) = list(ACCESS_MEDICAL_EQUIPMENT)
))

/obj/item/radio
	icon = 'icons/obj/radio.dmi'
	name = "shortwave radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "radio"

	///FALSE for off
	var/on = TRUE
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	///Tune to frequency to unlock traitor supplies
	var/traitor_frequency = 0
	///The range which mobs can hear this radio from
	var/canhear_range = 3
	///Allows borgs to disable canhear_range.
	var/loudspeaker = TRUE
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = FALSE
	var/listening = TRUE
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = FALSE
	var/subspace_switchable = FALSE
	///Falls back to 'radio' mode if subspace not available
	var/adhoc_fallback = FALSE
	///Holder to see if it's a syndicate encrypted radio
	var/syndie = FALSE
	///Holder to see if it's a CentCom encrypted radio
	var/centComm = FALSE
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	show_messages = 1

	//Bluespace radios talk directly to telecomms equipment
	var/bluespace_radio = FALSE
	var/datum/weakref/bs_tx_weakref //Maybe misleading, this is the device to TRANSMIT TO
	// For mappers or subtypes, to start them prelinked to these devices
	var/bs_tx_preload_id
	var/bs_rx_preload_id

	matter = list(MAT_GLASS = 25,MAT_STEEL = 75)
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

	if(bluespace_radio)
		if(bs_tx_preload_id)
			//Try to find a receiver
			for(var/obj/machinery/telecomms/receiver/RX in GLOB.telecomms_list)
				if(RX.id == bs_tx_preload_id) //Again, bs_tx is the thing to TRANSMIT TO, so a receiver.
					bs_tx_weakref = WEAKREF(RX)
					RX.link_radio(src)
					break
			//Hmm, howabout an AIO machine
			if(!bs_tx_weakref)
				for(var/obj/machinery/telecomms/allinone/AIO in GLOB.telecomms_list)
					if(AIO.id == bs_tx_preload_id)
						bs_tx_weakref = WEAKREF(AIO)
						AIO.link_radio(src)
						break
			if(!bs_tx_weakref)
				stack_trace("A radio [src] at [x],[y],[z] specified bluespace prelink IDs, but the machines with corresponding IDs ([bs_tx_preload_id], [bs_rx_preload_id]) couldn't be found.")

		if(bs_rx_preload_id)
			var/found = 0
			//Try to find a transmitter
			for(var/obj/machinery/telecomms/broadcaster/TX in GLOB.telecomms_list)
				if(TX.id == bs_rx_preload_id) //Again, bs_rx is the thing to RECEIVE FROM, so a transmitter.
					TX.link_radio(src)
					found = 1
					break
			//Hmm, howabout an AIO machine
			if(!found)
				for(var/obj/machinery/telecomms/allinone/AIO in GLOB.telecomms_list)
					if(AIO.id == bs_rx_preload_id)
						AIO.link_radio(src)
						found = 1
						break
			if(!found)
				stack_trace("A radio [src] at [x],[y],[z] specified bluespace prelink IDs, but the machines with corresponding IDs ([bs_tx_preload_id], [bs_rx_preload_id]) couldn't be found.")

/obj/item/radio/proc/recalculateChannels()
	return

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

	return ui_interact(user)

/obj/item/radio/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Radio", name)
		ui.open()

/obj/item/radio/ui_data(mob/user)
	var/data[0]

	data["rawfreq"] = frequency
	data["listening"] = listening
	data["broadcasting"] = broadcasting
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["loudspeaker"] = loudspeaker

	data["mic_cut"] = (wires.is_cut(WIRE_RADIO_TRANSMIT) || wires.is_cut(WIRE_RADIO_SIGNAL))
	data["spk_cut"] = (wires.is_cut(WIRE_RADIO_RECEIVER) || wires.is_cut(WIRE_RADIO_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
	else
		data["chan_list"] = null

	if(syndie)
		data["useSyndMode"] = TRUE

	data["minFrequency"] = PUBLIC_LOW_FREQ
	data["maxFrequency"] = PUBLIC_HIGH_FREQ

	return data

/obj/item/radio/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("setFrequency")
			var/new_frequency = (text2num(params["freq"]))
			if((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
				new_frequency = sanitize_frequency(new_frequency)
			set_frequency(new_frequency)
			if(hidden_uplink)
				if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
					usr << browse(null, "window=radio")
			. = TRUE
		if("broadcast")
			ToggleBroadcast()
			. = TRUE
		if("listen")
			ToggleReception()
			. = TRUE
		if("channel")
			var/chan_name = params["channel"]
			if(channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING
			. = TRUE
		if("specFreq")
			var/freq = params["channel"]
			if(has_channel_access(usr, freq))
				set_frequency(text2num(freq))
			. = TRUE
		if("subspace")
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				if(!subspace_transmission)
					channels = list()
					to_chat(usr, SPAN_NOTICE("Subspace Transmission is disabled"))
				else
					recalculateChannels()
					to_chat(usr, SPAN_NOTICE("Subspace Transmission is enabled"))
				. = TRUE
		if("toggleLoudspeaker")
			if(!subspace_switchable)
				return
			loudspeaker = !loudspeaker

			if(loudspeaker)
				to_chat(usr, SPAN_NOTICE("Loadspeaker enabled."))
			else
				to_chat(usr, SPAN_NOTICE("Loadspeaker disabled."))
			. = TRUE

	if(. && iscarbon(usr))
		playsound(src, "button", 10)

/obj/item/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = !!(chan_stat & FREQ_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "freq" = radiochannels[ch_name])))

	return dat

/obj/item/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_name(text2num(internal_chan)), "freq" = text2num(internal_chan))))

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

/obj/item/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.is_cut(WIRE_RADIO_TRANSMIT) || wires.is_cut(WIRE_RADIO_SIGNAL))

/obj/item/radio/proc/ToggleReception()
	listening = !listening && !(wires.is_cut(WIRE_RADIO_RECEIVER) || wires.is_cut(WIRE_RADIO_SIGNAL))

/obj/item/radio/CanUseTopic()
	if(!on)
		return UI_CLOSE
	return ..()

/obj/item/radio/proc/autosay(var/message, var/from, var/channel, list/zlevels = list(0)) //BS12 EDIT
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
						4, 0, zlevels, connection.frequency, "states")

///Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/radio/proc/handle_message_mode(mob/living/M as mob, message, message_mode)
	//If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	//Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if (message_mode == "department") //Department radio shortcut
			message_mode = channels[1]

		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	//If we were to send to a channel we don't have, drop it.
	return null

/obj/item/radio/talk_into(mob/living/M as mob, message, channel, var/verb = "says", var/datum/language/speaking = null)
	if(!on)
		return FALSE //The device has to be on
	//Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message)
		return FALSE

	if(istype(M))
		M.trigger_aiming(TARGET_CAN_RADIO)

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(wires.is_cut(WIRE_RADIO_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE

	if(!radio_connection)
		set_frequency(frequency)

	if(loc == M)
		playsound(loc, "sound/effects/walkietalkie.ogg", 15, 0, -1, -1)

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
	var/message_mode = handle_message_mode(M, message, channel)
	switch(message_mode)
		if(RADIO_CONNECTION_FAIL)
			return FALSE
		if(RADIO_CONNECTION_NON_SUBSPACE)
			return TRUE

	if(!istype(message_mode, /datum/radio_frequency))
		return FALSE

	var/pos_z = get_z(src)
	var/datum/radio_frequency/connection = message_mode

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

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new

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
		"type" = SIGNAL_NORMAL, // determines what type of radio input it is: normal broadcast
		"server" = null, // the last server to log this signal
		"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting machinery
		"level" = pos_z, // The source's z level
		"verb" = verb,
		"language" = speaking
	)
	signal.frequency = connection.frequency // Quick frequency set

	var/filter_type = DATA_LOCAL //If we end up having to send it the old fashioned way, it's with this data var.

	/* ###### Bluespace radios talk directly to receivers (and only directly to receivers) ###### */
	if(bluespace_radio)
		//Nothing to transmit to
		if(!bs_tx_weakref)
			to_chat(loc, SPAN_WARNING("\The [src] buzzes to inform you of the lack of a functioning connection."))
			return FALSE

		var/obj/machinery/telecomms/tx_to = bs_tx_weakref.resolve()
		//Was linked, now destroyed or something
		if(!tx_to)
			bs_tx_weakref = null
			to_chat(loc, SPAN_WARNING("\The [src] buzzes to inform you of the lack of a functioning connection."))
			return FALSE

		//Transmitted in the blind. If we get a message back, cool. If not, oh well.
		signal.transmission_method = TRANSMISSION_BLUESPACE
		return tx_to.receive_signal(signal)

	/* ###### Radios with subspace_transmission can only broadcast through subspace (unless they have adhoc_fallback) ###### */
	else if(subspace_transmission)
		var/list/jamming = is_jammed(src)
		if(jamming)
			var/distance = jamming["distance"]
			to_chat(M, SPAN_DANGER("[icon2html(src, world)] You hear the [distance <= 2 ? "loud hiss" : "soft hiss"] of static."))
			return FALSE

		// First, we want to generate a new radio signal
		signal.transmission_method = TRANSMISSION_SUBSPACE

		//#### Sending the signal to all subspace receivers ####//
		for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in GLOB.telecomms_list)
			R.receive_signal(signal)

		// Receiving code can be located in Telecommunications.dm
		if(signal.data["done"] && (pos_z in signal.data["level"]))
			return TRUE //Huzzah, sent via subspace

		else if(adhoc_fallback) //Less huzzah, we have to fallback
			to_chat(loc, SPAN_WARNING("\The [src] pings as it falls back to local radio transmission."))
			subspace_transmission = FALSE

		else //Oh well
			return FALSE

	/* ###### Intercoms and station-bounced radios ###### */
	else
		/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
		if(istype(src, /obj/item/radio/intercom))
			filter_type = DATA_INTERCOM

		/* --- Try to send a normal subspace broadcast first */
		signal.transmission_method = TRANSMISSION_SUBSPACE
		signal.data["compression"] = 0

		for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in GLOB.telecomms_list)
			R.receive_signal(signal)

	for(var/obj/machinery/telecomms/receiver/R in GLOB.telecomms_list)
		R.receive_signal(signal)

		if(signal.data["done"] && (pos_z in signal.data["level"]))
			if(adhoc_fallback)
				to_chat(loc, SPAN_NOTICE("\The [src] pings as it reestablishes subspace communications."))
				subspace_transmission = TRUE
			// we're done here.
			return TRUE

	//Nothing handled any sort of remote radio-ing and returned before now, just squawk on this zlevel.
	return Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
		src, message, displayname, jobname, real_name, M.voice_name,
		filter_type, signal.data["compression"], GLOB.using_map.get_map_levels(pos_z), connection.frequency, verb, speaking)

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

	if(wires.is_cut(WIRE_RADIO_RECEIVER))
		return -1
	if(!listening)
		return -1
	if(is_jammed(src))
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if((!position || !(position.z in level)) && !bluespace_radio)			return -1
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
			. += SPAN_NOTICE("\The [src] can be attached and modified!")
		else
			. += SPAN_NOTICE("\The [src] can not be modified or attached!")
	return

/obj/item/radio/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.set_machine(src)
	if (!W.is_screwdriver())
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/radio/beacon))
		if (b_stat)
			user.show_message(SPAN_NOTICE("\The [src] can now be attached and modified!"))
		else
			user.show_message(SPAN_NOTICE("\The [src] can no longer be modified or attached!"))
		updateDialog()
		return

/obj/item/radio/emp_act(severity)
	broadcasting = FALSE
	listening = FALSE
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
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = TRUE
	subspace_switchable = TRUE

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

/obj/item/radio/borg/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	user.set_machine(src)
	if (!(I.is_screwdriver() || istype(I, /obj/item/encryptionkey)))
		return ..()

	if(I.is_screwdriver())
		. = CLICKCHAIN_DO_NOT_PROPAGATE
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
			playsound(src, I.tool_sound, 50, 1)

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(I, /obj/item/encryptionkey))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		keyslot = I
		recalculateChannels()

/obj/item/radio/borg/recalculateChannels()
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
	listening = FALSE

/obj/item/radio/phone
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	anchored = FALSE
	broadcasting = FALSE
	listening = TRUE
	name = "phone"

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
/obj/item/bluespace_radio
	name = "subspace radio"
	desc = "A powerful new radio originally gifted to Nanotrasen from Ward Takahashi. Immensely expensive, this communications device has the ability to send and recieve transmissions from anywhere."
	catalogue_data = list()///datum/category_item/catalogue/information/organization/ward_takahashi)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/mob/clothing/back.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	slot_flags = SLOT_BACK
	force = 5
	throw_force = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	action_button_name = "Remove/Replace Handset"

	var/obj/item/radio/bluespace_handset/linked/handset = /obj/item/radio/bluespace_handset/linked

/obj/item/bluespace_radio/Initialize(Mapload) //starts without a cell for rnd
	. = ..()
	handset = new(src, src)

/obj/item/bluespace_radio/Destroy()
	. = ..()
	QDEL_NULL(handset)

/obj/item/bluespace_radio/ui_action_click()
	toggle_handset()

/obj/item/bluespace_radio/attack_hand(mob/user)
	if(loc == user)
		toggle_handset()
	else
		..()

/obj/item/bluespace_radio/OnMouseDropLegacy()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		add_fingerprint(usr)
		M.put_in_hands(src)

/obj/item/bluespace_radio/attackby(obj/item/W, mob/user, params)
	if(W == handset)
		reattach_handset(user)
	else
		return ..()

/obj/item/bluespace_radio/verb/toggle_handset()
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
/obj/item/bluespace_radio/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.item_by_slot(SLOT_ID_BACK) == src)
		return 1
	if((slot_flags & SLOT_BACK) && M.item_by_slot(SLOT_ID_SUIT_STORAGE) == src)
		return 1

	return 0

/obj/item/bluespace_radio/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/bluespace_radio/proc/reattach_handset(mob/user)
	if(!handset)
		return

	if(ismob(handset.loc))
		to_chat(handset.loc, "<span class='notice'>\The [handset] snaps back into the main unit.</span>")
	handset.forceMove(src)

//Subspace Radio Handset
/obj/item/radio/bluespace_handset
	name = "subspace radio handset"
	desc = "A large walkie talkie attached to the subspace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon_state = "signaller"
	slot_flags = null
	w_class = ITEMSIZE_LARGE

/obj/item/radio/bluespace_handset/linked
	var/obj/item/bluespace_radio/base_unit
	bs_tx_preload_id = "Receiver A"  //Transmit to a receiver
	bs_rx_preload_id = "Broadcaster A"  //Recveive from a transmitter

/obj/item/radio/bluespace_handset/linked/Initialize(mapload, obj/item/bluespace_radio/radio)
	base_unit = radio
	return ..(mapload)

/obj/item/radio/bluespace_handset/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.handset == src)
			base_unit.handset = null
		base_unit = null
	return ..()

/obj/item/radio/bluespace_handset/linked/dropped(mob/user, flags, atom/newLoc)
	. = ..() //update twohanding
	if(base_unit)
		base_unit.reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/bluespace_radio/talon_prelinked
	name = "bluespace radio (talon)"
	handset = /obj/item/radio/bluespace_handset/linked/talon_prelinked

/obj/item/radio/bluespace_handset/linked/talon_prelinked
/* // Commenting out for now while Talon is not in use
	bs_tx_preload_id = "talon_aio" //Transmit to a receiver
	bs_rx_preload_id = "talon_aio" //Recveive from a transmitter
*/
/obj/item/bluespace_radio/commerce
	name = "commercial subspace radio"
	desc = "Immensely expensive, this communications device has the ability to send and recieve transmissions from anywhere. Only a few of these devices have been sold by either Ward Takahashi or NanoTrasen. This device is incredibly rare and mind-numbingly expensive. Do not lose it."
