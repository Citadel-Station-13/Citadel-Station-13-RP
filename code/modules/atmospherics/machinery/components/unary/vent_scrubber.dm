// todo: better interface logging
/obj/machinery/atmospherics/component/unary/vent_scrubber
	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"
	pipe_state = "scrubber"

	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes

	level = 1

	hijack_require_exposed = TRUE
	default_multitool_hijack = TRUE
	tgui_interface = "AtmosVentScrubber"
	atmos_component_ui_flags = NONE

	/// registered area
	var/area/registered_area
	/// auto name by area
	var/name_from_area = TRUE
	/// show on area
	var/controllable_from_alarm = TRUE
	/// cares about siphoning/filling/alarm modes
	var/environmental = TRUE

	/// filter ids. both scrub_ids and scrub_groups must be set to not automatically use default.
	var/list/scrub_ids
	/// filter groups. both scrub_ids and scrub_groups must be set to not automatically use default.
	var/list/scrub_groups
	/// filter defaults - either an enum for SCRUBBER_DEFAULT_* or a list of ids and groups.
	var/scrub_default = SCRUBBER_DEFAULT_STATION
	/// siphoning?
	var/siphoning
	/// siphoning default
	var/siphoning_default = FALSE
	/// high power?
	var/expanded
	/// high power default
	var/expanded_default = FALSE

	/// default scrub volume
	var/scrub_volume = 2500
	/// additional power when expanded
	var/expanded_power = 7500
	/// additional volume when expanded
	var/expanded_scrub = 1250
	/// mole boost
	var/scrub_boost = 50

	var/area_uid
	var/id_tag = null

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/hibernate = 0 //Do we even process?

	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/component/unary/vent_scrubber/Initialize(mapload)
	. = ..()
	if(isnull(siphoning))
		siphoning = siphoning_default
	if(isnull(expanded))
		expanded = expanded_default
	if(isnull(scrub_ids) || isnull(scrub_groups))
		reset_scrubbing_to_default()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER

	icon = null
	registered_area = get_area(loc)
	area_uid = registered_area.uid
	registered_area?.register_scrubber(src)
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/machinery/atmospherics/component/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	registered_area?.unregister_scrubber(src)
	return ..()

/obj/machinery/atmospherics/component/unary/vent_scrubber/proc/reset_scrubbing_to_default()
	scrub_ids = list()
	scrub_groups = NONE
	var/list/default = SSair.scrubber_defaults[scrub_default]
	if(isnull(default))
		return
	for(var/key in default)
		if(istext(key))
			scrub_ids += key
		else if(isnum(key))
			scrub_groups |= key

/obj/machinery/atmospherics/component/unary/vent_scrubber/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	cut_overlays()

	var/scrubber_icon = "scrubber"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(welded)
		scrubber_icon += "weld"
	else if(!powered())
		scrubber_icon += "off"
	else
		scrubber_icon += "[on ? "[siphoning ? "in" : "on"]" : "off"]"

	add_overlay(icon_manager.get_atmos_icon("device", , , scrubber_icon))

/obj/machinery/atmospherics/component/unary/vent_scrubber/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/component/unary/vent_scrubber/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/component/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AScr",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = !siphoning, // legacy
		"siphoning" = siphoning,
		"expanded" = expanded,
		"panic" = siphoning, // legacy
		"scrub_ids" = scrub_ids,
		"scrub_groups" = scrub_groups,
		"sigtype" = "status",
	)

	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/component/unary/vent_scrubber/atmos_init()
	..()
	radio_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
	if (frequency)
		set_frequency(frequency)
		src.broadcast_status()


/obj/machinery/atmospherics/component/unary/vent_scrubber/proc/can_scrub()
	if(machine_stat & (NOPOWER|BROKEN))
		return 0
	if(!on)
		return 0
	if(welded)
		return 0
	return 1


