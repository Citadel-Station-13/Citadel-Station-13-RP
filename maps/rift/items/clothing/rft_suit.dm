// Thermal suits

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar_thermal
	name = "search and rescue thermal suit"
	desc = "A hefty hazardous environment suit lined with synthetic fur and aerogels for retaining as much body heat as possible. A blue star of life is emblazoned on the back, with the words search and rescue written underneath."
	icon_state = "sar_thermal"
	item_icons = list(slot_wear_suit_str = 'maps/rift/icons/mob/rft_suit.dmi')
	icon = 'maps/rift/icons/obj/rft_suit.dmi'
	flags = THICKMATERIAL
	flags_inv = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/hood/medical/sar_thermal
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.9
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 80, rad = 0)
	valid_accessory_slots = (ACCESSORY_SLOT_INSIGNIA|ACCESSORY_SLOT_ARMOR_C)
	allowed = list(
	/obj/item/device/flashlight,
	/obj/item/weapon/gun,
	/obj/item/ammo_magazine,
	/obj/item/weapon/melee,
	/obj/item/weapon/material/knife,
	/obj/item/weapon/tank,
	/obj/item/device/radio,
	/obj/item/weapon/pickaxe,
	/obj/item/weapon/gun/projectile/sec/flash
		)