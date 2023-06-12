#define CREATE_PAINT(x, c)	/obj/effect/paint/x/color=c
#define CREATE_PAINT_STRIPE(x, c)	/obj/effect/paint_stripe/x/color=c

/obj/effect/paint
	name = "coat of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wall_paint_effect"
	layer = ABOVE_TURF_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.paint_color = color
		W.stripe_color = color
		W.update_overlays()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.paint_color = color
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

//Stripes the wall it spawns on, then dies
/obj/effect/paint_stripe
	name = "stripe of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "paintdot"
	layer = ABOVE_TURF_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint_stripe/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint_stripe/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.stripe_color = color
		W.update_overlays()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

//paint defines

CREATE_PAINT(sun, COLOR_SUN)
CREATE_PAINT(red, COLOR_RED)
CREATE_PAINT(silver, COLOR_SILVER)
CREATE_PAINT(black, COLOR_GRAY20)
CREATE_PAINT(green, COLOR_GREEN)
CREATE_PAINT(navy, COLOR_NAVY)
CREATE_PAINT(eggshell, COLOR_EGGSHELL)
CREATE_PAINT(beige, COLOR_BEIGE)
CREATE_PAINT(darkred, COLOR_MAROON)
CREATE_PAINT(cyanblue, COLOR_CYAN_BLUE)
CREATE_PAINT(copper, COLOR_COPPER)
CREATE_PAINT(amber, COLOR_AMBER)
CREATE_PAINT(wallgunmetal, COLOR_WALL_GUNMETAL)
CREATE_PAINT(bottlegreen, COLOR_BOTTLE_GREEN)
CREATE_PAINT(palebottlegreen, COLOR_PALE_BTL_GREEN)
CREATE_PAINT(pakistangreen, COLOR_PAKISTAN_GREEN)
CREATE_PAINT(offwhite, COLOR_OFF_WHITE)
CREATE_PAINT(violet, COLOR_EXPLO_VIOLET)
CREATE_PAINT(gunmetal, COLOR_GUNMETAL)
CREATE_PAINT(paleorange, COLOR_PALE_ORANGE)
CREATE_PAINT(commandblue, COLOR_COMMAND_BLUE)
CREATE_PAINT(purple, COLOR_PURPLE)
CREATE_PAINT(purplegray, COLOR_PURPLE_GRAY)
CREATE_PAINT(babyblue, COLOR_BABY_BLUE)

CREATE_PAINT_STRIPE(sun, COLOR_SUN)
CREATE_PAINT_STRIPE(red, COLOR_RED)
CREATE_PAINT_STRIPE(silver, COLOR_SILVER)
CREATE_PAINT_STRIPE(black, COLOR_GRAY20)
CREATE_PAINT_STRIPE(green, COLOR_GREEN)
CREATE_PAINT_STRIPE(navy, COLOR_NAVY)
CREATE_PAINT_STRIPE(eggshell, COLOR_EGGSHELL)
CREATE_PAINT_STRIPE(beige, COLOR_BEIGE)
CREATE_PAINT_STRIPE(darkred, COLOR_MAROON)
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
