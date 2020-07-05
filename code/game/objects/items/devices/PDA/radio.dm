/obj/item/integated_radio
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/pda/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

/obj/item/integated_radio/Initialize()
	. = ..()
	if (istype(loc.loc, /obj/item/pda))
		hostpda = loc.loc

/obj/item/integated_radio/proc/post_signal(freq, key, value, key2, value2, key3, value3, s_filter)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, radio_filter = s_filter)
	return

/obj/item/integated_radio/proc/generate_menu()

/obj/item/integated_radio/beepsky
	var/list/botlist = null		// list of bots
	var/mob/living/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_freq = BOT_FREQ

// create a new QM cartridge, and register to receive bot control & beacon message
/obj/item/integated_radio/beepsky/Initialize()
	. = ..()
	if(radio_controller)
		radio_controller.add_object(src, control_freq, radio_filter = RADIO_SECBOT)

/obj/item/integated_radio/beepsky/receive_signal(datum/signal/signal)
	//var/obj/item/pda/P = src.loc

	/*
	to_chat(world, "recvd:[P] : [signal.source]")
	for(var/d in signal.data)
		to_chat(world, "- [d] = [signal.data[d]]")
	*/
	if (signal.data["type"] == "secbot")
		if(!botlist)
			botlist = new()

		if(!(signal.source in botlist))
			botlist += signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

	//if (istype(P))
	//	P.updateSelfDialog()

/obj/item/integated_radio/beepsky/Topic(href, href_list)
	..()
	var/obj/item/pda/PDA = src.hostpda

	switch(href_list["op"])
		if("control")
			active = locate(href_list["bot"])
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("scanbots")		// find all bots
			botlist = null
			post_signal(control_freq, "command", "bot_status", s_filter = RADIO_SECBOT)

		if("botlist")
			active = null

		if("stop", "go")
			post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("summon")
			post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(PDA) , s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

/obj/item/integated_radio/beepsky/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, control_freq)
	return ..()

/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/integated_radio/signal
	var/frequency = FREQ_SIGNALER
	var/code = 30
	var/last_transmission
	var/datum/radio_frequency/radio_connection

/obj/item/integated_radio/signal/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/item/integated_radio/signal/Initialize()
	. = ..()
	if(!radio_controller)
		return

	if (frequency < MIN_FREE_FREQ || frequency > MAX_FREE_FREQ)
		frequency = sanitize_frequency(frequency)
	set_frequency(frequency)

/obj/item/integated_radio/signal/proc/set_frequency(new_frequency)
	frequency = new_frequency
	radio_controller.remove_object(src, frequency)
	radio_connection = radio_controller.add_object(src, frequency)

/obj/item/integated_radio/signal/proc/send_signal(message="ACTIVATE") //send activation over teege
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location [AREACOORD(T)] <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message

	radio_connection.post_signal(src, signal)
