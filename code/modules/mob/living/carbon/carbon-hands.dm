//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Hands - Abstraction *//

/mob/living/carbon/get_usable_hand_count()
	// todo: slow as shit
	return length(get_usable_hand_indices())

/mob/living/carbon/get_usable_hand_indices()
	// todo: slow as shit
	. = list()
	for(var/i in 1 to get_nominal_hand_count())
		if(get_hand_manipulation_level(i) > HAND_MANIPULATION_NONE)
			. += i

//* Hands - Checks *//

/mob/living/carbon/get_hand_manipulation_level(index)
	// todo: implement after organ refactors
	return HAND_MANIPULATION_PRECISE

/mob/living/carbon/why_hand_manipulation_insufficient(index, manipulation)
	// todo: implement after organ refactors
	return list()

//* Hands - Organs *//

/**
 * Get the hand index of an organ
 *
 * * If an organ is responsible for more than one index, this only returns one of them.
 *
 * @return numerical index or null
 */
/mob/living/carbon/proc/get_hand_of_organ(obj/item/organ/external/organ)
	switch(organ.organ_tag)
		if(BP_L_HAND)
			return 1
		if(BP_R_HAND)
			return 2
		else
			return null

/**
 * Get all hand indexes of an organ
 *
 * @return list of numerical indices
 */
/mob/living/carbon/proc/get_hands_of_organ(obj/item/organ/external/organ) as /list
	switch(organ.organ_tag)
		if(BP_L_HAND)
			return list(1)
		if(BP_R_HAND)
			return list(2)
	return list()

/**
 * Get the external organ of a hand index
 *
 * @params
 * * index - the hand index
 *
 * @return external organ or null
 */
/mob/living/carbon/proc/get_hand_organ(index)
	RETURN_TYPE(/obj/item/organ/external)
	if(index % 2)
		return get_organ(BP_L_HAND)
	else
		return get_organ(BP_R_HAND)

/**
 * Get the external organ of a held item
 *
 * @params
 * * held - the held item
 *
 * @return external organ or null
 */
/mob/living/carbon/proc/get_held_organ(obj/item/held)
	RETURN_TYPE(/obj/item/organ/external)
	return get_hand_organ(get_held_index(held))

//*                  Hands - Organs - Legacy Default Handling                     *//
//* To allow for multiple people able to control multiple active hands later,     *//
//* we'll need to pass active hand index through the clickchain / actor handlers. *//
//*
//* However, this system isn't in yet, so old code should still use these procs.  *//

/**
 * Get the external organ of the active hand
 *
 * * in mobs with no logical arm and only a hand, this returns the hand
 */
/mob/living/carbon/proc/get_active_hand_organ(index)
	RETURN_TYPE(/obj/item/organ/external)
	return get_hand_organ(active_hand)
