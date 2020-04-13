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
	species_restricted = list(SPECIES_AKULA)

/obj/item/melee/baton/stunsword
	name = "stunsword"
	desc = "A sleek, menacing-looking stunbaton fashioned to look like a sword, but isn't sharp. This model seems to belong to Pavel Marsk."
	icon_state = "stunsword"
	icon = 'modular_citadel/icons/obj/stunsword.dmi'
	item_icons = list(
			slot_l_hand_str = 'modular_citadel/icons/mob/inhands/stunsword_left.dmi',
			slot_r_hand_str = 'modular_citadel/icons/mob/inhands/stunsword_right.dmi',
			)
	item_state_slots = list(slot_r_hand_str = "stunsword", slot_l_hand_str = "stunsword")