//! misc stuff
//? taur checks
/mob/proc/is_taur()
	return FALSE

/mob/living/carbon/human/is_taur()
	var/datum/sprite_accessory_data/data = peek_sprite_accessory_tail()
	return data && istype(data.accessory, /datum/sprite_accessory_meta/tail/taur)

