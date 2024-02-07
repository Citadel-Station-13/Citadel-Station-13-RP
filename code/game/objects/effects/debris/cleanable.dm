/obj/effect/debris/cleanable
	layer = DEBRIS_LAYER
	var/list/random_icon_states

/obj/effect/debris/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/debris/cleanable/Initialize(mapload)
	if(random_icon_states)
		random_icon_states = typelist(NAMEOF(src, random_icon_states), random_icon_states)
		if(random_icon_states.len)
			icon_state = pick(random_icon_states)
	return ..()
