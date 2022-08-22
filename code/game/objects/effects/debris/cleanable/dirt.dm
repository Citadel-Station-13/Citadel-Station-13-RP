/obj/effect/debris/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	collate = TRUE

/obj/effect/debris/cleanable/Initialize(mapload, alpha)
	src.alpha = clamp(alpha, 0, 255)
	return ..()

/obj/effect/debris/cleanable/Collate()
	var/obj/effect/debris/cleanable/dirt/D = locate() in src
	if(D)
		D.alpha = max(alpha, D.alpha)
		return TRUE

/turf/proc/add_dirt_object(initial_alpha = 150, add_alpha = 10, max_alpha = 255)
	if(turf_flags & TURF_SEMANTICALLY_BOTOMLESS)
		return
	var/obj/effect/debris/cleanable/dirt/D = locate() in src
	if(!D)
		D = new(src, initial_alpha)
	else
		D.alpha = clamp(D.alpha + add_alpha, 0, min(255, max_alpha))

/turf/proc/set_dirt_object(alpha = 150)
	if(turf_flags & TURF_SEMANTICALLY_BOTOMLESS)
		return
	var/obj/effect/debris/cleanable/dirt/D = locate() in src
	if(!D)
		D = new(src, alpha)
	else
		D.alpha = clamp(alpha, 0, 255)

/turf/proc/clear_dirt_object()
	if(turf_flags & TURF_SEMANTICALLY_BOTOMLESS)
		return
	var/obj/effect/debris/cleanable/dirt/D = locate() in src
	if(D)
		qdel(D)


