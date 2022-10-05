//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi' //custom species support.
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_masks.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_masks.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	item_icons = list(
		SLOT_ID_MASK = 'icons/mob/clothing/mask.dmi'
		) //custom species support.
	blood_sprite_state = "maskblood"

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return
