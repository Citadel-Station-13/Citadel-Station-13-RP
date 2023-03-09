//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You may be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The machines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the prequel to this code.
*/

/obj/machinery/telecomms
	icon = 'icons/obj/stationobjs.dmi'
	///List of machines this machine is linked to.
	var/list/links = list()
	///Value increases as traffic increases.
	var/traffic = 0
	///How much traffic to lose per tick (50 gigabytes/second * netspeed).
	var/netspeed = 5
	///List of text/number values to link with.
	var/list/autolinkers = list()
	///Identification string.
	var/id = "NULL"
	///The network of the machinery.
	var/network = "NULL"
	//List of frequencies to tune into: if none, will listen to all.
	var/list/freq_listening = list()
	///Just a hacky way of preventing alike machines from pairing.
	var/machinetype = 0
	///Is it toggled on. //Not sure why we have this when we have var/on.
	var/toggled = TRUE
	var/on = TRUE
	///Basically HP, loses integrity by heat.
	integrity = 100
	///Whether the machine will produce heat when on.
	var/produces_heat = TRUE
	///How many process() ticks to delay per heat.
	var/delay = 10
	///Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/long_range_link = FALSE
	///Is it a hidden machine?
	var/hide = 0
	///0 = auto set in New() - this is the z level that the machine is listening to.
	var/listening_level = 0


/obj/machinery/telecomms/proc/relay_information(datum/signal/signal, filter, copysig, amount = 20)
	// relay signal to all linked machinery that are of type [filter]. If signal has been sent [amount] times, stop sending

	if(!on)
		return
	//TO_WORLD("[src] ([src.id]) - [signal.debug_print()]")
	var/send_count = 0

	signal.data["slow"] += rand(0, round((100-integrity))) // apply some lag based on integrity

	/*
	// Edit by Atlantis: Commented out as emergency fix due to causing extreme delays in communications.
	// Apply some lag based on traffic rates
	var/netlag = round(traffic / 50)
	if(netlag > signal.data["slow"])
		signal.data["slow"] = netlag
	*/
// Loop through all linked machines and send the signal or copy.
	for(var/obj/machinery/telecomms/machine in links)
		if(filter && !istype( machine, text2path(filter) ))
			continue
		if(!machine.on)
			continue
		if(amount && send_count >= amount)
			break
		if(machine.loc.z != listening_level)
			if(long_range_link == 0 && machine.long_range_link == 0)
				continue
		// If we're sending a copy, be sure to create the copy for EACH machine and paste the data
		var/datum/signal/copy
		if(copysig)
			copy = new
			copy.transmission_method = TRANSMISSION_SUBSPACE
			copy.frequency = signal.frequency
			copy.data = signal.data.Copy()

			// Keep the "original" signal constant
			if(!signal.data["original"])
				copy.data["original"] = signal
			else
				copy.data["original"] = signal.data["original"]

		send_count++
		if(machine.is_freq_listening(signal))
			machine.traffic++

		if(copysig && copy)
			machine.receive_information(copy, src)
		else
			machine.receive_information(signal, src)


	if(send_count > 0 && is_freq_listening(signal))
		traffic++

	return send_count

/obj/machinery/telecomms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecomms/machine)
	// send signal directly to a machine
	machine.receive_information(signal, src)

/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// receive information from linked machinery

/obj/machinery/telecomms/proc/is_freq_listening(datum/signal/signal)
	// return 1 if found, 0 if not found
	if(!signal)
		return 0
	if((signal.frequency in freq_listening) || (!freq_listening.len))
		return 1
	else
		return 0

/obj/machinery/telecomms/Initialize(mapload)
	GLOB.telecomms_list += src
	. = ..()

	//Set the listening_level if there's none.
	if(!listening_level)
		//Defaults to our Z level!
		var/turf/position = get_turf(src)
		listening_level = position.z
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/telecomms/LateInitialize()
	if(autolinkers.len)
		// Links nearby machines
		if(!long_range_link)
			for(var/obj/machinery/telecomms/T in orange(20, src))
				add_link(T)
		else
			for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
				add_link(T)
	return ..()

/obj/machinery/telecomms/Destroy()
	GLOB.telecomms_list -= src
	for(var/obj/machinery/telecomms/comm in GLOB.telecomms_list)
		comm.links -= src
	links = list()
	..()

