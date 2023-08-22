#define DEFAULT_PRESSURE_DELTA 10000

// todo: better interface logging
/obj/machinery/atmospherics/component/unary/vent_pump
	name = "Air Vent"
	desc = "Has a valve and pump attached to it"
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"
	pipe_state = "uvent"
	idle_power_usage = 150 //internal circuitry, friction losses and stuff
	power_rating = 30000

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY //connects to regular and supply pipes

	hijack_require_exposed = TRUE
	default_multitool_hijack = TRUE
	tgui_interface = "AtmosVentPump"
	atmos_component_ui_flags = NONE

	level = 1

	/// registered area
	var/area/registered_area
	/// auto name by area
	var/name_from_area = TRUE
	/// show on area
	var/controllable_from_alarm = TRUE
	/// cares about siphoning/filling/alarm modes
	var/environmental = TRUE

	/// pump direction
	var/pump_direction
	/// default pump direction
	var/pump_direction_default = ATMOS_VENT_DIRECTION_RELEASE
	/// external pressure limit
	var/external_pressure_bound = ONE_ATMOSPHERE
	/// external pressure limit default
	var/external_pressure_bound_default = ONE_ATMOSPHERE
	/// internal pressure limit
	var/internal_pressure_bound = 0
	/// internal pressure limit default
	var/internal_pressure_bound_default = 0
	/// pressure checks flag
	var/pressure_checks
	/// default pressure checks
	var/pressure_checks_default = ATMOS_VENT_CHECK_EXTERNAL

	var/area_uid
	var/id_tag = null

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/hibernate = 0 //Do we even process?

	var/radio_filter_out
	var/radio_filter_in

/*
	var/datum/looping_sound/air_pump/soundloop
*/

/obj/machinery/atmospherics/component/unary/vent_pump/Initialize(mapload)
	. = ..()
	if(isnull(external_pressure_bound))
		external_pressure_bound = external_pressure_bound_default
	if(isnull(internal_pressure_bound))
		internal_pressure_bound = internal_pressure_bound_default
	if(isnull(pressure_checks))
		pressure_checks = pressure_checks_default
	if(isnull(pump_direction))
		pump_direction = pump_direction_default
	/*
	soundloop = new(list(src), FALSE)
	*/
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP

	icon = null
	registered_area = get_area(loc)
	area_uid = registered_area.uid
	registered_area?.register_vent(src)
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/machinery/atmospherics/component/unary/vent_pump/Destroy()
	unregister_radio(src, frequency)
	registered_area?.unregister_vent(src)
	//QDEL_NULL(soundloop)
	return ..()

/obj/machinery/atmospherics/component/unary/vent_pump/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	cut_overlays()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(welded)
		vent_icon += "weld"
	else if(!on || !node || (machine_stat & (NOPOWER|BROKEN)))
		vent_icon += "off"
	else
		vent_icon += "[pump_direction ? "out" : "in"]"

	add_overlay(icon_manager.get_atmos_icon("device", , , vent_icon))

/obj/machinery/atmospherics/component/unary/vent_pump/update_underlays()
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

/obj/machinery/atmospherics/component/unary/vent_pump/hide()
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/component/unary/vent_pump/proc/can_pump()
	if(machine_stat & (NOPOWER|BROKEN))
		//soundloop.stop()
		return 0
	if(!on)
		//soundloop.stop()
		return 0
	if(welded)
		//soundloop.stop()
		return 0
	//soundloop.start()
	return 1

/obj/machinery/atmospherics/component/unary/vent_pump/process(delta_time)
	..()
	if (hibernate)
		return 1
	if(!node)
		set_on(FALSE)
	if(!can_pump())
		return 0

	var/datum/gas_mixture/environment = return_air()

	var/power_draw = -1

	//Figure out the target pressure difference
	var/pressure_delta = get_pressure_delta(environment)
	//src.visible_message("DEBUG >>> [src]: pressure_delta = [pressure_delta]")

	if((environment.temperature || air_contents.temperature) && pressure_delta > 0.5)
		if(pump_direction) //internal -> external
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
		else //external -> internal
			var/transfer_moles = calculate_transfer_moles(environment, air_contents, pressure_delta, (network)? network.volume : 0)

			//limit flow rate from turfs
			transfer_moles = min(transfer_moles, environment.total_moles*air_contents.volume/environment.volume)	//group_multiplier gets divided out here
			power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)


	if (power_draw >= 0)
		last_power_draw_legacy = power_draw
		use_burst_power(power_draw)
		if(network)
			network.update = 1

	return 1

