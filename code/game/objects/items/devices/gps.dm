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

/datum/gps_waypoint/proc/same(datum/gps_waypoint/other)
	// same
	// so true oomfie
	// fr fr bestie
	return locality_equivalent(other) && name == other.name

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
	/// update name with tag
	var/update_name_tag = TRUE
	/// max waypoints
	var/waypoints_max = 25
	/// our waypoints
	var/list/datum/gps_waypoint/waypoints
	/// active tracking target - either a waypoint or a gps signal
	var/datum/tracking
	/// active tracking arrow object
	var/atom/movable/screen/waypoint_tracker/hud_arrow
	/// the perspective we're bound to right now
	var/datum/perspective/hud_bound

	/// emped?
	var/emped = FALSE
	/// emp unset timerid
	var/emp_timerid

	var/on = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.

/obj/item/gps/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps_signal, gps_tag)
	toggle_power(on, force = TRUE)

/obj/item/gps/Destroy()
	stop_tracking()
	QDEL_NULL(hud_arrow)
	QDEL_LIST(waypoints)
	. = ..()
	if(hud_bound)
		stack_trace("failed to clear hud bound during gc")

/obj/item/gps/update_icon()
	cut_overlays()
	if(emped)
		add_overlay("emp")
	else if(on)
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
		if(NAMEOF(src, on), NAMEOF(src, hide_signal))
			update_emit()
		if(NAMEOF(src, emped))
			update_icon()
			update_emit()
			if(!var_value && emp_timerid)
				deltimer(emp_timerid)

//? we use very simple perspective hooks as mob perspectives shouldn't be deleting

/obj/item/gps/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	bind_perspective(user.get_perspective())

/obj/item/gps/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	bind_perspective(null)

/obj/item/gps/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Alt-click to switch it [on? "off" : "on"].")

// todo: better altclick system
/obj/item/gps/AltClick(mob/user)
	. = ..()
	if(.)
		return
	if(!user.Reachability(src))
		return
	toggle_power(user = user)

/obj/item/gps/attackby(obj/item/I, mob/user, clickchain_flags, list/params)
	if(istype(I, /obj/item/gps))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/gps/transfer_to = I
		var/list/needed = list()
		for(var/datum/gps_waypoint/P1 as anything in waypoints)
			var/unnecessary = FALSE
			for(var/datum/gps_waypoint/P2 as anything in transfer_to.waypoints)
				if(P1.same(P2))
					unnecessary = TRUE
					break
			if(unnecessary)
				continue
			needed += P1
		if(!length(needed))
			return
		var/max_to_transfer = min(length(needed), transfer_to.waypoints_max - (transfer_to.waypoints))
		if(max_to_transfer <= 0)
			user.action_feedback(SPAN_WARNING("[transfer_to] has no more room to store waypoints."), src)
			return
		if(max_to_transfer < length(needed))
			user.action_feedback(SPAN_WARNING("Waypoints partially transferred: insffucient space."), src)
		else
			user.action_feedback(SPAN_NOTICE("Waypoints transferred."), src)
		LAZYINITLIST(transfer_to.waypoints)
		transfer_to.waypoints += needed
		transfer_to.push_waypoint_data()
	return ..()

/obj/item/gps/emp_act(severity)
	emped = TRUE
	update_emit()
	update_icon()
	if(emp_timerid)
		deltimer(emp_timerid)
	else
		visible_message(SPAN_WARNING("[src] overloads!"), range = MESSAGE_RANGE_COMBAT_SILENCED)
	emp_timerid = addtimer(CALLBACK(src, /obj/item/gps/proc/reset_emped), 5 MINUTES / severity, TIMER_STOPPABLE)

/obj/item/gps/proc/reset_emped()
	if(!emped)
		return
	emped = FALSE
	update_emit()
	update_icon()
	visible_message(SPAN_WARNING("[src] clicks, resetting itself from the electromagnetic interference."))

/obj/item/gps/attack_self(mob/user)
	. = ..()
	// TODO: ATTACK_SELF REFACTOR
	ui_interact(user)

/obj/item/gps/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(emped)
		to_chat(user, SPAN_WARNING("[src] is still spitting out gibberish!"))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Gps", name)
		ui.open()

/**
 * bind our hud rendering to a perspective
 */
/obj/item/gps/proc/bind_perspective(datum/perspective/pers)
	if(pers == hud_bound)
		return
	if(hud_bound)
		if(hud_arrow)
			hud_bound.RemoveScreen(hud_arrow)
		hud_bound = null
	hud_bound = pers
	if(!hud_bound)
		return
	if(hud_arrow)
		hud_bound.AddScreen(hud_arrow)

/**
 * start tracking a target - either a gps signal or a waypoint
 */
