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
		if(B == src)
			continue
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
		for(var/obj/structure/cable/C in T)
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
			if(!(network_directions & i))
				continue
			if(isnull(last))
				last = i
				continue
			new /obj/structure/cable(loc, capitalize(cable_color), last, i, TRUE)
			last = i

/atom/movable/map_helper/network_builder/power_cable/proc/detect_knot()
	return (locate(/obj/machinery/power)) in src

/atom/movable/map_helper/network_builder/power_cable/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/atom/movable/map_helper/network_builder/power_cable/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

#define WORK_HARDER_NOT_SMARTER							\
	WORK_SMARTER_NOT_HARDER("Red", COLOR_RED)			\
	WORK_SMARTER_NOT_HARDER("White", COLOR_WHITE)		\
	WORK_SMARTER_NOT_HARDER("Silver", COLOR_SILVER)		\
	WORK_SMARTER_NOT_HARDER("Gray", COLOR_GRAY)			\
	WORK_SMARTER_NOT_HARDER("Black", COLOR_BLACK)		\
	WORK_SMARTER_NOT_HARDER("Maroon", COLOR_MAROON)		\
	WORK_SMARTER_NOT_HARDER("Yellow", COLOR_YELLOW)		\
	WORK_SMARTER_NOT_HARDER("Olive", COLOR_OLIVE)		\
	WORK_SMARTER_NOT_HARDER("Lime", COLOR_LIME)			\
	WORK_SMARTER_NOT_HARDER("Green", COLOR_GREEN)		\
	WORK_SMARTER_NOT_HARDER("Cyan", COLOR_CYAN)			\
	WORK_SMARTER_NOT_HARDER("Teal", COLOR_TEAL)			\
	WORK_SMARTER_NOT_HARDER("Blue", COLOR_BLUE)			\
	WORK_SMARTER_NOT_HARDER("Navy", COLOR_NAVY)			\
	WORK_SMARTER_NOT_HARDER("Pink", COLOR_PINK)			\
	WORK_SMARTER_NOT_HARDER("Purple", COLOR_PURPLE)		\
	WORK_SMARTER_NOT_HARDER("Orange", COLOR_ORANGE)		\
	WORK_SMARTER_NOT_HARDER("Beige", COLOR_BEIGE)		\
	WORK_SMARTER_NOT_HARDER("Brown", COLOR_BROWN)

#define WORK_SMARTER_NOT_HARDER(c, v)								\
/atom/movable/map_helper/network_builder/power_cable{				\
	color = v;														\
	cable_color = c;												\
}																	\
/atom/movable/map_helper/network_builder/power_cable/auto{			\
	color = v;														\
	cable_color = c;												\
}																	\
/atom/movable/map_helper/network_builder/power_cable/knot{			\
	color = v;														\
	cable_color = c;												\
}

WORK_HARDER_NOT_SMARTER			// LMAO!

#undef WORK_HARDER_NOT_SMARTER
#undef WORK_SMARTER_NOT_HARDER

#undef NO_KNOT
#undef KNOT_AUTO
#undef KNOT_FORCED
