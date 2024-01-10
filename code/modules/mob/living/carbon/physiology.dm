//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/living/carbon/add_physiology_modifier(datum/physiology_modifier/modifier)
	. = ..()
	if(!.)
		return
	for(var/obj/item/organ/external/bodypart in organs)
		// todo: check biology
		bodypart.physiology.apply(modifier)

/mob/living/carbon/remove_physiology_modifier(datum/physiology_modifier/modifier)
	. = ..()
	if(!.)
		return
	for(var/obj/item/organ/external/bodypart in organs)
		// todo: check biology
		if(!bodypart.physiology.revert(modifier))
			// todo: optimize?
			bodypart.rebuild_physiology()
			for(var/datum/physiology_modifier/rebuilding as anything in physiology_modifiers)
				// todo: check biology
				bodypart.physiology.apply(rebuilding)

/mob/living/carbon/rebuild_physiology()
	. = ..()
	// at this point, physiology_modifier is a list of datums.
	for(var/obj/item/organ/external/bodypart in organs)
		bodypart.rebuild_physiology()
		for(var/datum/physiology_modifier/modifier as anything in physiology_modifiers)
			// todo: check biology
			bodypart.physiology.apply(modifier)