// Used in auto linking
/obj/machinery/telecomms/proc/add_link(var/obj/machinery/telecomms/T)
	var/pos_z = get_z(src)
	var/tpos_z = get_z(T)
	if((pos_z == tpos_z) || (src.long_range_link && T.long_range_link))
		for(var/x in autolinkers)
			if(T.autolinkers.Find(x))
				if(src != T)
					links |= T

/obj/machinery/telecomms/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/telecomms/proc/update_power()
	if(toggled)
		if(machine_stat & (BROKEN|NOPOWER|EMPED) || integrity <= 0) // if powered, on. if not powered, off. if too damaged, off
			on = FALSE
		else
			on = TRUE
	else
		on = FALSE

/obj/machinery/telecomms/process()
	update_power()

	// Check heat and generate some
	checkheat()

	// Update the icon
	update_icon()

	if(traffic > 0)
		traffic -= netspeed

/obj/machinery/telecomms/emp_act(severity)
	if(prob(100/severity))
		if(!(machine_stat & EMPED))
			machine_stat |= EMPED
			var/duration = (300 * 10)/severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				machine_stat &= ~EMPED
	..()

/obj/machinery/telecomms/proc/checkheat()
	// Checks heat from the environment and applies any integrity damage
	var/damage_chance = 0                           // Percent based chance of applying 1 integrity damage this tick
	switch(loc.return_temperature())
		if((T0C + 40) to (T0C + 70))                // 40C-70C, minor overheat, 10% chance of taking damage
			damage_chance = 10
		if((T0C + 70) to (T0C + 130))				// 70C-130C, major overheat, 25% chance of taking damage
			damage_chance = 25
		if((T0C + 130) to (T0C + 200))              // 130C-200C, dangerous overheat, 50% chance of taking damage
			damage_chance = 50
		if((T0C + 200) to INFINITY)					// More than 200C, INFERNO. Takes damage every tick.
			damage_chance = 100
	if (damage_chance && prob(damage_chance))
		integrity = clamp( integrity - 1, 0,  100)

	if(delay > 0)
		delay--
	else if(on)
		produce_heat()
		delay = initial(delay)

/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat)
		return

	if (!use_power)
		return

	if(!(machine_stat & (NOPOWER|BROKEN)))
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)

				var/heat_produced = idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source
				if (traffic <= 0)
					heat_produced *= 0.30	//if idle, produce less heat.

				removed.adjust_thermal_energy(heat_produced)

			env.merge(removed)

//Generic telecomm connectivity test proc
/proc/can_telecomm(var/atom/A, var/atom/B, var/ad_hoc = FALSE)
	if(!A || !B)
		log_debug(SPAN_DEBUG("can_telecomm(): Undefined endpoints!"))
		return FALSE

	//Can't in this case, obviously!
	if(is_jammed(A) || is_jammed(B))
		return FALSE

	//Items don't have a Z when inside an object or mob
	var/turf/src_z = get_z(A)
	var/turf/dst_z = get_z(B)

	//Nullspace, probably.
	if(!src_z || !dst_z)
		return FALSE

	//We can do the simple check first, if you have ad_hoc radios.
	if(ad_hoc && src_z == dst_z)
		return TRUE

	return src_z in GLOB.using_map.get_map_levels(dst_z, TRUE, om_range = DEFAULT_OVERMAP_RANGE)

/*

	All telecommunications interactions:

*/

#define STATION_Z 1
#define TELECOMM_Z 3

/obj/machinery/telecomms
	var/list/temp = null // output message

