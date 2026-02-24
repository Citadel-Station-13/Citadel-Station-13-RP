
// TODO: common 'total body destruction' proc
/mob/living/carbon/dust(anim, remains)
	// drop indestructible internal organs
	for(var/obj/item/organ/I in internal_organs)
		// TODO: proc on organ for surviving total body destruction
		if(!I.integrity_enabled || (I.integrity_flags & INTEGRITY_INDESTRUCTIBLE))
			I.removed()
			I.forceMove(drop_location())
			continue
	. = ..()
