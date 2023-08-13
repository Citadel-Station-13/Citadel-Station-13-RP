/// Automatically links on init to power cables and other cable builder helpers. Only supports cardinals.
/obj/map_helper/network_builder/atmos_pipe
	name = "atmos pipe autobuilder"
	icon_state = "atmospipebuilder"
	base_type = /obj/map_helper/network_builder/atmos_pipe
	color = "#ff0000"

	/// cable color as from GLOB.cable_colors
	// var/hidden = TRUE
	var/list/pipe_color = (PIPE_COLOR_BLUE)
	var/cable_color = "red"

/obj/map_helper/network_builder/atmos_pipe/duplicates()
	. = list()
	for(var/obj/map_helper/network_builder/atmos_pipe/B in loc)
		if(B == src)
			continue
		. += B
	for(var/obj/structure/cable/C in loc)
		. += C

/obj/map_helper/network_builder/atmos_pipe/scan()
	. = NONE
	for(var/i in GLOB.cardinal)
		var/turf/T = get_step(src, i)
		if(locate(base_type) in T)
			. |= i
			continue
		var/opp = turn(i, 180)
		for(var/obj/machinery/atmospherics/pipe/simple/P in T)
			if((P.initialize_directions == opp) && P.color == pipe_color)
				. |= i
				continue

/obj/map_helper/network_builder/atmos_pipe/build()
	if(!network_directions)
		return
		/*
	var/knot = (src.knot == KNOT_FORCED) || ((src.knot == KNOT_AUTO) && detect_knot())
	if(knot)
		for(var/i in GLOB.cardinal)
			if(!(network_directions & i))
				continue
			new /obj/structure/cable(loc, capitalize(cable_color), 0, i, TRUE)
			*/
	else
		var/last
		for(var/i in GLOB.cardinal)
			if(!(network_directions & i))
				continue
			if(isnull(last))
				last = i
				continue
			new /obj/structure/cable(loc, capitalize(cable_color), last, i, TRUE)
			last = i
