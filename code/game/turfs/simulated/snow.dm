/turf/simulated/snow
	gender = PLURAL
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	desc = "Looks cold."
	icon_state = "snow"
	edge_blending_priority = 6
	movement_cost = 2
	baseturfs = /turf/simulated/dirt
	var/list/crossed_dirs = list()

	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/simulated/snow/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/diggable, /obj/item/stack/material/snow, 2, "dig up")

/turf/simulated/snow/break_tile()
	. = ..()
	icon_state = "snow_dug"

/turf/simulated/snow/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		var/mdir = "[A.dir]"
		crossed_dirs[mdir] = 1
		update_icon()
	..()

/turf/simulated/snow/update_icon()
	..()
	for(var/d in crossed_dirs)
		add_overlay(image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = text2num(d)))

/turf/simulated/snow/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/shovel))
		to_chat(user, SPAN_NOTICE("You begin to remove \the [src] with your [W]."))
		if(do_after(user, 4 SECONDS * W.toolspeed))
			to_chat(user, SPAN_NOTICE("\The [src] has been dug up, and now lies in a pile nearby."))
			new /obj/item/stack/material/snow(src)
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		else
			to_chat(user, SPAN_NOTICE("You decide to not finish removing \the [src]."))
	else
		..()

/turf/simulated/snow/attack_hand(mob/user as mob)
	visible_message("[user] starts scooping up some snow.", "You start scooping up some snow.")
	if(do_after(user, 1 SECOND))
		var/obj/S = new /obj/item/stack/material/snow(user.loc)
		user.put_in_hands(S)
		visible_message("[user] scoops up a pile of snow.", "You scoop up a pile of snow.")
	return

/turf/simulated/ice
	name = "ice sheet"
	desc = "A sheet of solid ice. Looks slippery."
	icon = 'icons/turf/floors/ice_turf.dmi'
	icon_state = "ice_turf-0"
	base_icon_state = "ice_turf-0"
	baseturfs = /turf/simulated/ice
	movement_cost = 1
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/simulated/ice/break_tile()
	return
/turf/simulated/ice/burn_tile()
	return

/turf/simulated/ice/Entered(mob/living/M)
	. = ..()
	if(istype(M, /mob/living))
		if(M.stunned == 0)
			to_chat(M, SPAN_WARNING("You slide across the ice!"))
		M.SetStunned(1)
		step(M,M.dir)

/turf/simulated/ice/smooth
	icon_state = "ice_turf-255"
	base_icon_state = "ice_turf"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_ICE)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_ICE)

// Ice that is used for, say, areas floating on water or similar.
/turf/simulated/outdoors/shelfice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	movement_cost = 4

// Ice that is safe to walk on.
/turf/simulated/outdoors/safeice
	name = "ice"
	icon_state = "ice"
	desc = "Seems safe enough to walk on."
	movement_cost = 2
