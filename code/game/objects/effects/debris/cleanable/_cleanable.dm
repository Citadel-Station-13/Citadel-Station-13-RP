/obj/effect/debris/cleanable
	layer = DEBRIS_LAYER
	var/list/random_icon_states = list()

/obj/effect/debris/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/debris/cleanable/Initialize(mapload)
	. = ..()
	if (random_icon_states && length(src.random_icon_states) > 0)
		icon_state = pick(src.random_icon_states)
