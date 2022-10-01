//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi' //custom species support.
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	item_icons = list(
		SLOT_ID_MASK = 'icons/mob/clothing/mask.dmi'
		) //custom species support.
	blood_sprite_state = "maskblood"
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/clothing/species/akula/mask.dmi',
		SPECIES_NEVREAN     = 'icons/mob/clothing/species/nevrean/mask.dmi',
		SPECIES_SERGAL      = 'icons/mob/clothing/species/sergal/mask.dmi',
		SPECIES_TAJ         = 'icons/mob/clothing/species/tajaran/mask.dmi',
		SPECIES_TESHARI     = 'icons/mob/clothing/species/teshari/masks.dmi',
		SPECIES_UNATHI      = 'icons/mob/clothing/species/unathi/mask.dmi',
		SPECIES_VOX         = 'icons/mob/clothing/species/vox/masks.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		SPECIES_WEREBEAST   = 'icons/mob/clothing/species/werebeast/masks.dmi',
		SPECIES_XENOCHIMERA = 'icons/mob/clothing/species/tajaran/mask.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/mask.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/clothing/species/fox/mask.dmi',
		) //custom species support.

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return
