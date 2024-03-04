// remote version of /datum/computer_file/program/power_monitor (doesnt require cable under)
/datum/computer_file/program/power_monitor_remote
	filename = "ampcheckremote"
	filedesc = "AmpCheck: Remote"
	category = PROGRAM_CATEGORY_ENGI
	program_icon_state = "power_monitor"
	extended_desc = "This program connects wirelessly to sensors around the vessel to provide information about electrical systems"
	ui_header = "power_norm.gif"
	transfer_access = ACCESS_ENGINEERING_MAIN
	usage_flags = PROGRAM_ALL
	requires_ntnet = TRUE
	size = 9
	tgui_id = "NtosPowerMonitor"
	program_icon = "plug"

	var/list/obj/machinery/power/sensor/sensors
	var/obj/machinery/power/sensor/sensor

/datum/computer_file/program/power_monitor_remote/ui_data()
	. = ..()
	. += sensor?.ui_data()
	var/list/sensors = list()

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in sensors)
		if(!(S.z in map_levels))
			continue
		sensors.Add(list(list(
			"name" = S.name_tag,
			"alarm" = S.check_grid_warning()
		)))

	.["all_sensors"] = sensors

/datum/computer_file/program/power_monitor_remote/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if (.)
		return

	switch(action)
		if("refresh")
			refresh_sensors()
			return TRUE
		if("setsensor")
			if (!params["id"])
				return FALSE
			for(var/obj/machinery/power/sensor/S in sensors)
				if (S.name_tag == params["id"])
					sensor = S
					return TRUE
			return TRUE

/datum/computer_file/program/power_monitor_remote/proc/refresh_sensors()
	sensors = list()

	// Handle ultranested programs
	var/turf/T = get_turf(ui_host())

	if(!T) // Safety check
		return

	var/list/levels = list()
	levels += (LEGACY_MAP_DATUM).get_map_levels(T.z, FALSE)
	for(var/obj/machinery/power/sensor/S in GLOB.machines)
		if((S.loc.z == T.z) || (S.loc.z in levels) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				log_mapping("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				sensors |= S