/obj/machinery/atmospherics/component/unary/vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		if(pressure_checks & ATMOS_VENT_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & ATMOS_VENT_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, air_contents.return_pressure() - internal_pressure_bound) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & ATMOS_VENT_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & ATMOS_VENT_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, internal_pressure_bound - air_contents.return_pressure()) //increasing the pressure here

	return pressure_delta

/obj/machinery/atmospherics/component/unary/vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"area" = src.area_uid,
		"tag" = src.id_tag,
		"device" = "AVP",
		"power" = on,
		"direction" = pump_direction?("release"):("siphon"),
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"timestamp" = world.time,
		"sigtype" = "status",
		"power_draw" = last_power_draw_legacy,
		"flow_rate" = last_flow_rate_legacy,
	)

	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/component/unary/vent_pump/atmos_init()
	..()

	//some vents work his own special way
	radio_filter_in = frequency==1439?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==1439?(RADIO_TO_AIRALARM):null
	if(frequency)
		radio_connection = register_radio(src, frequency, frequency, radio_filter_in)
		src.broadcast_status()

/obj/machinery/atmospherics/component/unary/vent_pump/attackby(obj/item/W, mob/user)
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

/obj/machinery/atmospherics/component/unary/vent_pump/examine(mob/user, dist)
	. = ..()
	. += "A small gauge in the corner reads [round(last_flow_rate_legacy, 0.1)] L/s; [round(last_power_draw_legacy)] W"
	if(welded)
		. += "It seems welded shut."

/obj/machinery/atmospherics/component/unary/vent_pump/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/atmospherics/component/unary/vent_pump/attackby(obj/item/W, mob/user)
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

/**
 * Encodes UI data for AtmosVentState in tgui/interfaces/machines/AtmosVent.tsx
 */
/obj/machinery/atmospherics/component/unary/vent_pump/proc/ui_vent_data()
	return list(
		"pressureChecks" = pressure_checks,
		"internalPressure" = internal_pressure_bound,
		"externalPressure" = external_pressure_bound,
		"power" = on,
		"siphon" = !pump_direction,
	)

/obj/machinery/atmospherics/component/unary/vent_pump/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!isnull(ui))
		return
	ui = new(user, src, "AtmosVentPump")
	ui.open()

/obj/machinery/atmospherics/component/unary/vent_pump/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["state"] = ui_vent_data()
	.["name"] = name

/obj/machinery/atmospherics/component/unary/vent_pump/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/target = params["target"]
	switch(action)
		if("toggle")
			set_on(!on)
			return TRUE
		if("intPressure")
			internal_pressure_bound = target == "default"? internal_pressure_bound_default : clamp(text2num(target), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)
			return TRUE
		if("extPressure")
			external_pressure_bound = target == "default"? external_pressure_bound_default : clamp(text2num(target), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)
			return TRUE
		if("intCheck")
			pressure_checks ^= ATMOS_VENT_CHECK_INTERNAL
			return TRUE
		if("extCheck")
			pressure_checks ^= ATMOS_VENT_CHECK_EXTERNAL
			return TRUE
		if("siphon")
			//! warning: legacy
			pump_direction = !pump_direction
			update_icon()
			return TRUE

//* Signal Handling - Check / Application order is in order of these comments.
/// environmental: void. set to ignore the signal if we're not an environmental vent.
/// hard_reset: resets everything to default.
/// power: 0 | 1. sets us to be on/off. overrides power_toggle.
/// power_toggle: void. toggles us on/off.
/// checks: bitfield | "default". sets our checks to that. overrides checks_toggle.
/// checks_toggle: bitfield. toggles those checks.
/// direction: enum | "default". sets direction to that
/// direction_toggle: void. toggles direction.
/// set_internal_pressure: number | "default". sets internal pressure. overrides adjust_internal_pressure.
/// adjust_internal_pressure: number. adjusts internal pressure.
/// set_external_pressure: number | "default". sets external pressure. overrides adjust_external_pressure.
/// adjust_external_pressure: number. adjusts external pressure.

