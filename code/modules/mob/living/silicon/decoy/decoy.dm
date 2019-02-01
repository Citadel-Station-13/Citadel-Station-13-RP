/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE
	canmove = FALSE

/mob/living/silicon/decoy/Initialize()
	. = ..()
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
