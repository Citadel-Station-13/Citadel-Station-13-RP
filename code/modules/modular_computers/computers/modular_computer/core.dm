/obj/item/modular_computer/process(delta_time)
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return FALSE

	if(damage > broken_damage)
		shutdown_computer()
		return FALSE

	// Active program requires NTNet to run but we've just lost connection. Crash.
	if(active_program && active_program.requires_ntnet && !get_ntnet_status(active_program.requires_ntnet_feature))
		active_program.event_networkfailure(0)

	for(var/datum/computer_file/program/P in idle_threads)
		if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature))
			P.event_networkfailure(1)

	if(active_program)
		if(active_program.program_state != PROGRAM_STATE_KILLED)
			active_program.ntnet_status = get_ntnet_status()
			active_program.computer_emagged = computer_emagged
			active_program.process_tick()
		else
			active_program = null

	for(var/datum/computer_file/program/P in idle_threads)
		if(P.program_state != PROGRAM_STATE_KILLED)
			P.ntnet_status = get_ntnet_status()
			P.computer_emagged = computer_emagged
			P.process_tick()
		else
			idle_threads.Remove(P)

	handle_power() // Handles all computer power interaction
	check_update_ui_need()

/// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	return TRUE

/// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	return TRUE

/obj/item/modular_computer/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	update_icon()
	update_verbs()

/obj/item/modular_computer/Destroy()
	kill_program(1)
	STOP_PROCESSING(SSobj, src)
	for(var/obj/item/computer_hardware/CH in src.get_all_components())
		uninstall_component(null, CH)
		qdel(CH)
	return ..()

/obj/item/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	if(computer_emagged)
		to_chat(user, "\The [src] was already emagged.")
		return //NO_EMAG_ACT
	else
		computer_emagged = TRUE
		to_chat(user, "You emag \the [src]. It's screen briefly shows a \"OVERRIDE ACCEPTED: New software downloads available.\" message.")
		return TRUE

/obj/item/modular_computer/update_icon()
	icon_state = icon_state_unpowered

	cut_overlays()
	var/list/overlays_to_add = list()
	if(bsod)
		add_overlay("bsod")
		return
	if(!enabled)
		if(icon_state_screensaver)
			add_overlay(icon_state_screensaver)
		set_light(0)
		return
	set_light(light_strength)
	if(active_program)
		overlays_to_add.Add(active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
		if(active_program.program_key_state)
			overlays_to_add.Add(active_program.program_key_state)
	else
		overlays_to_add.Add(icon_state_menu)

	add_overlay(overlays_to_add)

/obj/item/modular_computer/proc/turn_on(mob/user)
	if(bsod)
		return
	if(tesla_link)
		tesla_link.enabled = TRUE
	var/issynth = issilicon(user) // Robots and AIs get different activation messages.
	if(damage > broken_damage)
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src], but it responds with an error code. It must be damaged.")
		else
			to_chat(user, "You press the power button, but the computer fails to boot up, displaying variety of errors before shutting down again.")
		return
	if(processor_unit && (apc_power(0) || battery_power(0))) // Battery-run and charged or non-battery but powered by APC.
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src], turning it on")
		else
			to_chat(user, "You press the power button and start up \the [src]")
		enable_computer(user)

	else // Unpowered
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src] but it does not respond")
		else
			to_chat(user, "You press the power button but \the [src] does not respond")

/// Relays kill program request to currently active program. Use this to quit current program.
/obj/item/modular_computer/proc/kill_program(forced = FALSE)
	if(active_program)
		active_program.kill_program(forced)
		active_program = null
	var/mob/user = usr
	if(user && istype(user))
		nano_ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/item/modular_computer/proc/get_ntnet_status(specific_action = 0)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return FALSE

/obj/item/modular_computer/proc/add_log(text)
	if(!get_ntnet_status())
		return FALSE
	return ntnet_global.add_log(text, network_card)

/obj/item/modular_computer/proc/shutdown_computer(loud = TRUE)
	kill_program(1)
	for(var/datum/computer_file/program/P in idle_threads)
		P.kill_program(1)
		idle_threads.Remove(P)
	if(loud)
		visible_message("\The [src] shuts down.")
	enabled = FALSE
	update_icon()

