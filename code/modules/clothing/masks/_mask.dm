//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi' //custom species support.
	inhand_default_type = INHAND_DEFAULT_ICON_MASKS
	body_cover_flags = HEAD
	slot_flags = SLOT_MASK
	body_cover_flags = FACE|EYES
	blood_sprite_state = "maskblood"

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs

// gets one gas_mixture
// that mixture is modified (and then used for breathing)
// additionally removed gases can be returned to be passed to atmos
/obj/item/clothing/mask/proc/process_air(datum/gas_mixture/air)
	return

//gets one gas_mixture (the exhale)
//returns what should be passed to the environment
/obj/item/clothing/mask/proc/process_exhale(datum/gas_mixture/air)
	return

