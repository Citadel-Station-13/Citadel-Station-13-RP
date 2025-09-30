
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
	body_cover_flags = HEAD|EYES|FACE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)


// Helmets

/obj/item/clothing/head/roguetown/helmet/barbute
	name = "Barbute Helmet"
	desc = "A simple enclosed metal helmet."
	icon = 'icons/clothing/head/roguetown/helmets/barbute.dmi'
	icon_state = "barbute"
	armor_type = /datum/armor/station/medium
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/knight
	name = "Knight Helmet"
	desc = "A old fashioned metal helmet, bearing resemblance to the knights of yore."
	icon = 'icons/clothing/head/roguetown/helmets/knight.dmi'
	icon_state = "knight"
	armor_type = /datum/armor/station/mediumtreated
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/sallet_visor
	name = "Sallet Helmet"
	desc = "A simple, enclosed metal helmet fitted with a visor."
	icon = 'icons/clothing/head/roguetown/helmets/sallet.dmi'
	icon_state = "sallet_visor"
	armor_type = /datum/armor/station/medium
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR

/obj/item/clothing/head/roguetown/helmet/barred
	name = "Barred Helmet"
	desc = "A thick metal helmet which utilizes iron bars to protect the wearers face."
	icon = 'icons/clothing/head/roguetown/helmets/gate.dmi'
	icon_state = "gate"
	armor_type = /datum/armor/station/heavy
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/guard
	name = "Guard Helmet"
	desc = "A thick metal helmet with an attached face guard."
	icon = 'icons/clothing/head/roguetown/helmets/guard.dmi'
	icon_state = "guard"
	armor_type = /datum/armor/station/heavy
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/plate
	name = "Plate Helmet"
	desc = "A heavy plated helmet."
	icon = 'icons/clothing/head/roguetown/helmets/plate.dmi'
	icon_state = "plate"
	armor_type = /datum/armor/station/combat
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/heavy_plate
	name = "Heavy Plate Helmet"
	desc = "An incredibly heavy and reinforced plate armor helmet."
	icon = 'icons/clothing/head/roguetown/helmets/heavy_plate.dmi'
	icon_state = "heavy_plate"
	armor_type = /datum/armor/station/tactical
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/ancient_plate
	name = "Ancient Plate Helmet"
	desc = "An odd helmet that's clearly seen better days."
	icon = 'icons/clothing/head/roguetown/helmets/ancient_plate.dmi'
	icon_state = "ancient_plate"
	armor_type = /datum/armor/station/combat
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/strange
	name = "Strange Plate Helmet"
	desc = "A plate helmet, warped to resemble some sort of twisted face. It's un-nerving."
	icon = 'icons/clothing/head/roguetown/helmets/strange.dmi'
	icon_state = "strange"
	armor_type = /datum/armor/station/combat
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE

/obj/item/clothing/head/roguetown/helmet/odd
	name = "Odd Plate Helmet"
	desc = "A plate helmet, warped to resemble some sort of twisted face. It's un-nerving."
	icon = 'icons/clothing/head/roguetown/helmets/odd.dmi'
	icon_state = "odd"
	armor_type = /datum/armor/station/combat
	slot_flags = SLOT_HEAD
	body_cover_flags = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inv_hide_flags = HIDEEARS|BLOCKHAIR|HIDEFACE