/obj/machinery/atmospherics/component/unary/vent_pump/receive_signal(datum/signal/signal)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	hibernate = 0

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(!isnull(signal.data["environmental"]) && environmental)
		return FALSE

	if(!isnull(signal.data["hard_reset"]))
		pressure_checks = pressure_checks_default
		pump_direction = pump_direction_default
		internal_pressure_bound = internal_pressure_bound_default
		external_pressure_bound = external_pressure_bound_default
	if(!isnull(signal.data["power"]))
		set_on(!!text2num(signal.data["power"]))
	else if(!isnull(signal.data["power_toggle"]))
		set_on(!on)
	if(!isnull(signal.data["checks"]))
		pressure_checks = (signal.data["checks"] == "default")? pressure_checks_default : (text2num(signal.data) & ATMOS_VENT_CHECKS)
	else if(!isnull(signal.data["checks_toggle"]))
		pressure_checks ^= (text2num(signal.data["checks_toggle"]) & ATMOS_VENT_CHECKS)
	if(!isnull(signal.data["direction"]))
		pump_direction = signal.data["direction"] == "default"? pump_direction_default : clamp(text2num(signal.data["direction"]), 0, 1)
	else if(!isnull(signal.data["direction_toggle"]))
		pump_direction = !pump_direction
	if(!isnull(signal.data["set_internal_pressure"]))
		internal_pressure_bound = signal.data["set_internal_presure"] == "default"? internal_pressure_bound_default : clamp(text2num(signal.data["set_internal_pressure"]), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)
	else if(!isnull(signal.data["adjust_internal_pressure"]))
		internal_pressure_bound = clamp(internal_pressure_bound + text2num(signal.data["set_internal_pressure"]), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)
	if(!isnull(signal.data["set_external_pressure"]))
		external_pressure_bound = signal.data["set_external_presure"] == "default"? external_pressure_bound_default : clamp(text2num(signal.data["set_external_pressure"]), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)
	else if(!isnull(signal.data["adjust_external_pressure"]))
		external_pressure_bound = clamp(external_pressure_bound + text2num(signal.data["set_external_pressure"]), 0, ATMOS_VENT_MAX_PRESSURE_LIMIT)

	//! legacy below
	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

		//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()

//* Subtypes

/obj/machinery/atmospherics/component/unary/vent_pump/on
	on = TRUE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/component/unary/vent_pump/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_pump/aux
	icon_state = "map_vent_aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX //connects to aux pipes

/obj/machinery/atmospherics/component/unary/vent_pump/siphon
	pump_direction = 0

/obj/machinery/atmospherics/component/unary/vent_pump/siphon/on
	on = TRUE
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/component/unary/vent_pump/positive // For some reason was buried in tether_things.dm -Bloop
	on = TRUE
	icon_state = "map_vent_out"
	external_pressure_bound = ONE_ATMOSPHERE * 1.1

/obj/machinery/atmospherics/component/unary/vent_pump/siphon/on/atmos
	on = TRUE
	icon_state = "map_vent_in"
	external_pressure_bound = 0
	external_pressure_bound_default = 0
	internal_pressure_bound = 2000
	internal_pressure_bound_default = 2000
	pressure_checks = 2
	pressure_checks_default = 2

/obj/machinery/atmospherics/component/unary/vent_pump/high_volume
	name = "Large Air Vent"
	power_channel = POWER_CHANNEL_EQUIP
	power_rating = 45000

/obj/machinery/atmospherics/component/unary/vent_pump/high_volume/aux
	icon_state = "map_vent_aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX //connects to aux pipes

/obj/machinery/atmospherics/component/unary/vent_pump/high_volume/Initialize(mapload)
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

// Wall mounted vents
/obj/machinery/atmospherics/component/unary/vent_pump/high_volume/wall_mounted
	name = "Wall Mounted Air Vent"

// Return the air from the turf in "front" of us (opposite the way the pipe is facing)
/obj/machinery/atmospherics/component/unary/vent_pump/high_volume/wall_mounted/return_air()
	var/turf/T = get_step(src, global.reverse_dir[dir])
	if(isnull(T))
		return ..()
	return T.return_air()

/obj/machinery/atmospherics/component/unary/vent_pump/engine
	name = "Engine Core Vent"
	power_channel = POWER_CHANNEL_ENVIR
	power_rating = 30000	//15 kW ~ 20 HP

/obj/machinery/atmospherics/component/unary/vent_pump/engine/Initialize(mapload)
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500 //meant to match air injector

/obj/machinery/atmospherics/component/unary/vent_pump/retro
	icon_state = "map_vent"

/obj/machinery/atmospherics/component/unary/vent_pump/retro/on
	on = TRUE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/component/unary/vent_pump/retro/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_pump/retro/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	cut_overlays()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(welded)
		vent_icon += "retro_weld"
	else if(!use_power || !node || (machine_stat & (NOPOWER|BROKEN)))
		vent_icon += "retro_off"
	else
		vent_icon += "[pump_direction ? "retro_out" : "retro_in"]"

	add_overlay(icon_manager.get_atmos_icon("device", , , vent_icon))

#undef DEFAULT_PRESSURE_DELTA
