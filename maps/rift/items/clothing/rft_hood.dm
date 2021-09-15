// Thermal suit hoods

/obj/item/clothing/head/hood/medical/sar_thermal
	name = "search and rescue thermal hood"
	desc = "A thick hazardous environment suit hood lined with synthetic fur and aerogels for retaining as much body heat as possible. Doesn't accept armor inserts like the rest of it's attached suit, however it is fitted with a light synthetic weave to make up for it."
	icon_state = "sar_thermal"
	item_icons = list(slot_head_str = 'maps/rift/icons/mob/rft_hood.dmi')
	icon = 'maps/rift/icons/obj/rft_hood.dmi'
	flags = THICKMATERIAL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 10, bomb = 25, bio = 80, rad = 40)
