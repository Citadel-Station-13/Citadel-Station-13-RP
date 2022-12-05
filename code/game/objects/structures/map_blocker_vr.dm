// For mappers to make invisible borders. For best results, place at least 8 tiles away from map edge.

/obj/effect/blocker
	desc = "You can't go there!"
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "debug"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	unacidable = TRUE

/obj/effect/blocker/Initialize(mapload) // For non-gateway maps.
	. = ..()
	icon = null
	icon_state = null
