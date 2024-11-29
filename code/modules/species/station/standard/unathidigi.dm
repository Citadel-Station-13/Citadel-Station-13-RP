/datum/species/unathi/digi
	uid = SPECIES_ID_UNATHI_DIGI
	id = SPECIES_ID_UNATHI_DIGI
	name = SPECIES_UNATHI_DIGI
	name_plural = SPECIES_UNATHI_DIGI
	default_bodytype = BODYTYPE_UNATHI_DIGI
	icobase       = 'icons/mob/species/unathidigi/body.dmi'
	deform        = 'icons/mob/species/unathidigi/deformed_body.dmi'
	husk_icon     = 'icons/mob/species/unathidigi/husk.dmi'
	preview_icon  = 'icons/mob/species/unathidigi/preview.dmi'

	sprite_accessory_defaults = list(
		SPRITE_ACCESSORY_SLOT_TAIL = /datum/sprite_accessory/tail/bodyset/unathi,
	)

	blurb = {"
	As a result of the many challenges of living on Moghes and other worlds, Unathi have become morphologically diverse.
	While some unathi are plantigrade and almost resemble humans in their silhouette, others are more hulking; a digitigrade, beastial and alien creature.
	"}

	has_external_organs = list(
		ORGAN_KEY_EXT_HEAD = /datum/species_organ_entry{
			override_type = /obj/item/organ/external/head/unathi/digi;
		},
		ORGAN_KEY_EXT_CHEST = /datum/species_organ_entry{
			override_type = /obj/item/organ/external/chest/unathi;
		},
		ORGAN_KEY_EXT_GROIN = /datum/species_organ_entry{
			override_type = /obj/item/organ/external/groin/unathi;
		},
		ORGAN_KEY_EXT_LEFT_ARM,
		ORGAN_KEY_EXT_LEFT_HAND,
		ORGAN_KEY_EXT_RIGHT_ARM,
		ORGAN_KEY_EXT_RIGHT_HAND,
		ORGAN_KEY_EXT_LEFT_LEG,
		ORGAN_KEY_EXT_LEFT_FOOT,
		ORGAN_KEY_EXT_RIGHT_LEG,
		ORGAN_KEY_EXT_RIGHT_FOOT,
	)
