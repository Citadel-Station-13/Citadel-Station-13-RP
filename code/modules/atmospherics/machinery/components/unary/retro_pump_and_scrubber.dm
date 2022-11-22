//// Retro Styles of vents and scrubbers///
///
/// Vents first

/obj/machinery/atmospherics/component/unary/vent_pump/retro
	icon_state = "map_vent"

/obj/machinery/atmospherics/component/unary/vent_pump/retro/on
	use_power = USE_POWER_IDLE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/component/unary/vent_pump/retro/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_pump/retro/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

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

	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)


//////////////////////
/// Scrubbers now ////

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro
	icon_state = "map_scrubber_off"	/// Will get replaced on mapload

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/on
	use_power = USE_POWER_IDLE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/on/welded
	welded = 1

/obj/machinery/atmospherics/component/unary/vent_scrubber/retro/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

	var/scrubber_icon = "scrubber"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(welded)
		scrubber_icon += "retro_weld"
	else if(!powered())
		scrubber_icon += "retro_off"
	else
		scrubber_icon += "[use_power ? "[scrubbing ? "retro_on" : "retro_in"]" : "retro_off"]"

	overlays += icon_manager.get_atmos_icon("device", , , scrubber_icon)
