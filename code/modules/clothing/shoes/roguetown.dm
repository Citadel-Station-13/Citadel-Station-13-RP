/obj/item/clothing/shoes/boots/roguetown
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/shoes/boots/roguetown/leather
	name = "leather boots"
	desc = "A pair of hardy leather boots."
	icon = 'icons/clothing/shoes/roguetown/leather_boots.dmi'
	icon_state = "leatherboots"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/shoes/boots/roguetown/fur
	name = "fur boots"
	desc = "A well padded pair of fur lined boots."
	icon = 'icons/clothing/shoes/roguetown/fur_boots.dmi'
	icon_state = "furboots"
	armor_type = /datum/armor/station/padded
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection_cover = FEET
	atom_flags = PHORONGUARD

/obj/item/clothing/shoes/boots/roguetown/black
	name = "black boots"
	desc = "A pair of black leather boots."
	icon = 'icons/clothing/shoes/roguetown/black_boots.dmi'
	icon_state = "blackboots"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/shoes/boots/roguetown/fancy
	name = "tailored boots"
	desc = "A pair of expertly tailored black boots."
	icon = 'icons/clothing/shoes/roguetown/fancy_boots.dmi'
	icon_state = "fancyboots"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/shoes/boots/roguetown/strange
	name = "strange boots"
	desc = "An odd set of black boots, reinforced with a metal you aren't familiar with."
	icon = 'icons/clothing/shoes/roguetown/strange_boots.dmi'
	icon_state = "strangeboots"
	armor_type = /datum/armor/eldritch/robes

/obj/item/clothing/shoes/roguetown/buckle
	name = "buckle shoes"
	desc = "A simple pair of shoes with buckles on them."
	icon = 'icons/clothing/shoes/roguetown/buckle_shoes.dmi'
	icon_state = "buckleshoes"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/shoes/boots/roguetown/armored/iron
	name = "armored boots"
	desc = "A pair of boots, reinforced with iron and hard leather."
	icon = 'icons/clothing/shoes/roguetown/iron_boots.dmi'
	icon_state = "ironboots"
	armor_type = /datum/armor/station/medium

/obj/item/clothing/shoes/boots/roguetown/armored/plate
	name = "plate boots"
	desc = "A set of heavy plate armor boots."
	icon = 'icons/clothing/shoes/roguetown/plate_boots.dmi'
	icon_state = "plateboots"
	armor_type = /datum/armor/station/combat

/obj/item/clothing/shoes/boots/roguetown/armored/heavy_plate
	name = "heavy plate boots"
	desc = "A set of reinforced plate boots. Little gets through that thick of armor."
	icon = 'icons/clothing/shoes/roguetown/heavy_plate_boots.dmi'
	icon_state = "heavyplateboots"
	armor_type = /datum/armor/station/tactical

/obj/item/clothing/shoes/boots/roguetown/armored/derelict
	name = "derelict boots"
	desc = "A pair of plate boots forged from a faded metal you cannot recognize."
	icon = 'icons/clothing/shoes/roguetown/derelict_boots.dmi'
	icon_state = "derelictboots"
	armor_type = /datum/armor/station/tactical
