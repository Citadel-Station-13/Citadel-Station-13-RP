/obj/item/clothing/under/donator
	name = "base donator jumpsuit"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/donator
	name = "base donator labcoat"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/armor/vest/donator
	name = "base donator armor"
	desc = "Yet again just here for convenience, use it as a base for donator armour-style items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/donator/bee_costume
	name = "bee costume"
	desc = "Bee the true Queen!"
	icon_state = "bee"
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee")
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hooded = 1
	hoodtype = /obj/item/clothing/head/bee_hood

/obj/item/clothing/head/donator/bee_hood
	name = "bee hood"
	desc = "A hood attached to a bee costume."
	icon_state = "beehood"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee") //Does not exist -S2-
	body_parts_covered = HEAD