//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* helpers / API for the resleeving module *//

/mob/living/carbon/human/resleeving_supports_mirrors()
	return TRUE

/mob/living/carbon/human/resleeving_create_mirror()
	if((. = resleeving_get_mirror()))
		return
	var/obj/item/organ/internal/mirror/mirror = new
	if(!resleeving_insert_mirror(mirror))
		qdel(mirror)
		return null
	return mirror

/mob/living/carbon/human/resleeving_get_mirror()
	return locate(/obj/item/organ/internal/mirror) in internal_organs

/mob/living/carbon/human/resleeving_insert_mirror(obj/item/organ/internal/mirror/mirror)
	mirror.replaced(src, get_organ(BP_TORSO))
	return mirror in internal_organs

/mob/living/carbon/human/resleeving_remove_mirror(atom/new_loc)
	var/obj/item/organ/internal/mirror/located = locate() in internal_organs
	if(!located)
		return
	located.removed()
	if(new_loc)
		located.forceMove(new_loc)
	else
		located.moveToNullspace()
	return located
