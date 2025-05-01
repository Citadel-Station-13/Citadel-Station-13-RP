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

#define CREATE_WALL_PAINT(x, c)	/obj/map_helper/paint/x/color=c

CREATE_WALL_PAINT(beastybrown, COLOR_CARGO_BROWN)
CREATE_WALL_PAINT(pipecyan, COLOR_ATMOSPHERICS_CYAN)
CREATE_WALL_PAINT(sun, COLOR_SUN)
CREATE_WALL_PAINT(red, COLOR_RED)
CREATE_WALL_PAINT(silver, COLOR_SILVER)
CREATE_WALL_PAINT(black, COLOR_GRAY20)
CREATE_WALL_PAINT(green, COLOR_GREEN)
CREATE_WALL_PAINT(navy, COLOR_NAVY)
CREATE_WALL_PAINT(eggshell, COLOR_EGGSHELL)
CREATE_WALL_PAINT(beige, COLOR_BEIGE)
CREATE_WALL_PAINT(darkred, COLOR_SECURITY_RED)
CREATE_WALL_PAINT(maroon, COLOR_MAROON)
CREATE_WALL_PAINT(cyanblue, COLOR_CYAN_BLUE)
CREATE_WALL_PAINT(copper, COLOR_COPPER)
CREATE_WALL_PAINT(amber, COLOR_AMBER)
CREATE_WALL_PAINT(wallgunmetal, COLOR_WALL_GUNMETAL)
CREATE_WALL_PAINT(bottlegreen, COLOR_BOTTLE_GREEN)
CREATE_WALL_PAINT(palebottlegreen, COLOR_PALE_BTL_GREEN)
CREATE_WALL_PAINT(pakistangreen, COLOR_PAKISTAN_GREEN)
CREATE_WALL_PAINT(offwhite, COLOR_OFF_WHITE)
CREATE_WALL_PAINT(violet, COLOR_EXPLO_VIOLET)
CREATE_WALL_PAINT(gunmetal, COLOR_GUNMETAL)
CREATE_WALL_PAINT(paleorange, COLOR_PALE_ORANGE)
CREATE_WALL_PAINT(commandblue, COLOR_COMMAND_BLUE)
CREATE_WALL_PAINT(purple, COLOR_PURPLE)
CREATE_WALL_PAINT(purplegray, COLOR_PURPLE_GRAY)
CREATE_WALL_PAINT(babyblue, COLOR_BABY_BLUE)
CREATE_WALL_PAINT(hardwood, WOOD_COLOR_HARDWOOD)

#undef CREATE_WALL_PAINT
