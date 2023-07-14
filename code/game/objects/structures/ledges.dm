/obj/structure/ledge
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_BUCKLED
	density = TRUE
	climb_allowed = TRUE
	anchored = TRUE
	var/solidledge = 1
	atom_flags = ATOM_BORDER
	layer = STAIRS_LAYER
	icon_state = "ledge"

/obj/structure/ledge_corner
	icon_state = "ledge-corner"
	atom_flags = NONE
	name = "rock ledge"
	desc = "An easily scaleable rocky ledge."
	icon = 'icons/obj/ledges.dmi'
	density = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_BUCKLED
	climb_allowed = TRUE
	anchored = TRUE
	layer = STAIRS_LAYER

/obj/structure/ledge/ledge_nub
	desc = "Part of a rocky ledge."
	icon_state = "ledge-nub"
	density = FALSE
	solidledge = FALSE

/obj/structure/ledge/ledge_stairs
	name = "rock stairs"
	desc = "A colorful set of rocky stairs"
	icon_state = "ledge-stairs"
	density = FALSE
	solidledge = FALSE

/obj/structure/ledge/CanAllowThrough(atom/movable/mover, turf/target)
	if(!solidledge)
		return TRUE
	if(!(get_dir(mover, target) & turn(dir, 180)))
		return TRUE
	return ..()

/obj/structure/ledge/CheckExit(atom/movable/AM, atom/newLoc)
	if(check_standard_flag_pass(AM))
		return TRUE
	if(!solidledge)
		return TRUE
	if(!(get_dir(src, newLoc) & dir))
		return TRUE
	return FALSE

/obj/structure/ledge/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
			return 0
	return 1

#warn AAA
