/mob/living/carbon/proc/get_active_hand_organ_key()
	#warn impl

/mob/living/carbon/proc/get_active_hand_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return get_organ(get_active_hand_organ_key())
