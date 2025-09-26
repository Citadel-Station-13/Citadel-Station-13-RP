//Clothing items ported from roguetown Peak. None of these belong to me, they've done fantastic work.

/obj/item/clothing/under/roguetown
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)


// Casual

/obj/item/clothing/under/roguetown/trousers
	name = "leather trousers"
	desc = "A pair of sturdy leather trousers."
	icon = 'icons/clothing/uniform/casual/roguetown/pants/trousers.dmi'
	icon_state = "trousers"
	armor_type = /datum/armor/station/padded
	icon_mob_y_align = -1

/obj/item/clothing/under/roguetown/belted
	name = "belted pants"
	desc = "A pair of black pants that have had a few belts fastened to them."
	icon = 'icons/clothing/uniform/casual/roguetown/pants/belted.dmi'
	icon_state = "belt"
	armor_type = /datum/armor/station/padded
	icon_mob_y_align = -1

/obj/item/clothing/under/roguetown/black
	name = "black pants"
	desc = "A nifty pair of black cloth pants. Comfortable at the very least."
	icon = 'icons/clothing/uniform/casual/roguetown/pants/black.dmi'
	icon_state = "black"
	icon_mob_y_align = -1

/obj/item/clothing/under/roguetown/cloth
	name = "cloth pants"
	desc = "A simple set of cloth pants. Surely you can do better than this, right?"
	icon = 'icons/clothing/uniform/casual/roguetown/pants/cloth.dmi'
	icon_state = "cloth"
	icon_mob_y_align = -1

// Armor

/obj/item/clothing/under/roguetown/leather
	name = "leather leggings"
	desc = "A set of hardy leather leggings."
	icon = 'icons/clothing/uniform/casual/roguetown/pants/leather_leggings.dmi'
	icon_state = "leather_leggings"
	armor_type = /datum/armor/station/light

/obj/item/clothing/under/roguetown/chain
	name = "chain leggings"
	desc = "A set of light chain leggings."
	icon = 'icons/clothing/uniform/casual/roguetown/pants/chain_leggings.dmi'
	icon_state = "chain_leggings"
	armor_type = /datum/armor/station/medium

/obj/item/clothing/under/roguetown/plate
	name = "plate leggings"
	desc = "A heavy pair of plate armor leggings"
	icon = 'icons/clothing/uniform/casual/roguetown/pants/plate_leggings.dmi'
	icon_state = "plate_leggings"
	armor_type = /datum/armor/station/heavy
