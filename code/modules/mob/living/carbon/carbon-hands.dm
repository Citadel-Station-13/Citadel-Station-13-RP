//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Hands - Checks *//

/mob/living/carbon/get_hand_manipulation_level(index)
	#warn impl

/mob/living/carbon/why_hand_manipulation_insufficient(index, manipulation)
	#warn impl

//* Hands - Organs *//

/**
 * Get the hand index of an organ
 *
 * * If an organ is responsible for more than one index, this only returns one of them.
 *
 * @return numerical index or null
 */
/mob/living/carbon/proc/get_hand_of_organ(obj/item/organ/external/organ)
	#warn impl
	return null

/**
 * Get all hand indexes of an organ
 *
 * @return list of numerical indices
 */
/mob/living/carbon/proc/get_hands_of_organ(obj/item/organ/external/organ)
	RETURN_TYPE(/list)
	#warn impl
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
	#warn impl

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
