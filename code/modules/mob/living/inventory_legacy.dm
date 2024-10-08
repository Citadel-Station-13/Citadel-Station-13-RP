/mob/living/abiotic(full_body)
	if(full_body)
		if(item_considered_abiotic(wear_mask))
			return TRUE
		if(item_considered_abiotic(back))
			return TRUE

	for(var/obj/item/I as anything in get_held_items())
		if(item_considered_abiotic(I))
			return TRUE

	return FALSE
