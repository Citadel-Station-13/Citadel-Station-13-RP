
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

/datum/gps_waypoint
	/// name
	var/name
	/// x coord
	var/x
	/// y coord
	var/y
	/// virtual level id from ssmapping
	var/level_id

/datum/gps_waypoint/proc/locality_equivalent(datum/gps_waypoint/other)
	return x == other.x && y == other.y && level_id == other.level_id

/obj/item/gps
	name = "global positioning system"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/gps.dmi'
	icon_state = "gps-gen"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_MAGNET = 1)
	matter = list(MAT_STEEL = 500)

	/// our GPS tag
	var/gps_tag = "GEN0"
	/// max waypoints
	var/waypoints_max = 10
	/// our waypoints
	var/list/datum/gps_waypoint/waypoints
	/// active tracking target - either a waypoint or a gps signal
	var/datum/tracking
	/// active tracking arrow object
	var/atom/movable/screen/waypoint_tracker/hud_arrow
	/// the perspective we're bound to right now
	var/datum/perspective/hud_bound

	var/emped = FALSE
	var/tracking = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.

/obj/item/gps/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, gps_tag, emped, tracking, long_range, local_mode, hide_signal, can_hide_signal)

/obj/item/gps/Destroy()
	. = ..()
	qdel(GetComponent(/datum/component/gps))

/obj/item/gps/update_icon()
	cut_overlays()
	if(emped)
		add_overlay("emp")
	else if(tracking)
		add_overlay("working")

/obj/item/gps/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(raw_edit)
		return ..()
	switch(var_name)
		if(NAMEOF(src, tracking))
			return start_tracking(var_value)
	. = ..()
	switch(var_name)
		if(NAMEOF(src, gps_tag))
			update_tag()
		if(NAMEOF(src, tracking), NAMEOF(src, hide_signal))
			update_emit()
		if(NAMEOF(src, emped))
			update_icon()
			update_emit()

//? we use very simple perspective hooks as mob perspectives shouldn't be deleting

/obj/item/gps/pickup(mob/user, flags, atom/oldLoc)
	. = ..()

/obj/item/gps/dropped(mob/user, flags, atom/newLoc)
	. = ..()

/**
 * bind our hud rendering to a perspective
 */
/obj/item/gps/proc/bind_perspective(datum/perspective/pers)

/**
 * start tracking a target - either a gps signal or a waypoint
 */
/obj/item/gps/proc/start_tracking(datum/target)

/**
 * stop tracking a target
 */
/obj/item/gps/proc/stop_tracking()

/**
 * updates tracking target
 */
/obj/item/gps/proc/update_tracking()


/**
 * update our tag
 */
/obj/item/gps/proc/update_tag()
	var/datum/component/gps_signal/sig = GetComponent(/datum/component/gps_signal)
	sig.set_gps_tag(gps_tag)

/**
 * returns if we should transmit
 */
/obj/item/gps/proc/should_emit()
	return !hide_signal && tracking && !emped

/**
 * updates our transmit mode
 */
/obj/item/gps/proc/update_emit()
	var/datum/component/gps_signal/sig = GetComponent(/datum/component/gps_signal)
	sig.set_disabled(!should_emit())

/obj/item/gps/on // Defaults to off to avoid polluting the signal list with a bunch of GPSes without owners. If you need to spawn active ones, use these.
	tracking = TRUE

/obj/item/gps/command
	icon_state = "gps-com"
	gps_tag = "COM0"

/obj/item/gps/command/on
	tracking = TRUE

/obj/item/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/gps/security/on
	tracking = TRUE

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/gps/medical/on
	tracking = TRUE

/obj/item/gps/science
	icon_state = "gps-sci"
	gps_tag = "SCI0"

/obj/item/gps/science/on
	tracking = TRUE

/obj/item/gps/science/rd
	icon_state = "gps-rd"
	gps_tag = "RD0"

/obj/item/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/gps/security/on
	tracking = TRUE

/obj/item/gps/security/hos
	icon_state = "gps-hos"
	gps_tag = "HOS0"

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/gps/medical/on
	tracking = TRUE

/obj/item/gps/medical/cmo
	icon_state = "gps-cmo"
	gps_tag = "CMO0"

/obj/item/gps/engineering
	icon_state = "gps-eng"
	gps_tag = "ENG0"

/obj/item/gps/engineering/on
	tracking = TRUE

/obj/item/gps/engineering/ce
	icon_state = "gps-ce"
	gps_tag = "CE0"

/obj/item/gps/engineering/atmos
	icon_state = "gps-atm"
	gps_tag = "ATM0"

/obj/item/gps/mining
	icon_state = "gps-mine"
	gps_tag = "MINE0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."

/obj/item/gps/mining/on
	tracking = TRUE

/obj/item/gps/explorer
	icon_state = "gps-exp"
	gps_tag = "EXP0"
	desc = "A positioning system helpful for rescuing trapped or injured explorers, keeping one on you at all times while exploring might just save your life."

/obj/item/gps/explorer/on
	tracking = TRUE

/obj/item/gps/survival
	icon_state = "gps-exp"
	gps_tag = "SOS0"
	long_range = FALSE
	local_mode = TRUE

/obj/item/gps/survival/on
	tracking = TRUE

/obj/item/gps/robot
	icon_state = "gps-borg"
	gps_tag = "SYNTH0"
	desc = "A synthetic internal positioning system. Used as a recovery beacon for damaged synthetic assets, or a collaboration tool for mining or exploration teams."
	tracking = TRUE // On by default.

/obj/item/gps/internal // Base type for immobile/internal GPS units.
	icon_state = "internal"
	gps_tag = "Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM
	tracking = TRUE // Meant to point to a location, so it needs to be on.
	anchored = TRUE

/obj/item/gps/internal/base
	gps_tag = "NT_BASE"
	desc = "A homing signal from NanoTrasen's outpost."

/obj/item/gps/internal/poi
	gps_tag = "Unidentified Signal"
	desc = "A signal that seems forboding."

/obj/item/gps/syndie
	icon_state = "gps-syndie"
	gps_tag = "NULL"
	desc = "A positioning system that has extended range and can detect other GPS device signals without revealing its own. How that works is best left a mystery."
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	long_range = TRUE
	hide_signal = TRUE
	can_hide_signal = TRUE
