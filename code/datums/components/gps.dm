///Global GPS_list. All  GPS components get saved in here for easy reference.
GLOBAL_LIST_EMPTY(GPS_list)
///GPS component. Atoms that have this show up on gps. Pretty simple stuff.
/datum/component/gps
	var/gps_tag = "GEN0"
	var/emped = FALSE
	var/tracking = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.
	var/update_name = TRUE		// If the GPS tag is added to the end of the name

/datum/component/gps/Destroy()
	GLOB.GPS_list -= src
	return ..()

/datum/component/gps/Initialize(_gpstag = "GEN0", _emped = FALSE, _tracking = FALSE, _long_range = FALSE, _local_mode = FALSE, _hide_signal = FALSE, _can_hide_signal = FALSE, _update_name = TRUE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	gps_tag = _gpstag
	emped = _emped
	tracking = _tracking
	long_range = _long_range
	local_mode = _local_mode
	hide_signal = _hide_signal
	can_hide_signal = _can_hide_signal
	update_name = _update_name

	GLOB.GPS_list += src

	var/atom/A = parent
	A.update_icon()
	if(update_name)
		A.name = "[initial(A.name)] ([gps_tag])"

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/interact)
	RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, .proc/on_emp_act)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(parent, COMSIG_CLICK_ALT, .proc/on_AltClick)

///Called on COMSIG_ITEM_ATTACK_SELF
/datum/component/gps/proc/interact(datum/source, mob/user)
	if(user)
		display(user)

///Called on COMSIG_PARENT_EXAMINE
/datum/component/gps/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += "<span class='notice'>Alt-click to switch it [tracking ? "off":"on"].</span>"

///Called on COMSIG_ATOM_EMP_ACT
/datum/component/gps/proc/on_emp_act(datum/source, severity)
	if(emped) // Without a fancy callback system, this will have to do.
		return
	var/severity_modifier = severity ? severity : 4 // In case emp_act gets called without any arguments.
	var/duration = 5 MINUTES / severity_modifier
	emped = TRUE
	var/atom/A = parent
	A.update_icon()

	spawn(duration)
		emped = FALSE
		A.update_icon()
		A.visible_message("\The [parent] appears to be functional again.")

///Calls toggletracking
/datum/component/gps/proc/on_AltClick(datum/source, mob/user)
	toggletracking(user)

///Toggles the tracking for the gps
/datum/component/gps/proc/toggletracking(mob/user)
	if(!istype(user))
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/atom/A = parent
	if(tracking)
		to_chat(user, "[parent] is no longer tracking, or visible to other GPS devices.")
		tracking = FALSE
		A.update_icon()
	else
		to_chat(user, "[parent] is now tracking, and visible to other GPS devices.")
		tracking = TRUE
		A.update_icon()

// Compiles all the data not available directly from the GPS
 // Like the positions and directions to all other GPS units
/datum/component/gps/proc/display_list()
	var/list/dat = list()

	var/turf/curr = get_turf(parent)
	var/area/my_area = get_area(parent)

	dat["my_area_name"] = my_area.name
	dat["curr_x"] = curr.x
	dat["curr_y"] = curr.y
	dat["curr_z"] = curr.z
	dat["curr_z_name"] = GLOB.using_map.get_zlevel_name(curr.z)
	var/list/gps_list = list()
	dat["gps_list"] = gps_list
	dat["z_level_detection"] = GLOB.using_map.get_map_levels(curr.z, long_range)

	for(var/gps in GLOB.GPS_list - src)
		var/datum/component/gps/G = gps
		if(!G.tracking || G.emped || G.hide_signal)
			continue

		var/turf/T = get_turf(G.parent)
		if(local_mode && curr.z != T.z)
			continue
		if(!(T.z in dat["z_level_detection"]))
			continue

		var/list/gps_data[0]
		gps_data["ref"] = G
		gps_data["gps_tag"] = G.gps_tag

		var/area/A = get_area(G.parent)
		gps_data["area_name"] = A.name
		if(istype(A, /area/submap))
			gps_data["area_name"] = "Unknown Area" // Avoid spoilers.

		gps_data["z_name"] = GLOB.using_map.get_zlevel_name(T.z)
		gps_data["direction"] = get_adir(curr, T)
		gps_data["degrees"] = round(Get_Angle(curr,T))
		gps_data["distX"] = T.x - curr.x
		gps_data["distY"] = T.y - curr.y
		gps_data["distance"] = get_dist(curr, T)
		gps_data["local"] = (curr.z == T.z)
		gps_data["x"] = T.x
		gps_data["y"] = T.y
		gps_list[++gps_list.len] = gps_data

	return dat

/datum/component/gps/proc/display(mob/user)
	if(!tracking)
		to_chat(user, "The device is off. Alt-click it to turn it on.")
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/list/dat = list()
	var/list/gps_data = display_list()

	dat += "Current location: [gps_data["my_area_name"]] <b>([gps_data["curr_x"]], [gps_data["curr_y"]], [gps_data["curr_z_name"]])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	var/list/gps_list = gps_data["gps_list"]
	if(gps_list.len)
		dat += "Detected signals;"
		for(var/gps in gps_data["gps_list"])
			if(istype(gps_data["ref"], /obj/item/gps/internal/poi))
				dat += "    [gps["gps_tag"]]: [gps["area_name"]] - [gps["local"] ? "[gps["direction"]] Dist: [round(gps["distance"], 10)]m" : "in \the [gps["z_name"]]"]"
			else
				dat += "    [gps["gps_tag"]]: [gps["area_name"]], ([gps["x"]], [gps["y"]]) - [gps["local"] ? "[gps["direction"]] Dist: [gps["distX"] ? "[abs(round(gps["distX"], 1))]m [(gps["distX"] > 0) ? "E" : "W"], " : ""][gps["distY"] ? "[abs(round(gps["distY"], 1))]m [(gps["distY"] > 0) ? "N" : "S"]" : ""]" : "in \the [gps["z_name"]]"]"
	else
		dat += "No other signals detected."

	var/result = dat.Join("<br>")
	to_chat(user, result)

/datum/component/gps/Topic(var/href, var/list/href_list)
	if(..())
		return 1


	if(href_list["tag"])
		var/atom/A = parent
		var/a = input("Please enter desired tag.", A.name, gps_tag) as text
		a = uppertext(copytext(sanitize(a), 1, 11))
		if(in_range(A, usr))
			gps_tag = a
			if(update_name)
				A.name = "[initial(A.name)] ([gps_tag])"
			to_chat(usr, "You set your GPS's tag to '[gps_tag]'.")

	if(href_list["range"])
		local_mode = !local_mode
		to_chat(usr, "You set the signal receiver to [local_mode ? "'NARROW'" : "'BROAD'"].")

	if(href_list["hide"])
		if(!can_hide_signal)
			return
		hide_signal = !hide_signal
		to_chat(usr, "You set the device to [hide_signal ? "not " : ""]broadcast a signal while scanning for other signals.")
