/datum/species/unathi/digi
	uid = SPECIES_ID_UNATHI_DIGI
	name = SPECIES_UNATHI_DIGI
	name_plural = SPECIES_UNATHI_DIGI
	default_bodytype = BODYTYPE_UNATHI_DIGI

	icobase       = 'icons/mob/species/unathidigi/body.dmi'
	deform        = 'icons/mob/species/unathidigi/deformed_body.dmi'
	husk_icon     = 'icons/mob/species/unathidigi/husk.dmi'
	preview_icon  = 'icons/mob/species/unathidigi/preview.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathidigi/tail.dmi'

	blurb = {"
	As a result of the many challenges of living on Moghes and other worlds, Unathi have become morphologically diverse. 
	While some unathi are plantigrade and almost resemble humans in their silhouette, others are more hulking; a digitigrade, beastial and alien creature.
	"}

	organs_icon = 'icons/mob/species/unathidigi/organs.dmi'
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/unathi),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/unathi),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/unathi/digi),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)
