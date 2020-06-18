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
	allowed = list (/obj/item/gun,/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle)
