/obj/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE | PASSGRILLE | PASSBLOB
	var/list/touched

/obj/effect/water/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 15 SECONDS)

/obj/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	touched = list()
	QDEL_IN(src, 10)
	for(var/i = 1 to step_count)
		if(!loc)
			return
		step_towards(src, target)
		var/turf/T = get_turf(src)
		if(T && reagents)
			if(!(T in touched))
				touched |= T
				reagents.touch_turf(T)
			for(var/atom/movable/AM in T)
				if(!isobj(AM) && !ismob(AM))
					continue
				if(AM in touched)
					continue
				touched |= AM
				reagents.touch(AM, reagents.total_volume)
		sleep(delay)

/obj/effect/water/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(!isobj(AM) && !ismob(AM))
		return
	if(AM in touched)
		return
	touched |= AM
	reagents?.touch(AM, reagents.total_volume)

//Used by spraybottles.
/obj/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""
