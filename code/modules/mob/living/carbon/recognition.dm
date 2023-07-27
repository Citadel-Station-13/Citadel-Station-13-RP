//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/living/carbon/get_face_name(mob/recognizing, dist)
	// check disfigurement
	// todo: different species might not have a head for recognition?
	var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
	if(isnull(head_organ) || head_organ.disfigured || head_organ.is_stump())
		return "Unknown"
	if(MUTATION_HUSK in mutations)
		return "Unknown"
	return ..()

/mob/living/carbon/get_id_name(mob/recognizing, dist)
	if(isnull(dist))
		dist = isnull(recognizing)? get_dist(src, recognizing) : 0
	. = "Unknown"
	// todo: modifiers? sight?
	if(dist > 2)
		return
	var/obj/item/card/id/used = get_idcard()
	if(!isnull(used))
		. = used.registered_name
