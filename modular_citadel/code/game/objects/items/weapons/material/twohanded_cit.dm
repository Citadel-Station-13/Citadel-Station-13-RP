// Contains: Bastard Sword

/obj/item/weapon/material/twohanded/bsword
	icon = 'modular_citadel/icons/obj/weapons_cit.dmi'
	item_icons = list(
			slot_back_str = 'modular_citadel/icons/mob/back_cit.dmi',
			slot_l_hand_str = 'modular_citadel/icons/mob/items/lefthand_cit.dmi',
			slot_r_hand_str = 'modular_citadel/icons/mob/items/righthand_cit.dmi',
			slot_belt_str = 'modular_citadel/icons/mob/belt_cit.dmi',
			)
	icon_state = "bsword0"
	base_icon = "bsword"
	name = "bastard sword"
	desc = "Also known as \"longsword\" or \"hand-and-a-half sword\", but it's easier to just call it bastard."
	description_info = "This weapon can slice, striking nearby lesser, hostile enemies close to the primary target. It must be held in both hands to do this."
	unwielded_force_divisor = 0.15
	force_divisor = 0.7
	thrown_force_divisor = 0.5
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK | SLOT_BELT
	force_wielded = 20
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	applies_material_colour = 0
