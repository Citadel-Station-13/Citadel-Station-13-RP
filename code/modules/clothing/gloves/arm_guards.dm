/obj/item/clothing/gloves/arm_guard
	name = "arm guards"
	desc = "These arm guards will protect your hands and arms."
	body_parts_covered = HANDS|ARMS
	overgloves = 1
	punch_force = 3
	w_class = ITEMSIZE_NORMAL
	drop_sound = 'sound/items/drop/metalshield.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/gloves/arm_guard/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	if(H.wear_suit)
		if(H.wear_suit.body_parts_covered & ARMS)
			to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>")
			return FALSE
		for(var/obj/item/clothing/accessory/A in H.wear_suit)
			if(A.body_parts_covered & ARMS)
				to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit]'s [A], it's in the way.</span>")
				return FALSE
	return TRUE

/obj/item/clothing/gloves/arm_guard/laserproof
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "arm_guards_laser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.4 //This is worse than the other ablative pieces, to avoid this from becoming the poor warden's insulated gloves.
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/bulletproof
	name = "bullet resistant arm guards"
	desc = "These arm guards will protect your hands and arms from ballistic weapons."
	icon_state = "arm_guards_bullet"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.7
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your hands and arms from close combat weapons."
	icon_state = "arm_guards_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.5
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/combat
	name = "combat arm guards"
	desc = "These arm guards will protect your hands and arms from a variety of weapons."
	icon_state = "arm_guards_combat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 30, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/flexitac
	name = "tactical arm guards"
	desc = "These arm guards will protect your hands and arms from a variety of weapons while still allowing mobility."
	icon_state = "arm_guards_flexitac"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.6
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)
	min_cold_protection_temperature = T0C - 20
	cold_protection = ARMS

/obj/item/clothing/gloves/arm_guard/combat/imperial
	name = "imperial gauntlets"
	desc = "Made of some exotic metal, and crafted by space elves. Elves have delicate hands."
	icon_state = "ge_gloves"
