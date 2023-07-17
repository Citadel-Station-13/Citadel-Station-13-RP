/turf/simulated/floor/outdoors/snow
	name = "snow"
	icon_state = "snow"
	edge_blending_priority = 1
	slowdown = 2
	initial_flooring = /singleton/flooring/snow
	baseturfs = /turf/simulated/floor/outdoors/dirt

	// smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_FLOOR_SNOW)
	canSmoothWith = (SMOOTH_GROUP_FLOOR_SNOW)

	var/crossed_dirs = NONE

/turf/simulated/floor/outdoors/snow/Entered(atom/movable/AM)
	if(AM.hovering || AM.is_incorporeal()) // Flying things shouldn't make footprints.
		return ..()
	if(isliving(AM))
		if(!(crossed_dirs & AM.dir))
			crossed_dirs |= AM.dir
			add_overlay(image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = AM.dir))
	return ..()

/turf/simulated/floor/outdoors/snow/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/shovel))
		to_chat(user, "<span class='notice'>You begin to remove \the [src] with your [W].</span>")
		if(do_after(user, 4 SECONDS * W.tool_speed))
			to_chat(user, "<span class='notice'>\The [src] has been dug up, and now lies in a pile nearby.</span>")
			new /obj/item/stack/material/snow(src)
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		else
			to_chat(user, "<span class='notice'>You decide to not finish removing \the [src].</span>")
	if(istype(W, /obj/item/pickaxe))
		var/grave_type = /obj/structure/closet/grave/snow
		do_after(user, 60)
		to_chat(user, "<span class='warning'>You dig out a hole.</span>")
		new grave_type(get_turf(src))
		return
	else
		..()

/turf/simulated/floor/outdoors/snow/attack_hand(mob/user, list/params, datum/event_args/clickchain/e_args)
	visible_message("[user] starts scooping up some snow.", "You start scooping up some snow.")
	if(do_after(user, 1 SECOND))
		user.put_in_hands_or_drop(new /obj/item/stack/material/snow)
		visible_message("[user] scoops up a pile of snow.", "You scoop up a pile of snow.")
	return

/turf/simulated/floor/outdoors/snow/noblend
	edge_blending_priority = 0

/turf/simulated/floor/outdoors/snow/noblend/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/ice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	edge_blending_priority = 0

/turf/simulated/floor/outdoors/ice/Entered(var/mob/living/M)
	. = ..()
	if(istype(M, /mob/living))
		if(!M.is_stunned())
			to_chat(M, "<span class='warning'>You slide across the ice!</span>")
		M.set_stunned(20 * 1)
		step(M,M.dir)

// Ice that is used for, say, areas floating on water or similar.
/turf/simulated/floor/outdoors/shelfice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	slowdown = 4
	edge_blending_priority = 0

// Ice that is safe to walk on.
/turf/simulated/floor/outdoors/safeice
	name = "ice"
	icon_state = "ice"
	desc = "Seems safe enough to walk on."
	slowdown = 2
	edge_blending_priority = 0

// Snowy gravel
/turf/simulated/floor/outdoors/gravsnow
	name = "snowy gravel"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	edge_blending_priority = 0
	initial_flooring = /singleton/flooring/snow/gravsnow
	baseturfs = /turf/simulated/floor/outdoors/dirt
