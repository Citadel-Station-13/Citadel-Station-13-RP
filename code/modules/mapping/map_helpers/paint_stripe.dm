/**
 * Used to stripe structural tiles (walls, low-walls, etc) fully as needed.
 */
/obj/map_helper/paint_stripe
	name = "stripe of paint"
	// TODO: resprite this and put it in helper icons folder
	icon = 'icons/effects/effects.dmi'
	icon_state = "paintdot"
	late = TRUE

/obj/map_helper/paint_stripe/LateInitialize()
	for(var/obj/map_helper/paint_stripe/paint in loc)
		if(paint == src)
			continue
		stack_trace("Duplicate paint stripe found at [audit_loc()]")
		qdel(src)
		return

	if(!color)
		stack_trace("/paint helper at [audit_loc()] has no color")
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
		stack_trace("Redundant paint helper found at [audit_loc()]")

	qdel(src)

#define CREATE_PAINT_STRIPE_HELPER(x, c)	/obj/map_helper/paint_stripe/x/color=c

CREATE_PAINT_STRIPE_HELPER(beastybrown, COLOR_CARGO_BROWN)
CREATE_PAINT_STRIPE_HELPER(sun, COLOR_SUN)
CREATE_PAINT_STRIPE_HELPER(red, COLOR_RED)
CREATE_PAINT_STRIPE_HELPER(silver, COLOR_SILVER)
CREATE_PAINT_STRIPE_HELPER(black, COLOR_GRAY20)
CREATE_PAINT_STRIPE_HELPER(green, COLOR_GREEN)
CREATE_PAINT_STRIPE_HELPER(navy, COLOR_NAVY)
CREATE_PAINT_STRIPE_HELPER(eggshell, COLOR_EGGSHELL)
CREATE_PAINT_STRIPE_HELPER(beige, COLOR_BEIGE)
CREATE_PAINT_STRIPE_HELPER(darkred, COLOR_SECURITY_RED)
CREATE_PAINT_STRIPE_HELPER(maroon, COLOR_MAROON)
CREATE_PAINT_STRIPE_HELPER(cyanblue, COLOR_CYAN_BLUE)
CREATE_PAINT_STRIPE_HELPER(copper, COLOR_COPPER)
CREATE_PAINT_STRIPE_HELPER(amber, COLOR_AMBER)
CREATE_PAINT_STRIPE_HELPER(wallgunmetal, COLOR_WALL_GUNMETAL)
CREATE_PAINT_STRIPE_HELPER(bottlegreen, COLOR_BOTTLE_GREEN)
CREATE_PAINT_STRIPE_HELPER(palebottlegreen, COLOR_PALE_BTL_GREEN)
CREATE_PAINT_STRIPE_HELPER(pakistangreen, COLOR_PAKISTAN_GREEN)
CREATE_PAINT_STRIPE_HELPER(offwhite, COLOR_OFF_WHITE)
CREATE_PAINT_STRIPE_HELPER(violet, COLOR_EXPLO_VIOLET)
CREATE_PAINT_STRIPE_HELPER(gunmetal, COLOR_GUNMETAL)
CREATE_PAINT_STRIPE_HELPER(paleorange, COLOR_PALE_ORANGE)
CREATE_PAINT_STRIPE_HELPER(commandblue, COLOR_COMMAND_BLUE)
CREATE_PAINT_STRIPE_HELPER(purple, COLOR_PURPLE)
CREATE_PAINT_STRIPE_HELPER(purplegray, COLOR_PURPLE_GRAY)
CREATE_PAINT_STRIPE_HELPER(babyblue, COLOR_BABY_BLUE)
CREATE_PAINT_STRIPE_HELPER(pipecyan, COLOR_ATMOSPHERICS_CYAN)

#undef CREATE_PAINT_STRIPE_HELPER
