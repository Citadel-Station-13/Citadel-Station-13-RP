/obj/machinery/computer/bioscan
	name = "Bioscan Control Console"
	desc = "Used to pinpoint signatures, biological or otherwise, using a series of antennaes."
	icon_keyboard = "tech_key"

	/// network key
	var/network_key
	/// automatically generate an obfuscated key - used by mappers
	var/network_key_obfuscated
	/// buffer - quite literally just holds a copy of generated ui data
	var/list/buffer
	/// last scan at
	var/last_scan
	/// scan cooldown
	var/scan_delay = 10 SECONDS

/obj/machinery/computer/bioscan/Initialize(mapload)
	. = ..()
	if(network_key_obfuscated)
		network_key = SSmapping.subtly_obfuscated_id(network_key_obfuscated, "bioscan_network")

/obj/machinery/computer/bioscan/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BioscanConsole")
		ui.open()

/obj/machinery/computer/bioscan/ui_static_data(mob/user)
	. = ..()
	.["scan"] = buffer
	.["antennas"] = ui_antenna_data()

/obj/machinery/computer/bioscan/proc/ui_antenna_data()
	var/list/antennas = network_key && GLOB.bioscan_antenna_list[network_key]
	. = list()
	for(var/obj/machinery/bioscan_antenna/A as anything in antennas)
		var/turf/T = get_turf(A)
		if(!T)
			continue
		. += list(list(
			"level" = SSmapping.level_id(get_z(A)),
			"id" = "[A.id]",
			"anchor" = A.anchored,
			"name" = A.name,
			"x" = T.x,
			"y" = T.y,
		))

/obj/machinery/computer/bioscan/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["scan_ready"] = !on_cooldown()
	.["network"] = network_key || ""

/obj/machinery/computer/bioscan/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("scan")
			if(!network_key)
				visible_message(SPAN_WARNING("[icon2html(src, world)] flashes a message, \"No network set.\""))
				return
			if(on_cooldown())
				visible_message(SPAN_WARNING("[icon2html(src, world)] flashes a message, \"Bioscan still on cooldown.\""))
				return
			last_scan = world.time
			atom_say("Commencing signature scan and updating buffers...")
			scan()
			return TRUE
		if("set_network")
			var/what = params["network"] || null
			set_network(what)
			return TRUE

/obj/machinery/computer/bioscan/proc/on_cooldown()
	return (world.time - last_scan) <= scan_delay

/obj/machinery/computer/bioscan/proc/set_network(key)
	network_key = key
	void_scan()

/obj/machinery/computer/bioscan/proc/void_scan()
	buffer = null
	push_ui_data(data = list("scan" = null))

/obj/machinery/computer/bioscan/proc/scan()
	var/list/new_data = list()
	/// get relevant antennas
	var/list/antennas = network_key && GLOB.bioscan_antenna_list[network_key]
	if(!length(antennas))
		// abort
		void_scan()
		return
	/// build list of levels
	var/list/indices = list()
	for(var/obj/machinery/bioscan_antenna/A as anything in antennas)
		indices["[A.z]"] = list()
	/// get mobs
	for(var/mob/M as anything in GLOB.mob_list)
		if(!indices[num2text(M.z)])
			continue
		indices[num2text(M.z)] += M
	/// process mobs
	var/list/assembled = list()
	for(var/z_str in indices)
		var/list/gottem = list()
		gottem["id"] = SSmapping.level_id(text2num(z_str))
		var/mobs_all = 0
		var/mobs_complex = 0
		var/mobs_complex_alive = 0
		var/mobs_complex_dead = 0
		for(var/mob/M as anything in indices[z_str])
			++mobs_all
			if(!isliving(M))
				continue	// don't care didn't ask
			if(!issimple(M))
				++mobs_complex
				if(IS_DEAD(M))
					++mobs_complex_dead
				else
					++mobs_complex_alive
		gottem["all"] = mobs_all
		gottem["complex"] = mobs_complex
		gottem["complex_alive"] = mobs_complex_alive
		gottem["complex_dead"] = mobs_complex_dead
		assembled[++assembled.len] = gottem
	new_data["levels"] = assembled
	buffer = new_data
	push_ui_data(data = list("scan" = buffer))
