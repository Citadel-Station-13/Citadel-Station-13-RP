//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Hands - Organs *//

/**
 * Get the hand index of an organ
 *
 * * If an organ is responsible for more than one index, this only returns one of them.
 */
/mob/proc/get_hand_index_of_organ(obj/item/organ/external/organ)
	return null

/**
 * Get all hand indexes of an organ
 */
/mob/proc/get_hand_index_of_organ(obj/item/organ/external/organ)
	RETURN_TYPE(/list)
	return list()

/**
 * Get the external organ of an arm
 */
/mob/proc/get_hand_organ(index)
	RETURN_TYPE(/obj/item/organ/external)

#warn impl

//*                  Hands - Organs - Legacy Default Handling                     *//
//* To allow for multiple people able to control multiple active hands later,     *//
//* we'll need to pass active hand index through the clickchain / actor handlers. *//
//*
//* However, this system isn't in yet, so old code should still use these procs.  *//

/**
 * Get the external organ of an arm
 */
/mob/proc/get_active_hand_organ(index)
	RETURN_TYPE(/obj/item/organ/external)
	return get_hand_organ(active_hand)
