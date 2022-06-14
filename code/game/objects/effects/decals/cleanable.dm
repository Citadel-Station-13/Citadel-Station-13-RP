/obj/effect/decal/cleanable
	plane = DIRTY_PLANE
	var/list/random_icon_states = list()

/obj/effect/decal/cleanable/clean_blood(ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/Initialize(mapload)
	. = ..()
	if (random_icon_states && length(src.random_icon_states) > 0)
		icon_state = pick(src.random_icon_states)

/obj/effect/decal/cleanable/water_act(depth)
	..()
	qdel(src)
