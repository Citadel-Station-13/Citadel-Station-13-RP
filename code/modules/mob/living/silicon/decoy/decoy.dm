/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	mobility_flags = NONE

/mob/living/silicon/decoy/Initialize(mapload)
	. = ..()
	src.icon = 'icons/mob/AI.dmi'
	src.icon_state = "ai"
	src.anchored = TRUE
