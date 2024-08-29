//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//* Misc Effects *//

/mob/living/carbon/human/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	var/list/equipment = list(src.w_uniform,src.wear_suit,src.shoes)
	var/footcoverage_check = FALSE
	for(var/obj/item/clothing/C in equipment)
		if(C.body_cover_flags & FEET)
			footcoverage_check = TRUE
			break
	if((species.species_flags & NO_SLIP && !footcoverage_check) || (shoes && (shoes.clothing_flags & NOSLIP))) //Footwear negates a species' natural traction.
		return 0
	return ..()
