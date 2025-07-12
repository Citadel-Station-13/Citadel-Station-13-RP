







// Hats


/obj/item/clothing/head/roguetown/leather
	name = "leather hat"
	desc = "A fine leather hat."
	icon = 'icons/clothing/head/roguetown/leather_hat.dmi'
	icon_state = "leatherhat"
	icon_mob_y_align = 1
	armor_type = /datum/armor/station/padded
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS


/obj/item/clothing/head/roguetown/blackleather
	name = "black leather hat"
	desc = "A hat crafted from some kind of black leather."
	icon = 'icons/clothing/head/roguetown/blackleather_hat.dmi'
	icon_state = "blackleatherhat"
	icon_mob_y_align = 1
	armor_type = /datum/armor/station/padded
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS

// Hoods

/obj/item/clothing/hood/roguetown/hide
	name = "hide hood"
	desc = "A insulating hood that has been crafted from animal hide."
	icon = 'icons/clothing/head/roguetown/hide_hood.dmi'
	icon_state = "hidehood"
	armor_type = /datum/armor/station/padded
	slot_flags = SLOT_HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	inv_hide_flags = HIDEEARS|HIDEFACE|HIDEMASK|BLOCKHAIR
	body_cover_flags = HEAD|EYES|FACE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/hood/roguetown/cloth
	name = "cloth hood"
	desc = "A simple hood fashioned out of cloth."
	icon = 'icons/clothing/head/roguetown/cloth_hood.dmi'
	icon_state = "clothhood"
	slot_flags = SLOT_HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE
	body_cover_flags = HEAD|EYES
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
