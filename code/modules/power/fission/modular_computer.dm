/datum/computer_file/program/fission_monitor
	filename = "fismon"
	filedesc = "Fission Monitoring"
	nanomodule_path = /datum/nano_module/fission_monitor/
	program_icon_state = "smmon_0"
	program_key_state = "tech_key"
	program_menu_icon = "notice"
	extended_desc = "This program connects to specially calibrated sensors to provide information on the status of a fission core."
	ui_header = "smmon_0.gif"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "fission monitoring system"
	size = 5
	var/last_status = 0

/datum/computer_file/program/fission_monitor/process_tick()
	..()
	var/datum/nano_module/fission_monitor/NMS = NM
	var/new_status = istype(NMS) ? NMS.get_status() : 0
	if(last_status != new_status)
		last_status = new_status
		ui_header = "smmon_[last_status].gif"
		program_icon_state = "smmon_[last_status]"
		if(istype(computer))
			computer.update_icon()

/datum/nano_module/fission_monitor
	name = "Fission monitor"
	var/list/fissioncores
	var/obj/machinery/power/fission/active = null		// Currently selected fission core.

/datum/nano_module/fission_monitor/Destroy()
	. = ..()
	active = null
	fissioncores = null

/datum/nano_module/fission_monitor/New()
	..()
	refresh()

// Refreshes list of active fission cores
/datum/nano_module/fission_monitor/proc/refresh()
	fissioncores = list()
	var/z = get_z(nano_host())
	if(!z)
		return
	var/valid_z_levels = GLOB.using_map.get_map_levels(z)
	for(var/obj/machinery/power/fission/F in machines)
		// Unsecured, blown up, not within coverage, not on a tile.
		if(!F.anchored || F.exploded || !(F.z in valid_z_levels) || !istype(F.loc, /turf/))
			continue
		fissioncores.Add(F)

	if(!(active in fissioncores))
		active = null

/datum/nano_module/fission_monitor/proc/get_status()
	. = FALSE
	for(var/obj/machinery/power/fission/F in fissioncores)
		if(F.anchored && F.powered())
			. = TRUE
			break

/datum/nano_module/fission_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(istype(active) && active.anchored)
		data = data + active.ui_data(TRUE)
		data["active"] = 1

	else
		var/list/FCS = list()
		for(var/obj/machinery/power/fission/F in fissioncores)
			var/area/A = get_area(F)
			if(!A)
				fissioncores = fissioncores - F
				continue

			FCS.Add(list(list(
			"area_name" = A.name,
			"core_temp" = round(F.temperature),
			"uid" = F.uid
			)))

		data["active"] = 0
		data["fissioncores"] = FCS

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fission_monitor_prog.tmpl", "Nuclear Fission Core", 500, 600, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/fission_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active = null
		return 1
	if( href_list["refresh"] )
		refresh()
		return 1
	if( href_list["set"] )
		var/newuid = text2num(href_list["set"])
		for(var/obj/machinery/power/fission/F in fissioncores)
			if(F.uid == newuid)
				active = F
		return 1