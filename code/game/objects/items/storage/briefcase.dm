/obj/item/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	damage_force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 4
	sfx_open = 'sound/items/storage/briefcase.ogg'
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/briefcase/clutch
	name = "clutch purse"
	desc = "A fashionable handheld bag typically used by women."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_state = "clutch"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "smpurse", SLOT_ID_LEFT_HAND = "smpurse")
	damage_force = 0
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_SMALL
	max_combined_volume = WEIGHT_VOLUME_SMALL * 4

/obj/item/storage/briefcase/crafted
	desc = "Hand crafted suitcase made of leather and cloth."
	damage_force = 6

/obj/item/storage/briefcase/crafted/legacy_spawn_contents()
	return //So we dont spawn items
