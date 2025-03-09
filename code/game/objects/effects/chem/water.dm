/obj/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GRILLE | ATOM_PASS_BLOB

	var/list/reagents_reapplication_injection

/obj/effect/water/Initialize(mapload)
	. = ..()
	reagents_reapplication_injection = list()
	QDEL_IN(src, 15 SECONDS)

/obj/effect/water/Destroy()
	reagents_reapplication_injection = null
	return ..()

/obj/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	QDEL_IN(src, step_count * delay + 10)
	for(var/i = 1 to step_count)
		if(!loc)
			return
		step_towards(src, target)
		reagents?.perform_uniform_contact(get_turf(src), 1, null, reagents_reapplication_injection)
		sleep(delay)

/obj/effect/water/Crossed(atom/movable/AM, oldloc)
	..()
	reagents?.perform_uniform_contact(AM, 1, null, reagents_reapplication_injection)

//Used by spraybottles.
/obj/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/medical/chempuff.dmi'
	icon_state = ""
	layer = FLY_LAYER