/obj/machinery/telecomms/attackby(obj/item/P as obj, mob/user as mob)

	// Using a multitool lets you access the receiver's interface
	if(istype(P, /obj/item/multitool))
		attack_hand(user)

	// REPAIRING: Use Nanopaste to repair 10-20 integrity points.
	if(istype(P, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = P
		if (integrity < 100)               								//Damaged, let's repair!
			if (T.use(1))
				integrity = between(0, integrity + rand(10,20), 100)
				to_chat(usr, "You apply the Nanopaste to [src], repairing some of the damage.")
		else
			to_chat(usr, "This machine is already in perfect condition.")
		return


	if(default_deconstruction_screwdriver(user, P))
		return
	if(default_deconstruction_crowbar(user, P))
		return

/obj/machinery/telecomms/attack_ai(var/mob/user as mob)
	attack_hand(user)

/obj/machinery/telecomms/ui_data(mob/user)
	var/list/data = list()

	data["temp"] = temp
	data["on"] = on

	data["id"] = null
	data["network"] = null
	data["autolinkers"] = FALSE
	data["shadowlink"] = FALSE
	data["options"] = list()
	data["linked"] = list()
	data["filter"] = list()
	data["multitool"] = FALSE
	data["multitool_buffer"] = null

	if(on || interact_offline)
		data["id"] = id
		data["network"] = network
		data["autolinkers"] = !!LAZYLEN(autolinkers)
		data["shadowlink"] = !!hide

		data["options"] = Options_Menu()

		var/obj/item/multitool/P = get_multitool(user)
		data["multitool"] = !!P
		data["multitool_buffer"] = null
		if(P && P.buffer)
			P.update_icon()
			data["multitool_buffer"] = list("name" = "[P.buffer]", "id" = "[P.buffer.id]")

		var/i = 0
		data["linked"] = list()
		for(var/obj/machinery/telecomms/T in links)
			i++
			data["linked"] += list(list(
				"ref" = "\ref[T]",
				"name" = "[T]",
				"id" = T.id,
				"index" = i,
			))

		data["filter"] = list()
		if(LAZYLEN(freq_listening))
			for(var/x in freq_listening)
				data["filter"] += list(list(
					"name" = "[format_frequency(x)]",
					"freq" = x,
				))

	return data

/obj/machinery/telecomms/ui_status(mob/user)
	if(!issilicon(user))
		if(!istype(user.get_active_held_item(), /obj/item/multitool))
			return UI_CLOSE
	. = ..()

/obj/machinery/telecomms/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/telecomms/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsMultitoolMenu", name)
		ui.open()

// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)


/obj/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_level == STATION_Z) // equals the station
		src.listening_level = position.z
		return 1
	else if(position.z == TELECOMM_Z)
		src.listening_level = STATION_Z
		return 1
	return 0

// Returns a multitool from a user depending on their mobtype.

/obj/machinery/proc/get_multitool(mob/user as mob)	//No need to have this being a telecomms specific proc.

	var/obj/item/multitool/P = null
	// Let's double check
	if(!issilicon(user) && istype(user.get_active_held_item(), /obj/item/multitool))
		P = user.get_active_held_item()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isrobot(user) && in_range(user, src))
		if(istype(user.get_active_held_item(), /obj/item/multitool))
			P = user.get_active_held_item()
	return P

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return list()

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Act(action, params)
	return

/*
/obj/machinery/telecomms/processor/Options_Act(action, params)

	if(href_list["process"])
		set_temp("-% Processing mode changed. %-", "average")
		src.process_mode = !src.process_mode
*/

// RELAY

/obj/machinery/telecomms/relay/Options_Menu()
	var/list/data = ..()
	data["use_listening_level"] = TRUE
	data["use_broadcasting"] = TRUE
	data["use_receiving"] = TRUE
	data["listening_level"] = (listening_level == STATION_Z)
	data["broadcasting"] = broadcasting
	data["receiving"] = receiving
	return data

/obj/machinery/telecomms/relay/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("receive")
			. = TRUE
			receiving = !receiving
			set_temp("-% Receiving mode changed. %-", "average")
		if("broadcast")
			. = TRUE
			broadcasting = !broadcasting
			set_temp("-% Broadcasting mode changed. %-", "average")
		if("change_listening")
			. = TRUE
			//Lock to the station OR lock to the current position!
			//You need at least two receivers and two broadcasters for this to work, this includes the machine.
			var/result = toggle_level()
			if(result)
				set_temp("-% [src]'s signal has been successfully changed.", "average")
			else
				set_temp("-% [src] could not lock it's signal onto the station. Two broadcasters or receivers required.", "average")

// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/list/data = ..()
	data["use_change_freq"] = TRUE
	data["change_freq"] = change_frequency
	return data

/obj/machinery/telecomms/bus/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("change_freq")
			. = TRUE
			var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
			if(canAccess(usr))
				if(newfreq)
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(newfreq < 10000)
						change_frequency = newfreq
						set_temp("-% New frequency to change to assigned: \"[newfreq] GHz\" %-", "average")
				else
					change_frequency = 0
					set_temp("-% Frequency changing deactivated %-", "average")


