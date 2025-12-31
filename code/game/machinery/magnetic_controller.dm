
/obj/machinery/magnetic_controller
	name = "Magnetic Control Console"
	icon = 'icons/obj/airlock_machines.dmi' // uses an airlock machine icon, THINK GREEN HELP THE ENVIRONMENT - RECYCLING!
	icon_state = "airlock_control_standby"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 45
	var/frequency = 1449
	var/code = 0
	var/list/magnets = list()
	var/title = "Magnetic Control Console"

	/// If set to 1, can't probe for other magnets!
	var/autolink = FALSE
	/// Position in the path.
	var/pathpos = 1
	/// Text path of the magnet.
	var/path = "NULL"
	/// Lowest = 1, Highest = 10
	var/speed = 1
	/// Real path of the magnet, used in iterator.
	var/list/rpath = list()

	/// TRUE if scheduled to loop.
	var/moving = FALSE
	/// TRUE if looping.
	var/looping = FALSE

	var/datum/radio_frequency/radio_connection

/obj/machinery/magnetic_controller/Initialize(mapload, newdir)
	. = ..()

	if(autolink)
		for(var/obj/machinery/magnetic_module/M in GLOB.machines)
			if(M.freq == frequency && M.code == code)
				magnets.Add(M)
	radio_connection = radio_controller.add_object(src, frequency, RADIO_MAGNETS)
	if(path) // check for default path
		filter_path() // renders rpath

/obj/machinery/magnetic_controller/Destroy()
	magnets = null
	return ..()

/obj/machinery/magnetic_controller/process(delta_time)
	for(var/obj/machinery/magnetic_module/magnet as anything in magnets)
		if(!istype(magnet) || QDELETED(magnet))
			magnets -= magnet
	if(magnets.len == 0 && autolink)
		for(var/obj/machinery/magnetic_module/M in GLOB.machines)
			if(M.freq == frequency && M.code == code)
				magnets.Add(M)

/obj/machinery/magnetic_controller/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/magnetic_controller/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = "<B>Magnetic Control Console</B><BR><BR>"
	if(!autolink)
		dat += {"
		Frequency: <a href='?src=\ref[src];operation=setfreq'>[frequency]</a><br>
		Code: <a href='?src=\ref[src];operation=setfreq'>[code]</a><br>
		<a href='?src=\ref[src];operation=probe'>Probe Generators</a><br>
		"}

	if(magnets.len >= 1)

		dat += "Magnets confirmed: <br>"
		var/i = 0
		for(var/obj/machinery/magnetic_module/M in magnets)
			i++
			dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;< \[[i]\] (<a href='?src=\ref[src];radio-op=togglepower'>[M.on ? "On":"Off"]</a>) | Electricity level: <a href='?src=\ref[src];radio-op=minuselec'>-</a> [M.electricity_level] <a href='?src=\ref[src];radio-op=pluselec'>+</a>; Magnetic field: <a href='?src=\ref[src];radio-op=minusmag'>-</a> [M.magnetic_field] <a href='?src=\ref[src];radio-op=plusmag'>+</a><br>"

	dat += "<br>Speed: <a href='?src=\ref[src];operation=minusspeed'>-</a> [speed] <a href='?src=\ref[src];operation=plusspeed'>+</a><br>"
	dat += "Path: {<a href='?src=\ref[src];operation=setpath'>[path]</a>}<br>"
	dat += "Moving: <a href='?src=\ref[src];operation=togglemoving'>[moving ? "Enabled":"Disabled"]</a>"


	user << browse(HTML_SKELETON(dat), "window=magnet;size=400x500")
	onclose(user, "magnet")

/obj/machinery/magnetic_controller/Topic(href, href_list)
	if(..())
		return TRUE
	if(machine_stat & (BROKEN|NOPOWER))
		return
	usr.set_machine(src)

	if(href_list["radio-op"])

		// Prepare signal beforehand, because this is a radio operation
		var/datum/signal/signal = new
		signal.transmission_method = 1 // radio transmission
		signal.source = src
		signal.frequency = frequency
		signal.data["code"] = code

		// Apply any necessary commands
		switch(href_list["radio-op"])
			if("togglepower")
				signal.data["command"] = "toggle-power"

			if("minuselec")
				signal.data["command"] = "sub-elec"
			if("pluselec")
				signal.data["command"] = "add-elec"

			if("minusmag")
				signal.data["command"] = "sub-mag"
			if("plusmag")
				signal.data["command"] = "add-mag"


		// Broadcast the signal

		radio_connection.post_signal(src, signal, RADIO_MAGNETS)

		spawn(1)
			updateUsrDialog() // pretty sure this increases responsiveness

	if(href_list["operation"])
		switch(href_list["operation"])
			if("plusspeed")
				speed ++
				if(speed > 10)
					speed = 10
			if("minusspeed")
				speed --
				if(speed <= 0)
					speed = 1
			if("setpath")
				var/newpath = sanitize(input(usr, "Please define a new path!",,path) as text|null)
				if(newpath && newpath != "")
					moving = FALSE // stop moving
					path = newpath
					pathpos = 1 // reset position
					filter_path() // renders rpath

			if("togglemoving")
				moving = !moving
				if(moving)
					spawn() MagnetMove()


	updateUsrDialog()

/obj/machinery/magnetic_controller/proc/MagnetMove()
	if(looping) return

	while(moving && rpath.len >= 1)

		if(machine_stat & (BROKEN|NOPOWER))
			break

		looping = TRUE

		// Prepare the radio signal
		var/datum/signal/signal = new
		signal.transmission_method = 1 // radio transmission
		signal.source = src
		signal.frequency = frequency
		signal.data["code"] = code

		if(pathpos > rpath.len) // if the position is greater than the length, we just loop through the list!
			pathpos = 1

		var/nextmove = uppertext(rpath[pathpos]) // makes it un-case-sensitive

		if(!(nextmove in list("N","S","E","W","C","R")))
			// N, S, E, W are directional
			// C is center
			// R is random (in magnetic field's bounds)
			qdel(signal)
			break // break the loop if the character located is invalid

		signal.data["command"] = nextmove


		pathpos++ // increase iterator

		// Broadcast the signal
		spawn()
			radio_connection.post_signal(src, signal, RADIO_MAGNETS)

		if(speed == 10)
			sleep(1)
		else
			sleep(12-speed)

	looping = FALSE


/obj/machinery/magnetic_controller/proc/filter_path()
	// Generates the rpath variable using the path string, think of this as "string2list"
	// Doesn't use params2list() because of the akward way it stacks entities
	rpath = list() //  clear rpath
	var/maximum_character = min(50, length(path)) // chooses the maximum length of the iterator. 50 max length

	for(var/i=1, i<=maximum_character, i++) // iterates through all characters in path

		var/nextchar = copytext(path, i, i+1) // find next character

		if(!(nextchar in list(";", "&", "*", " "))) // if char is a separator, ignore
			rpath += copytext(path, i, i+1) // else, add to list

		// there doesn't HAVE to be separators but it makes paths syntatically visible

/obj/machinery/magnetic_controller/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	..()
