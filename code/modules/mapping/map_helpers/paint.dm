/**
 * Used to repaint structural tiles (walls, low-walls, etc) fully as needed.
 */
/obj/map_helper/paint
	name = "coat of paint"
	// TODO: resprite this and put it in helper icons folder
	icon = 'icons/effects/effects.dmi'
	icon_state = "wall_paint_effect"
	late = TRUE

/obj/map_helper/paint/LateInitialize()
	for(var/obj/map_helper/paint/paint in loc)
		if(paint == src)
			continue
		stack_trace("Duplicate paint found at [audit_loc()]")
		qdel(src)
		return

	if(!color)
		stack_trace("/paint helper at [audit_loc()] has no color")
		qdel(src)
		return

	var/did_anything = FALSE

	if(istype(loc, /turf/simulated/wall))
		var/turf/simulated/wall/target_wall = loc
		target_wall.paint_wall(color)
		did_anything = TRUE
	else
		var/obj/structure/wall_frame/low_wall = locate() in loc
		if(low_wall)
			low_wall.stripe_color = color
			low_wall.update_appearance()
			did_anything = TRUE

	if(!did_anything)
		stack_trace("Redundant paint helper found at [audit_loc()]")

	qdel(src)

#define CREATE_PAINT_HELPER(x, c)	/obj/map_helper/paint/x/color=c

CREATE_PAINT_HELPER(beastybrown, COLOR_CARGO_BROWN)
CREATE_PAINT_HELPER(pipecyan, COLOR_ATMOSPHERICS_CYAN)
CREATE_PAINT_HELPER(sun, COLOR_SUN)
CREATE_PAINT_HELPER(red, COLOR_RED)
CREATE_PAINT_HELPER(silver, COLOR_SILVER)
CREATE_PAINT_HELPER(black, COLOR_GRAY20)
CREATE_PAINT_HELPER(green, COLOR_GREEN)
CREATE_PAINT_HELPER(navy, COLOR_NAVY)
CREATE_PAINT_HELPER(eggshell, COLOR_EGGSHELL)
CREATE_PAINT_HELPER(beige, COLOR_BEIGE)
CREATE_PAINT_HELPER(darkred, COLOR_SECURITY_RED)
CREATE_PAINT_HELPER(maroon, COLOR_MAROON)
CREATE_PAINT_HELPER(cyanblue, COLOR_CYAN_BLUE)
CREATE_PAINT_HELPER(copper, COLOR_COPPER)
CREATE_PAINT_HELPER(amber, COLOR_AMBER)
CREATE_PAINT_HELPER(wallgunmetal, COLOR_WALL_GUNMETAL)
CREATE_PAINT_HELPER(bottlegreen, COLOR_BOTTLE_GREEN)
CREATE_PAINT_HELPER(palebottlegreen, COLOR_PALE_BTL_GREEN)
CREATE_PAINT_HELPER(pakistangreen, COLOR_PAKISTAN_GREEN)
CREATE_PAINT_HELPER(offwhite, COLOR_OFF_WHITE)
CREATE_PAINT_HELPER(violet, COLOR_EXPLO_VIOLET)
CREATE_PAINT_HELPER(gunmetal, COLOR_GUNMETAL)
CREATE_PAINT_HELPER(paleorange, COLOR_PALE_ORANGE)
CREATE_PAINT_HELPER(commandblue, COLOR_COMMAND_BLUE)
CREATE_PAINT_HELPER(purple, COLOR_PURPLE)
CREATE_PAINT_HELPER(purplegray, COLOR_PURPLE_GRAY)
CREATE_PAINT_HELPER(babyblue, COLOR_BABY_BLUE)
CREATE_PAINT_HELPER(hardwood, WOOD_COLOR_HARDWOOD)

#undef CREATE_PAINT_HELPER