/obj/machinery/atmospherics/component/unary/vent_scrubber/process(delta_time)
	..()

	if (hibernate)
		return 1
	if (!node)
		set_on(FALSE)
	if(!can_scrub())
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	var/using_power = expanded? expanded_power + power_rating : power_rating

	if(siphoning)
		power_current = xgm_pump_gas(environment, air_contents, limit_power = using_power)
	else
		var/using_volume = expanded? expanded_scrub + scrub_volume : scrub_volume
		power_current = xgm_scrub_gas_volume(environment, air_contents, scrub_ids, scrub_groups, using_volume, using_power, scrub_boost)

	if (power_current >= 0)
		last_power_draw_legacy = power_current
		use_power(power_current)

	if(network)
		network.update = 1

	return 1

/obj/machinery/atmospherics/component/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/component/unary/vent_scrubber/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/atmospherics/component/unary/vent_scrubber/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!W.is_wrench())
		return ..()
	if (!(machine_stat & NOPOWER) && on)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], turn it off first.</span>")
		return 1
	var/turf/T = src.loc
	if (node && node.level==1 && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	if(unsafe_pressure())
		to_chat(user, "<span class='warning'>You feel a gust of air blowing in your face as you try to unwrench [src]. Maybe you should reconsider..</span>")
	add_fingerprint(user)
	playsound(src, W.tool_sound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.tool_speed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		deconstruct()

/obj/machinery/atmospherics/component/unary/vent_scrubber/examine(mob/user, dist)
	. = ..()
	. += "A small gauge in the corner reads [round(last_flow_rate_legacy, 0.1)] L/s; [round(last_power_draw_legacy)] W"
	if(welded)
		. += "It seems welded shut."

/// Scrubber Welding

/obj/machinery/atmospherics/component/unary/vent_scrubber/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>Now welding the vent.</span>")
			if(do_after(user, 20 * WT.tool_speed))
				if(!src || !WT.isOn()) return
				playsound(src.loc, WT.tool_sound, 50, 1)
				if(!welded)
					user.visible_message("<span class='notice'>\The [user] welds the vent shut.</span>", "<span class='notice'>You weld the vent shut.</span>", "You hear welding.")
					welded = 1
					update_icon()
				else
					user.visible_message("<span class='notice'>[user] unwelds the vent.</span>", "<span class='notice'>You unweld the vent.</span>", "You hear welding.")
					welded = 0
					update_icon()
			else
				to_chat(user, "<span class='notice'>The welding tool needs to be on to start this task.</span>")
		else
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			return 1
	else
		..()

/**
 * encodes data for AtmosScrubberControl interface component
 */
/obj/machinery/atmospherics/component/unary/vent_scrubber/proc/ui_scrubber_data()
	return list(
		"siphon" = siphoning,
		"expand" = expanded,
		"scrubIDs" = scrub_ids,
		"scrubGroups" = scrub_groups,
		"power" = on,
	)

/obj/machinery/atmospherics/component/unary/vent_scrubber/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/target = params["target"]
	switch(action)
		if("power")
			set_on(!on)
			return TRUE
		if("expand")
			//! warning: legacy
			expanded = !expanded
			update_icon()
			return TRUE
		if("siphon")
			//! warning: legacy
			siphoning = !siphoning
			update_icon()
			return TRUE
		if("id")
			if(!global.gas_data.gas_id_filterable(target))
				return TRUE
			scrub_ids ^= target
			return TRUE
		if("group")
			// the << 0 gets rid of any floating points incase someone somehow puts in a non bitfield
			target = (text2num(target) << 0)
			if(!global.gas_data.gas_groups_all_filterable(target))
				return TRUE
			scrub_groups ^= target
			return TRUE

/obj/machinery/atmospherics/component/unary/vent_scrubber/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["state"] = ui_scrubber_data()

/obj/machinery/atmospherics/component/unary/vent_scrubber/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["gasContext"] = global.gas_data.tgui_gas_context()
	.["name"] = name

//* Signal Handling - Order of application is same as these comments.
/// environmental: void. set to ignore the signal if we're not an environmental vent.
/// hard_reset: resets everything to default.
/// power: 0 | 1. sets us to be on/off. overrides power_toggle.
/// power_toggle: void. toggles us on/off.
/// siphon: 0 | 1 | "default". sets if we're siphoning. overrides siphon_toggle.
/// siphon_toggle: void. toggles siphoning on/off.
/// expand: 0 | 1 | "default". sets if we're expanded / high powered mode. overrides expand_toggle.
/// expand_toggle: void. sets if we're in high powered mode.
/// scrub_reset: resets scrubbing to default.
/// scrub_ids: list[string]. sets scrub ids. overrides scrub_ids_toggle.
/// scrub_ids_toggle: list[string]. toggles scrubbing gas ids.
/// scrub_groups: bitfield. sets groups to scrub. overrides scrub_groups_toggle.
/// scrub_groups_toggle: bitfield. toggles scrubbing these groups.

/obj/machinery/atmospherics/component/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(!isnull(signal.data["environmental"]) && environmental)
		return FALSE

	if(!isnull(signal.data["hard_reset"]))
		expanded = expanded_default
		siphoning = siphoning_default
		reset_scrubbing_to_default()
	if(!isnull(signal.data["power"]))
		set_on(!!text2num(signal.data["power"]))
	else if(!isnull(signal.data["power_toggle"]))
		set_on(!on)
	if(!isnull(signal.data["siphon"]))
		siphoning = signal.data["siphon"] == "default"? siphoning_default : !!text2num(signal.data["siphon"])
	else if(!isnull(signal.data["siphon_toggle"]))
		siphoning = !siphoning
	if(!isnull(signal.data["expand"]))
		expanded = signal.data["expand"] == "default"? expanded_default : !!text2num(signal.data["expand"])
	else if(!isnull(signal.data["expand_toggle"]))
		expanded = !expanded
	if(!isnull(signal.data["scrub_reset"]))
		reset_scrubbing_to_default()
	if(!isnull(signal.data["scrub_ids"]))
		var/list/target_ids = signal.data["scrub_ids"]
		if(islist(target_ids))
			if(target_ids.len > SCRUBBER_MAX_GAS_IDS)
				target_ids.len = SCRUBBER_MAX_GAS_IDS
			for(var/key in target_ids)
				if(!global.gas_data.gas_id_filterable(key))
					target_ids -= key
			scrub_ids = target_ids
	else if(!isnull(signal.data["scrub_ids_toggle"]))
		var/list/target_ids = signal.data["scrub_ids_toggle"]
		if(islist(target_ids))
			if(target_ids.len > SCRUBBER_MAX_GAS_IDS * 2)
				target_ids.len = SCRUBBER_MAX_GAS_IDS * 2
			for(var/key in target_ids)
				if(!global.gas_data.gas_id_filterable(key))
					target_ids -= key
			scrub_ids ^= target_ids
			if(scrub_ids.len > SCRUBBER_MAX_GAS_IDS)
				scrub_ids.len = SCRUBBER_MAX_GAS_IDS
	if(!isnull(signal.data["scrub_groups"]))
		scrub_groups = (GAS_GROUPS_FILTERABLE & (text2num(signal.data["scrub_groups"])))
	else if(!isnull(signal.data["scrub_groups_toggle"]))
		scrub_groups ^= (GAS_GROUPS_FILTERABLE & (text2num(signal.data["scrub_groups_toggle"])))

	//! legacy below

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//			log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()

//* Subtypes

/obj/machinery/atmospherics/component/unary/vent_scrubber/on
	on = TRUE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/component/unary/vent_scrubber/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro
	icon_state = "map_scrubber_off"	/// Will get replaced on mapload

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/on
	on = TRUE
	icon_state = "map_scrubber_on_retro"

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	cut_overlays()

	var/scrubber_icon = "scrubber"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(welded)
		scrubber_icon += "retro_weld"
	else if(!powered())
		scrubber_icon += "retro_off"
	else
		scrubber_icon += "[use_power ? "[siphoning ? "retro_in" : "retro_on"]" : "retro_off"]"

	add_overlay(icon_manager.get_atmos_icon("device", , , scrubber_icon))