/obj/item/modular_computer/proc/enable_computer(mob/user = null)
	enabled = 1
	update_icon()

	// Autorun feature
	var/datum/computer_file/data/autorun = hard_drive ? hard_drive.find_file_by_name("autorun") : null
	if(istype(autorun))
		run_program(autorun.stored_data)

	if(user)
		nano_ui_interact(user)

/obj/item/modular_computer/proc/minimize_program(mob/user)
	if(!active_program || !processor_unit)
		return

	idle_threads.Add(active_program)
	active_program.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs
	SSnanoui.close_uis(active_program.NM ? active_program.NM : active_program)
	SStgui.close_uis(active_program.TM ? active_program.TM : active_program)
	active_program = null
	update_icon()
	if(istype(user))
		nano_ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.

/obj/item/modular_computer/proc/run_program(prog)
	var/datum/computer_file/program/P = null
	var/mob/user = usr
	if(hard_drive)
		P = hard_drive.find_file_by_name(prog)

	if(!P || !istype(P)) // Program not found or it's not executable program.
		to_chat(user, SPAN_DANGER("\The [src]'s screen shows \"I/O ERROR - Unable to run [prog]\" warning."))
		return

	P.computer = src

	if(!P.is_supported_by_hardware(hardware_flag, 1, user))
		return
	if(P in idle_threads)
		P.program_state = PROGRAM_STATE_ACTIVE
		active_program = P
		idle_threads.Remove(P)
		update_icon()
		return

	if(idle_threads.len >= processor_unit.max_idle_programs+1)
		to_chat(user, SPAN_NOTICE("\The [src] displays a \"Maximal CPU load reached. Unable to run another program.\" error"))
		return

	if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature)) // The program requires NTNet connection, but we are not connected to NTNet.
		to_chat(user, SPAN_DANGER("\The [src]'s screen shows \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\" warning."))
		return

	if(active_program)
		minimize_program(user)

	if(P.run_program(user))
		update_icon()
	return TRUE

/obj/item/modular_computer/proc/update_uis()
	if(active_program) //Should we update program ui or computer ui?
		SSnanoui.update_uis(active_program)
		if(active_program.NM)
			SSnanoui.update_uis(active_program.NM)
	else
		SSnanoui.update_uis(src)

/obj/item/modular_computer/proc/check_update_ui_need()
	var/ui_update_needed = FALSE
	if(battery_module)
		var/batery_percent = battery_module.battery.percent()
		if(last_battery_percent != batery_percent) //Let's update UI on percent change
			ui_update_needed = TRUE
			last_battery_percent = batery_percent

	if(stationtime2text() != last_world_time)
		last_world_time = stationtime2text()
		ui_update_needed = TRUE

	if(idle_threads.len)
		var/list/current_header_icons = list()
		for(var/datum/computer_file/program/P in idle_threads)
			if(!P.ui_header)
				continue
			current_header_icons[P.type] = P.ui_header
		if(!last_header_icons)
			last_header_icons = current_header_icons

		else if(!(last_header_icons ~= current_header_icons))
			last_header_icons = current_header_icons
			ui_update_needed = TRUE
		else
			for(var/x in last_header_icons|current_header_icons)
				if(last_header_icons[x]!=current_header_icons[x])
					last_header_icons = current_header_icons
					ui_update_needed = TRUE
					break

	if(ui_update_needed)
		update_uis()

// Used by camera monitor program
/obj/item/modular_computer/check_eye(mob/user)
	if(active_program)
		return active_program.check_eye(user)
	else
		return ..()

/obj/item/modular_computer/proc/set_autorun(program)
	if(!hard_drive)
		return
	var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")
	if(!istype(autorun))
		autorun = new/datum/computer_file/data()
		autorun.filename = "autorun"
		hard_drive.store_file(autorun)
	if(autorun.stored_data == program)
		autorun.stored_data = null
	else
		autorun.stored_data = program
