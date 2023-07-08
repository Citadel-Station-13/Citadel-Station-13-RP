/mob/living/carbon/proc/get_active_hand_organ_key()
	return get_hand_organ_key(active_hand)

/mob/living/carbon/proc/get_active_hand_organ()
	RETURN_TYPE(/obj/item/organ/external)
	return get_organ(get_hand_organ_key(active_hand))

/mob/living/carbon/proc/get_hand_organ_key(index)
	#warn impl

/mob/living/carbon/proc/get_hand_organ(index)
	return get_organ(get_hand_organ_key(index))

/mob/living/carbon/proc/is_hand_functional(index)
	var/obj/item/organ/external/part = get_hand_organ(index)
	#warn impl

