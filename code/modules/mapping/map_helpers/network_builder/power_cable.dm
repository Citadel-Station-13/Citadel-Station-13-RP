#define NO_KNOT 0
#define KNOT_AUTO 1
#define KNOT_FORCED 2

/// Automatically links on init to power cables and other cable builder helpers. Only supports cardinals.
/obj/map_helper/network_builder/power_cable
	name = "power line autobuilder"
	icon_state = "powerlinebuilder"
	base_type = /obj/map_helper/network_builder/power_cable
	color = "#ff0000"

	/// Whether or not we forcefully make a knot
	var/knot = NO_KNOT
	/// cable color as from GLOB.cable_colors
	var/cable_color = "red"


/obj/map_helper/network_builder/power_cable/duplicates()
	. = list()
	for(var/obj/map_helper/network_builder/power_cable/B in loc)
		if(B == src)
			continue
		. += B
	for(var/obj/structure/wire/cable/C in loc)
		. += C

/obj/map_helper/network_builder/power_cable/scan()
	. = NONE
	for(var/i in GLOB.cardinal)
		var/turf/T = get_step(src, i)
		if(locate(base_type) in T)
			. |= i
			continue
		var/opp = turn(i, 180)
		for(var/obj/structure/wire/cable/C in T)
			if((C.d1 == opp || C.d2 == opp) && C.color == cable_color)
				. |= i
				continue

/obj/map_helper/network_builder/power_cable/build()
	if(!network_directions)
		return
	var/knot = (src.knot == KNOT_FORCED) || ((src.knot == KNOT_AUTO) && detect_knot())
	if(knot)
		for(var/i in GLOB.cardinal)
			if(!(network_directions & i))
				continue
			new /obj/structure/wire/cable(loc, capitalize(cable_color), 0, i, TRUE)
	else
		var/last
		for(var/i in GLOB.cardinal)
			if(!(network_directions & i))
				continue
			if(isnull(last))
				last = i
				continue
			new /obj/structure/wire/cable(loc, capitalize(cable_color), last, i, TRUE)
			last = i

/obj/map_helper/network_builder/power_cable/proc/detect_knot()
	return (locate(/obj/machinery/power)) in src

/obj/map_helper/network_builder/power_cable/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/map_helper/network_builder/power_cable/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

#define WORK_SMARTER_NOT_HARDER(c, v, p)						\
/obj/map_helper/network_builder/power_cable/##p{				\
	color = v;													\
	cable_color = c;											\
}																\
/obj/map_helper/network_builder/power_cable/##p/auto{			\
	color = v;													\
	cable_color = c;											\
}																\
/obj/map_helper/network_builder/power_cable/##p/knot{			\
	color = v;													\
	cable_color = c;											\
}

#define WORK_HARDER_NOT_SMARTER									\
	WORK_SMARTER_NOT_HARDER("Red", COLOR_RED, red)				\
	WORK_SMARTER_NOT_HARDER("White", COLOR_WHITE, white)		\
	WORK_SMARTER_NOT_HARDER("Silver", COLOR_SILVER, silver)		\
	WORK_SMARTER_NOT_HARDER("Gray", COLOR_GRAY, gray)			\
	WORK_SMARTER_NOT_HARDER("Black", COLOR_BLACK, black)		\
	WORK_SMARTER_NOT_HARDER("Maroon", COLOR_MAROON, maroon)		\
	WORK_SMARTER_NOT_HARDER("Yellow", COLOR_YELLOW, yellow)		\
	WORK_SMARTER_NOT_HARDER("Olive", COLOR_OLIVE, olive)		\
	WORK_SMARTER_NOT_HARDER("Lime", COLOR_LIME, lime)			\
	WORK_SMARTER_NOT_HARDER("Green", COLOR_GREEN, green)		\
	WORK_SMARTER_NOT_HARDER("Cyan", COLOR_CYAN, cyan)			\
	WORK_SMARTER_NOT_HARDER("Teal", COLOR_TEAL, teal)			\
	WORK_SMARTER_NOT_HARDER("Blue", COLOR_BLUE, blue)			\
	WORK_SMARTER_NOT_HARDER("Navy", COLOR_NAVY, navy)			\
	WORK_SMARTER_NOT_HARDER("Pink", COLOR_PINK, pink)			\
	WORK_SMARTER_NOT_HARDER("Purple", COLOR_PURPLE, purple)		\
	WORK_SMARTER_NOT_HARDER("Orange", COLOR_ORANGE, orange)		\
	WORK_SMARTER_NOT_HARDER("Beige", COLOR_BEIGE, beige)		\
	WORK_SMARTER_NOT_HARDER("Brown", COLOR_BROWN, brown)

WORK_HARDER_NOT_SMARTER			// LMAO!

#undef WORK_HARDER_NOT_SMARTER
#undef WORK_SMARTER_NOT_HARDER

#undef NO_KNOT
#undef KNOT_AUTO
#undef KNOT_FORCED
