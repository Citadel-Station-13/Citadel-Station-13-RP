
/obj/effect/debris/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	random_icon_states = list("mucus")

	var/list/datum/disease2/disease/virus2 = list()

//This version should be used for admin spawns and pre-mapped virus vectors (e.g. in PoIs), this version does not dry
/obj/effect/debris/cleanable/mucus/mapped/Initialize(mapload)
	. = ..()
	virus2 |= new /datum/disease2/disease
	virus2[1].makerandom()
