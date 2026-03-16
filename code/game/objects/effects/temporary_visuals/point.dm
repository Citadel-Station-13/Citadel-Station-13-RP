/obj/effect/temp_visual/point
	name = "pointer"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "arrow"
	plane = POINT_PLANE
	duration = (2.5 SECONDS)

/obj/effect/temp_visual/point/Initialize(mapload, set_invis = 0)
	. = ..()
	var/atom/old_loc = loc
	abstract_move(get_turf(src))
	pixel_x = old_loc.pixel_x
	pixel_y = old_loc.pixel_y
	set_invisibility(set_invis)
