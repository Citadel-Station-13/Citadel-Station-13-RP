/obj/structure/fountain
	name = "fountain"
	desc = "A beautifully constructed fountain."
	icon       = 'icons/obj/structures/fountain.dmi'
	icon_state = "fountain_g"
	density    = TRUE
	anchored   = TRUE
	unacidable = TRUE
	pixel_x    = -16
	w_class = ITEM_SIZE_STRUCTURE
	material = /datum/material/solid/stone/marble

/obj/structure/fountain/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	flags |= OPENCONTAINER //| ATOM_FLAG_CLIMBABLE
	initialize_reagents(ml)

/obj/structure/fountain/initialize_reagents(populate = TRUE)
	create_reagents(500)
	. = ..()

/obj/structure/fountain/populate_reagents()
	reagents.add_reagent(/datum/material/liquid/water, reagents.maximum_volume) //Don't give free water when building one

/obj/structure/fountain/attack_hand(mob/user)
	return
