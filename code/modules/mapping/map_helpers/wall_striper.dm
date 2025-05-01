/obj/map_helper/wall_striper
	name = "stripe of paint"
	// TODO: resprite this and put it in helper icons folder
	icon = 'icons/effects/effects.dmi'
	icon_state = "paintdot"
	late = TRUE

/obj/map_helper/wall_striper/LateInitialize()
	for(var/obj/map_helper/wall_striper/paint in loc)
		if(paint == src)
			continue
		stack_trace("Duplicate paint stripe found at [audit_loc()]")
		qdel(src)
		return

	if(!color)
		stack_trace("/wall_painter helper at [audit_loc()] has no color")
		qdel(src)
		return

	var/did_anything = FALSE

	if(istype(loc, /turf/simulated/wall))
		var/turf/simulated/wall/target_wall = loc
		target_wall.paint_stripe(color)
		did_anything = TRUE
	else
		var/obj/structure/wall_frame/low_wall = locate() in loc
		if(low_wall)
			low_wall.stripe_color = color
			low_wall.update_appearance()
			did_anything = TRUE

	if(!did_anything)
		WARNING("Redundant paint helper found at [audit_loc()]")

	qdel(src)

#define CREATE_PAINT_STRIPE(x, c)	/obj/map_helper/wall_striper/x/color=c

CREATE_PAINT_STRIPE(beastybrown, COLOR_CARGO_BROWN)
CREATE_PAINT_STRIPE(sun, COLOR_SUN)
CREATE_PAINT_STRIPE(red, COLOR_RED)
CREATE_PAINT_STRIPE(silver, COLOR_SILVER)
CREATE_PAINT_STRIPE(black, COLOR_GRAY20)
CREATE_PAINT_STRIPE(green, COLOR_GREEN)
CREATE_PAINT_STRIPE(navy, COLOR_NAVY)
CREATE_PAINT_STRIPE(eggshell, COLOR_EGGSHELL)
CREATE_PAINT_STRIPE(beige, COLOR_BEIGE)
CREATE_PAINT_STRIPE(darkred, COLOR_SECURITY_RED)
CREATE_PAINT_STRIPE(maroon, COLOR_MAROON)
CREATE_PAINT_STRIPE(cyanblue, COLOR_CYAN_BLUE)
CREATE_PAINT_STRIPE(copper, COLOR_COPPER)
CREATE_PAINT_STRIPE(amber, COLOR_AMBER)
CREATE_PAINT_STRIPE(wallgunmetal, COLOR_WALL_GUNMETAL)
CREATE_PAINT_STRIPE(bottlegreen, COLOR_BOTTLE_GREEN)
CREATE_PAINT_STRIPE(palebottlegreen, COLOR_PALE_BTL_GREEN)
CREATE_PAINT_STRIPE(pakistangreen, COLOR_PAKISTAN_GREEN)
CREATE_PAINT_STRIPE(offwhite, COLOR_OFF_WHITE)
CREATE_PAINT_STRIPE(violet, COLOR_EXPLO_VIOLET)
CREATE_PAINT_STRIPE(gunmetal, COLOR_GUNMETAL)
CREATE_PAINT_STRIPE(paleorange, COLOR_PALE_ORANGE)
CREATE_PAINT_STRIPE(commandblue, COLOR_COMMAND_BLUE)
CREATE_PAINT_STRIPE(purple, COLOR_PURPLE)
CREATE_PAINT_STRIPE(purplegray, COLOR_PURPLE_GRAY)
CREATE_PAINT_STRIPE(babyblue, COLOR_BABY_BLUE)
CREATE_PAINT_STRIPE(pipecyan, COLOR_ATMOSPHERICS_CYAN)

#undef CREATE_PAINT_STRIPE
