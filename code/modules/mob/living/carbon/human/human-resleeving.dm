//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* helpers / API for the resleeving module *//

/mob/living/carbon/human/resleeving_supports_mirrors()
	return TRUE

#warn put in chest

/mob/living/carbon/human/resleeving_create_mirror()
	#warn impl
	// var/obj/item/organ/internal/mirror/new_imp = new()
	// if(new_imp.handle_implant(occupant, BP_TORSO))
	// 	new_imp.post_implant(occupant)
		// if((client.prefs.organ_data[O_BRAIN] != null))
		// 	var/obj/item/organ/internal/mirror/positronic/F = new /obj/item/organ/internal/mirror/positronic(new_character)
		// 	F.handle_implant(new_character)
		// 	F.post_implant(new_character)
		// else
		// 	var/obj/item/organ/internal/mirror/E = new /obj/item/organ/internal/mirror(new_character)
		// 	E.handle_implant(new_character)
		// 	E.post_implant(new_character)

/mob/living/carbon/human/resleeving_get_mirror()
	return locate(/obj/item/organ/internal/mirror) in internal_organs

/mob/living/carbon/human/resleeving_insert_mirror(obj/item/organ/internal/mirror/mirror)
	#warn impl

/mob/living/carbon/human/resleeving_remove_mirror(atom/new_loc)
	var/obj/item/organ/internal/mirror/located = locate() in internal_organs
	if(!located)
		return
	if(new_loc)
		located.forceMove(new_loc)
	else
		located.moveToNullspace()
	return located
