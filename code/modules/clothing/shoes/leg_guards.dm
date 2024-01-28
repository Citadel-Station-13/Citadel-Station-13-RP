/obj/item/clothing/shoes/leg_guard
	name = "leg guards"
	desc = "These will protect your legs and feet."
	body_cover_flags = LEGS|FEET
	weight = ITEM_WEIGHT_ARMOR_MEDIUM_BOOTS
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_MEDIUM_BOOTS
	species_restricted = null	//Unathi and Taj can wear leg armor now
	w_class = ITEMSIZE_NORMAL
	step_volume_mod = 1.3
	can_hold_knife = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/shoes/leg_guard/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	if(H.wear_suit)
		if(H.wear_suit.body_cover_flags & LEGS)
			to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
			return FALSE
		for(var/obj/item/clothing/accessory/A in H.wear_suit)
			if(A.body_cover_flags & LEGS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit]'s [A], it's in the way.</span>")
				return FALSE
	return TRUE

/obj/item/clothing/shoes/leg_guard/laserproof
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "leg_guards_laser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.1
	armor_type = /datum/armor/station/ablative

/obj/item/clothing/shoes/leg_guard/bulletproof
	name = "ballistic leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "leg_guards_bullet"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.7
	armor_type = /datum/armor/station/ballistic

/obj/item/clothing/shoes/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	icon_state = "leg_guards_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.5
	armor_type = /datum/armor/station/riot

/obj/item/clothing/shoes/leg_guard/combat
	name = "combat leg guards"
	desc = "These will protect your legs and feet from a variety of weapons."
	icon_state = "leg_guards_combat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.6
	armor_type = /datum/armor/station/combat

/obj/item/clothing/shoes/leg_guard/flexitac
	name = "tactical leg guards"
	desc = "These will protect your legs and feet from a variety of weapons while still allowing mobility."
	icon_state = "leg_guards_flexitac"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.6
	weight = ITEM_WEIGHT_ARMOR_LIGHT_BOOTS
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_LIGHT_BOOTS
	armor_type = /datum/armor/station/tactical
	min_cold_protection_temperature = T0C - 20
	cold_protection_cover = LEGS
