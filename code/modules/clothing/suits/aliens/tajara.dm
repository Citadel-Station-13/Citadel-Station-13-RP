/obj/item/clothing/suit/tajaran/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/clothing/head/tajaran/scarf	//This stays in /suits because it goes with the furs above
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = HEAD|FACE
	body_cover_flags = HEAD|FACE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'
