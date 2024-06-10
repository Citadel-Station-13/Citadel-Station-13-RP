// For mappers to make invisible borders. For best results, place at least 8 tiles away from map edge.
// TODO: Nuke this. @Zandario
/obj/effect/blocker
	desc = "You can't go there!"
	icon = 'icons/turf/walls/reinforced_debug.dmi'
	icon_state = "reinforced"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_INDESTRUCTIBLE | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	atom_flags = ATOM_ABSTRACT
	zmm_flags = ZMM_IGNORE

/obj/effect/blocker/Initialize(mapload) // For non-gateway maps.
	. = ..()
	icon = null
	icon_state = null
