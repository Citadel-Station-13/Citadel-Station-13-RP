/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
	w_class = ITEMSIZE_TINY

/obj/item/clothing/mask/muzzle/New()
    ..()
    say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
    say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/living/user as mob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state_slots = list(slot_r_hand_str = "sterile", slot_l_hand_str = "sterile")
	w_class = ITEMSIZE_SMALL
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)
	var/hanging = 0

/obj/item/clothing/mask/surgical/proc/adjust_mask(mob_user)
	if(usr.canmove && !usr.stat)
		src.hanging = !src.hanging
		if (src.hanging)
			gas_transfer_coefficient = 1
			body_parts_covered = body_parts_covered & ~FACE
			armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
			icon_state = "steriledown"
			to_chat(usr, "You pull the mask below your chin.")
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)
			armor = initial(armor)
			to_chat(usr, "You pull the mask up to cover your face.")
		update_clothing_icon()

/obj/item/clothing/mask/surgical/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	adjust_mask(usr)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0

//scarves (fit in in mask slot)
//None of these actually have on-mob sprites...
/obj/item/clothing/mask/bluescarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/redscarf
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/greenscarf
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/ninjascarf
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	siemens_coefficient = 0

//Nock Masks?
/obj/item/clothing/mask/nock_scarab
	name = "nock mask (blue, scarab)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_scarab"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_demon
	name = "nock mask (purple, demon)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_demon"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_life
	name = "nock mask (green, life)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_life"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/nock_ornate
	name = "nock mask (red, ornate)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_ornate"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = HEAD|FACE

/obj/item/clothing/mask/horsehead/New()
    ..()
    // The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
    say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
    say_verbs = list("whinnies", "neighs", "says")

/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")
	flags_inv = HIDEFACE
	body_parts_covered = 0
	var/mob/observer/eye/aiEye/eye

/obj/item/clothing/mask/ai/New()
	eye = new(src)

/obj/item/clothing/mask/ai/equipped(var/mob/user, var/slot)
	..(user, slot)
	if(slot == slot_wear_mask)
		eye.owner = user
		user.eyeobj = eye

		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)
		eye.setLoc(user)

/obj/item/clothing/mask/ai/dropped(var/mob/user)
	..()
	if(eye.owner == user)
		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)

		eye.owner.eyeobj = null
		eye.owner = null

//Samurai
/obj/item/clothing/mask/samurai
	name = "menpo"
	desc = "Antique facial armor hailing from old Earth. Designed to protect against sword blows and potentially arrows. This version has been carefully retrofitted to provide air."
	icon_state = "menpo"
	item_state_slots = list(slot_r_hand_str = "bandblack", slot_l_hand_str = "bandblack")
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	body_parts_covered = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

//Bandanas
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining. Can be worn on the head or face."
	w_class = ITEMSIZE_TINY
	flags_inv = HIDEFACE
	slot_flags = SLOT_MASK|SLOT_HEAD
	body_parts_covered = FACE
	icon_state = "bandblack"
	item_state_slots = list(slot_r_hand_str = "bandblack", slot_l_hand_str = "bandblack")

/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	switch(slot)
		if(slot_wear_mask) //Mask is the default for all the settings
			flags_inv = initial(flags_inv)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)

		if(slot_head)
			flags_inv = 0
			body_parts_covered = HEAD
			icon_state = "[initial(icon_state)]_up"

	return ..()

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandred"
	item_state_slots = list(slot_r_hand_str = "bandred", slot_l_hand_str = "bandred")

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandblue"
	item_state_slots = list(slot_r_hand_str = "bandblue", slot_l_hand_str = "bandblue")

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgreen"
	item_state_slots = list(slot_r_hand_str = "bandgreen", slot_l_hand_str = "bandgreen")

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgold"
	item_state_slots = list(slot_r_hand_str = "bandgold", slot_l_hand_str = "bandgold")

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem. Can be worn on the head or face."
	icon_state = "bandskull"
	item_state_slots = list(slot_r_hand_str = "bandskull", slot_l_hand_str = "bandskull")