// BROADCASTER
/obj/machinery/telecomms/broadcaster/Options_Menu()
	var/list/data = ..()
	data["use_broadcast_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data

/obj/machinery/telecomms/broadcaster
	interact_offline = TRUE // because you can accidentally nuke power grids with these, need to be able to fix mistake

/obj/machinery/telecomms/broadcaster/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage)**(overmap_range+1))

// RECEIVER
/obj/machinery/telecomms/receiver/Options_Menu()
	var/list/data = ..()
	data["use_receive_range"] = TRUE
	data["range"] = overmap_range
	data["minRange"] = overmap_range_min
	data["maxRange"] = overmap_range_max
	return data

/obj/machinery/telecomms/receiver
	interact_offline = TRUE // because you can accidentally nuke power grids with these, need to be able to fix mistake

/obj/machinery/telecomms/receiver/Options_Act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("range")
			var/new_range = params["range"]
			overmap_range = clamp(new_range, overmap_range_min, overmap_range_max)
			update_idle_power_usage(initial(idle_power_usage)**(overmap_range+1))

/obj/machinery/telecomms/ui_act(action, params)
	if(..())
		return TRUE

	var/obj/item/multitool/P = get_multitool(usr)

	switch(action)
		if("toggle")
			src.toggled = !src.toggled
			set_temp("-% [src] has been [src.toggled ? "activated" : "deactivated"].", "average")
			update_power()
			. = TRUE

		if("id")
			var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
			if(newid && canAccess(usr))
				id = newid
				set_temp("-% New ID assigned: \"[id]\" %-", "average")
				. = TRUE

		if("network")
			var/newnet = input(usr, "Specify the new network for this machine. This will break all current links.", src, network) as null|text
			if(newnet && canAccess(usr))

				if(length(newnet) > 15)
					set_temp("-% Too many characters in new network tag %-", "average")

				else
					for(var/obj/machinery/telecomms/T in links)
						T.links.Remove(src)

					network = newnet
					links = list()
					set_temp("-% New network tag assigned: \"[network]\" %-", "average")
				. = TRUE


		if("freq")
			var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
			if(newfreq && canAccess(usr))
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(!(newfreq in freq_listening) && newfreq < 10000)
					freq_listening.Add(newfreq)
					set_temp("-% New frequency filter assigned: \"[newfreq] GHz\" %-", "average")
				. = TRUE

		if("delete")
			var/x = text2num(params["delete"])
			set_temp("-% Removed frequency filter [x] %-", "average")
			freq_listening.Remove(x)
			. = TRUE

		if("unlink")
			if(text2num(params["unlink"]) <= length(links))
				var/obj/machinery/telecomms/T = links[text2num(params["unlink"])]
				set_temp("-% Removed \ref[T] [T.name] from linked entities. %-", "average")

				// Remove link entries from both T and src.

				if(src in T.links)
					T.links.Remove(src)
				links.Remove(T)
				. = TRUE

		if("link")
			if(P)
				if(P.buffer && P.buffer != src)
					if(!(src in P.buffer.links))
						P.buffer.links.Add(src)

					if(!(P.buffer in src.links))
						src.links.Add(P.buffer)

					set_temp("-% Successfully linked with \ref[P.buffer] [P.buffer.name] %-", "average")

				else
					set_temp("-% Unable to acquire buffer %-", "average")
				. = TRUE

		if("buffer")
			P.buffer = src
			set_temp("-% Successfully stored \ref[P.buffer] [P.buffer.name] in buffer %-", "average")
			. = TRUE

		if("flush")
			set_temp("-% Buffer successfully flushed. %-", "average")
			P.buffer = null
			. = TRUE

		if("cleartemp")
			temp = null
			. = TRUE

	if(Options_Act(action, params))
		. = TRUE

/obj/machinery/telecomms/proc/canAccess(var/mob/user)
	if(issilicon(user) || in_range(user, src))
		return 1
	return 0

/obj/machinery/telecomms/proc/set_temp(var/text, var/color = "average")
	temp = list("color" = color, "text" = text)

#undef TELECOMM_Z
#undef STATION_Z
