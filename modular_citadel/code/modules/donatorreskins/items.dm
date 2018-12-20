//This is where you make the items you plan to reskin stuff to.


/obj/item/clothing/head/helmet/space/void/security/jenna
	name = "Silver's Helmet"
	desc = "A black heavily modified 30 year old voidsuit helmet by the looks of it. It appears to be fitted with a specialized breathing system and built in voice modifier. On the back of it is a well worn though very polished chrome plate bearing the name 'Silver' and several nicks and scratches."
	icon_state = "silverhelmet"
	item_state_slots = list(slot_r_hand_str = "silverhelmet", slot_l_hand_str = "silverhelmet")
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state = "silverhelmet"
	item_state_slots = list(slot_r_hand_str = "sec_helm", slot_l_hand_str = "sec_helm")
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 5, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"
	species_restricted = list(SPECIES_AKULA)