/obj/item/gps/proc/start_tracking(datum/target)
	if(!(istype(target, /datum/gps_waypoint) || istype(target, /datum/component/gps_signal)))
		stop_tracking()
		return FALSE
	if(target == tracking)
		return FALSE
	if(tracking)
		stop_tracking()
	tracking = target
	RegisterSignal(tracking, COMSIG_PARENT_QDELETING, /obj/item/gps/proc/stop_tracking)
	if(!hud_arrow)
		hud_arrow = new /atom/movable/screen/waypoint_tracker/gps
		hud_bound?.AddScreen(hud_arrow)
	hud_arrow.set_disabled(FALSE)
	update_tracking()
	START_PROCESSING(SSprocessing, src)
	return TRUE

/**
 * stop tracking a target
 */
/obj/item/gps/proc/stop_tracking()
	if(!tracking)
		return FALSE
	UnregisterSignal(tracking, COMSIG_PARENT_QDELETING)
	tracking = null
	// just kick it out
	hud_arrow?.set_disabled(TRUE)
	STOP_PROCESSING(SSprocessing, src)
	return TRUE

/obj/item/gps/process(delta_time)
	update_tracking()

/**
 * updates tracking target
 */
/obj/item/gps/proc/update_tracking()
	if(!hud_bound || !tracking)
		return
	var/angle
	var/valid = TRUE
	var/curr_l_id = SSmapping.level_id(get_z(src))
	var/turf/T = get_turf(src)
	if(!T)
		hud_arrow?.set_disabled(TRUE)
		return
	if(istype(tracking, /datum/gps_waypoint))
		var/datum/gps_waypoint/waypoint = tracking
		if(waypoint.level_id != curr_l_id)
			valid = FALSE
		else
			angle = arctan(waypoint.x - T.x, waypoint.y - T.y)
	else if(istype(tracking, /datum/component/gps_signal))
		var/datum/component/gps_signal/sig = tracking
		var/atom/A = sig.parent
		var/turf/AT = get_turf(A)
		if(SSmapping.level_id(get_z(A)) != curr_l_id)
			valid = FALSE
		else
			angle = arctan(AT.x - T.x, AT.y - T.y)
	else
		stop_tracking()
		CRASH("invalid tracking target detected and cleared")
	if(valid)
		hud_arrow?.set_angle(angle)
		hud_arrow?.set_disabled(FALSE)
	else
		hud_arrow?.set_disabled(TRUE)

/**
 * set our tag
 */
/obj/item/gps/proc/set_tag(new_tag)
	gps_tag = new_tag
	update_tag()

/**
 * update our tag
 */
/obj/item/gps/proc/update_tag()
	var/datum/component/gps_signal/sig = GetComponent(/datum/component/gps_signal)
	sig.set_gps_tag(gps_tag)
	if(update_name_tag)
		name = "[initial(name)] ([gps_tag])"

/**
 * set power
 */
/obj/item/gps/proc/toggle_power(new_state = !on, mob/user, force = FALSE)
	if(new_state == on && !force)
		return

	if(new_state)
		if(emped)
			if(user)
				to_chat(user, SPAN_WARNING("The GPS is spouting gibberish."))
			return
		if(user)
			to_chat(user, SPAN_NOTICE("[src] is now active, and visible to other GPS devices."))
		on = TRUE
		update_emit()
		update_icon()
	else
		if(user)
			to_chat(user, SPAN_NOTICE("[src] is now inactive, and invisible to other GPS devices."))
		on = FALSE
		update_emit()
		update_icon()

/**
 * sets if we should transmit
 */
/obj/item/gps/proc/set_hidden(new_hidden)
	hide_signal = new_hidden
	update_emit()

/**
 * returns if we should transmit
 */
/obj/item/gps/proc/should_emit()
	return !hide_signal && on && !emped

/**
 * updates our transmit mode
 */
/obj/item/gps/proc/update_emit()
	var/datum/component/gps_signal/sig = GetComponent(/datum/component/gps_signal)
	sig.set_disabled(!should_emit())

/**
 * encodes waypoint data
 */
/obj/item/gps/proc/ui_waypoint_data()
	var/list/data = list()
	for(var/datum/gps_waypoint/point as anything in waypoints)
		data[++data.len] = list(
			"name" = point.name,
			"x" = point.x,
			"y" = point.y,
			"level" =  point.level_id,
			"ref" = ref(point),
		)
	return data

/obj/item/gps/proc/push_waypoint_data()
	push_ui_data(data = list("waypoints" = ui_waypoint_data()))

/obj/item/gps/ui_static_data(mob/user)
	. = ..()
	.["waypoints"] = ui_waypoint_data()

/obj/item/gps/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	.["on"] = !!on
	.["tag"] = gps_tag
	.["visible"] = !hide_signal
	.["long_range"] = !!long_range
	.["local_mode"] = !!local_mode
	.["has_stealth"] = !!can_hide_signal
	.["updating"] = ui? ui.autoupdate : FALSE
	.["tracking"] = isnull(tracking)? "" : ref(tracking)

	if(!on)
		return
	var/turf/curr = get_turf(src)
	var/list/detecting_levels = GLOB.using_map.get_map_levels(curr.z, long_range)
	.["x"] = curr.x
	.["y"] = curr.y
	.["level"] = SSmapping.level_id(curr.z)
	var/list/others = list()
	.["signals"] = others
	var/datum/component/gps_signal/our_sig = GetComponent(/datum/component/gps_signal)
	for(var/other_z in detecting_levels)
		var/list/gpses = GLOB.gps_transmitters[other_z]
		var/l_id = SSmapping.level_id(other_z)
		for(var/datum/component/gps_signal/sig as anything in gpses)
			if(sig == our_sig)
				continue
			var/atom/A = sig.parent
			var/turf/T = get_turf(A)
			others += list(list(
				"x" = T.x,
				"y" = T.y,
				"level" = l_id,
				"ref" = ref(sig),
				"name" = sig.gps_tag
			))

