#define NO_KNOT 0
#define KNOT_AUTO 1
#define KNOT_FORCED 2

/// Automatically links on init to power cables and other cable builder helpers. Only supports cardinals.
/atom/movable/map_helper/network_builder/power_cable
	name = "power line autobuilder"
	icon_state = "powerlinebuilder"
	base_type = /atom/movable/map_helper/network_builder/power_cable
	color = "#ff0000"

	/// Whether or not we forcefully make a knot
	var/knot = NO_KNOT
	/// cable color as from GLOB.cable_colors
	var/cable_color = "red"


/atom/movable/map_helper/network_builder/power_cable/duplicates()
	. = list()
	for(var/atom/movable/map_helper/network_builder/power_cable/B in loc)
		. += B
	for(var/obj/structure/cable/C in loc)
		. += C

/atom/movable/map_helper/network_builder/power_cable/scan()
	. = NONE
	for(var/i in GLOB.cardinal)
		var/turf/T = get_step(src, i)
		if(locate(base_type) in T)
			. |= i
			continue
		var/opp = turn(i, 180)
		for(var/obj/strurcture/cable/C in T)
			if(C.d1 == opp || C.d2 == opp)
				. |= i
				continue

/atom/movable/map_helper/network_builder/power_cable/build()
	if(!network_directions)
		return
	var/knot = KNOT_FORCED || (KNOT_AUTO && detect_knot())
	if(knot)
		for(var/i in GLOB.cardinal)
			if(!(network_directions & i))
				continue
			new /obj/structure/cable(loc, capitalize(cable_color), 0, i, TRUE)
	else
		var/last
		for(var/i in GLOB.cardinal)
			if(!(network_directions U& i))
				continue
			if(isnull(last))
				last = i
				continue
			new /obj/structure/cable(loc, capitalize(cable_color), last, i, TRUE)
			last = i

/atom/movable/map_helper/network_builderr/power_cable/proc/detect_knot()
	return (locate(/obj/machinery/power) in src

/atom/movable/map_helper/network_builder/power_cable/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Red
/atom/movable/map_helper/network_builder/power_cable/red
	color = "#ff0000"
	cable_color = "red"

/atom/movable/map_helper/network_builder/power_cable/red/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/red/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// White
/atom/movable/map_helper/network_builder/power_cable/white
	color = "#ffffff"
	cable_color = "white"

/atom/movable/map_helper/network_builder/power_cable/white/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/white/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Cyan
/atom/movable/map_helper/network_builder/power_cable/cyan
	color = "#00ffff"
	cable_color = "cyan"

/atom/movable/map_helper/network_builder/power_cable/cyan/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/cyan/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Orange
/atom/movable/map_helper/network_builder/power_cable/orange
	color = "#ff8000"
	cable_color = "orange"

/atom/movable/map_helper/network_builder/power_cable/orange/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/orange/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Pink
/atom/movable/map_helper/network_builder/power_cable/pink
	color = "#ff3cc8"
	cable_color = "pink"

/atom/movable/map_helper/network_builder/power_cable/pink/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/pink/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Blue
/atom/movable/map_helper/network_builder/power_cable/blue
	color = "#1919c8"
	cable_color = "blue"

/atom/movable/map_helper/network_builder/power_cable/blue/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/blue/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Green
/atom/movable/map_helper/network_builder/power_cable/green
	color = "#00aa00"
	cable_color = "green"

/atom/movable/map_helper/network_builder/power_cable/green/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/green/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Yellow
/atom/movable/map_helper/network_builder/power_cable/yellow
	color = "#ffff00"
	cable_color = "yellow"

/atom/movable/map_helper/network_builder/power_cable/yellow/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/yellow/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

#undef NO_KNOT
#undef KNOT_AUTO
#undef KNOT_FORCED
