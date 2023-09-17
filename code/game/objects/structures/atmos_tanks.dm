/obj/structure/atmos_tank_segment
	name = "gas tank segment"
	desc = "A section of an enormous reinforced plasteel gas storage tank. Do not puncture."
	opacity = FALSE
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/atmos_tanks/5x5/tank_5x5_preview.dmi'
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	color = COLOR_ACID_CYAN
	layer = ABOVE_MOB_LAYER + 0.1 //to be over gas over lays
	plane = MOB_PLANE
	var/two_tone //hex code


/obj/structure/atmos_tank_segment/Initialize(mapload)
	. = ..()
	var/liketype_edges = 0
	for(var/D in GLOB.cardinal)
		var/turf/T = get_step(src, D)
		for(var/C in T.contents)
			if(istype(C, src.type))
				liketype_edges++
	if(liketype_edges != 4) //checking cardinal dirs only
		CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	else
		CanAtmosPass = ATMOS_PASS_PROC
	update_icon()

/obj/structure/atmos_tank_segment/CanAtmosPass(turf/T, d)
	if(d == UP)
		return ATMOS_PASS_AIR_BLOCKED
	return ATMOS_PASS_NOT_BLOCKED

/obj/structure/atmos_tank_segment/update_icon(updates)
	icon = null
	cut_overlays()
	var/image/glass_overlay = image('icons/obj/atmos_tanks/5x5/tank_5x5_glass.dmi', icon_state)
	glass_overlay.appearance_flags = RESET_COLOR
	var/image/color_overlay = image('icons/obj/atmos_tanks/5x5/tank_5x5_color.dmi',icon_state)
	color_overlay.color = color
	color = null
	var/image/structure_overlay = image('icons/obj/atmos_tanks/5x5/tank_5x5_supports.dmi',icon_state)
	structure_overlay.appearance_flags = RESET_COLOR
	var/image/color_two_overlay = image('icons/obj/atmos_tanks/5x5/tank_5x5_color2.dmi',icon_state)
	if(two_tone)
		color_two_overlay.color = two_tone
	else
		color_two_overlay.color = color_overlay.color
	add_overlay(glass_overlay)
	add_overlay(color_overlay)
	add_overlay(color_two_overlay)
	add_overlay(structure_overlay)

/obj/structure/atmos_tank_segment/o2
	color = COLOR_CYAN_BLUE

/obj/structure/atmos_tank_segment/n2
	color = COLOR_RED

/obj/structure/atmos_tank_segment/phoron
	color = COLOR_PURPLE

/obj/structure/atmos_tank_segment/co2
	color = COLOR_GRAY40

/obj/structure/atmos_tank_segment/n2o2
	color = COLOR_RED_LIGHT
	two_tone = COLOR_WHITE

/obj/structure/atmos_tank_segment/misc
	color = COLOR_YELLOW

/obj/structure/atmos_tank_segment/air
	color = COLOR_WHITE