/obj/item/gps/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!usr?.Reachability(src))
		return TRUE
	switch(action)
		if("tag")
			set_tag(params["tag"]? sanitize_atom_name(params["tag"], 32) : "NULL")
			return TRUE
		if("power")
			toggle_power(user = usr)
			return TRUE
		if("range")
			local_mode = !local_mode
			return TRUE
		if("hide")
			if(!can_hide_signal)
				return FALSE
			hide_signal = !hide_signal
			return TRUE
		if("add_waypoint")
			var/tag_as = sanitize_atom_name(params["name"], 32)
			if(!tag_as)
				return FALSE
			var/turf/T = get_turf(src)
			add_waypoint(tag_as, text2num(params["x"]) || T.x, text2num(params["y"]) || T.y, params["level_id"] || SSmapping.level_id(T.z))
			return FALSE // add waypoint pushes data already
		if("del_waypoint")
			//* RAW LOCATE IN HREF WARNING: RECEIVING PROC WILL SANITY CHECK.
			remove_waypoint(locate(params["ref"]))
			return FALSE // remove waypoint pushes data already
		if("select_target")
			//* RAW LOCATE IN HREF WARNING: RECEIVING PROC WILL SANITY CHECK.
			start_tracking(locate(params["ref"]))
			return TRUE
		if("toggle_update")
			ui.set_autoupdate(!ui.autoupdate)
			return TRUE // push one more time
		if("track")
			//* RAW LOCATE IN HREF WARNING: RECEIVING PROC WILL SANITY CHECK.
			var/datum/D = locate(params["ref"])
			if(D == tracking)
				return stop_tracking()
			return start_tracking(D)

/obj/item/gps/proc/add_waypoint(name, x, y, level_id)
	if(!x || !y || !level_id || !name)
		return
	var/datum/gps_waypoint/point = new
	point.name = name
	point.x = x
	point.y = y
	point.level_id = level_id
	for(var/datum/gps_waypoint/p2 as anything in waypoints)
		// de dupe
		if(!p2.same(point))
			continue
		qdel(point)
		return
	// inject
	LAZYINITLIST(waypoints)
	waypoints += point
	push_waypoint_data()

/obj/item/gps/proc/remove_waypoint(datum/gps_waypoint/point)
	if(!(point in waypoints))
		return
	waypoints -= point
	if(point == tracking)
		stop_tracking()
	push_waypoint_data()

/obj/item/gps/on // Defaults to off to avoid polluting the signal list with a bunch of GPSes without owners. If you need to spawn active ones, use these.
	on = TRUE

/obj/item/gps/command
	icon_state = "gps-com"
	gps_tag = "COM0"

/obj/item/gps/command/on
	on = TRUE

/obj/item/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/gps/security/on
	on = TRUE

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/gps/medical/on
	on = TRUE

/obj/item/gps/science
	icon_state = "gps-sci"
	gps_tag = "SCI0"

/obj/item/gps/science/on
	on = TRUE

/obj/item/gps/science/rd
	icon_state = "gps-rd"
	gps_tag = "RD0"

/obj/item/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/gps/security/on
	on = TRUE

/obj/item/gps/security/hos
	icon_state = "gps-hos"
	gps_tag = "HOS0"

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/gps/medical/on
	on = TRUE

/obj/item/gps/medical/cmo
	icon_state = "gps-cmo"
	gps_tag = "CMO0"

/obj/item/gps/engineering
	icon_state = "gps-eng"
	gps_tag = "ENG0"

/obj/item/gps/engineering/on
	on = TRUE

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
	on = TRUE

/obj/item/gps/explorer
	icon_state = "gps-exp"
	gps_tag = "EXP0"
	desc = "A positioning system helpful for rescuing trapped or injured explorers, keeping one on you at all times while exploring might just save your life."

/obj/item/gps/explorer/on
	on = TRUE

/obj/item/gps/survival
	icon_state = "gps-exp"
	gps_tag = "SOS0"
	long_range = FALSE
	local_mode = TRUE

/obj/item/gps/survival/on
	on = TRUE

/obj/item/gps/robot
	icon_state = "gps-borg"
	gps_tag = "SYNTH0"
	desc = "A synthetic internal positioning system. Used as a recovery beacon for damaged synthetic assets, or a collaboration tool for mining or exploration teams."
	on = TRUE  // On by default.

/obj/item/gps/internal // Base type for immobile/internal GPS units.
	icon_state = "internal"
	gps_tag = "Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM
	on = TRUE  // Meant to point to a location, so it needs to be on.
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
