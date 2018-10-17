// I gave up.
// Toggle front function is from flannel verbs.
// Also contains modified hood toggle and hood remove procs for long cloak.

// Hood for long cloak
/obj/item/clothing/head/lcloak_hood
	name = "cloak hood"
	desc = "It's a hood that covers the head."
	icon = 'modular_citadel/icons/obj/clothing/lcloak.dmi'
	icon_override = 'modular_citadel/icons/mob/lcloak.dmi'
	icon_state = "lcloak_hood"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD

// Long cloak itself
/obj/item/clothing/suit/storage/hooded/lcloak
	name = "dark long cloak"
	desc = "A bland, rough, dark cloak."
	icon = 'modular_citadel/icons/obj/clothing/lcloak.dmi'
	icon_override = 'modular_citadel/icons/mob/lcloak.dmi'
	icon_state = "lcloak"
	body_parts_covered = 0
	flags_inv = 0
	hoodtype = /obj/item/clothing/head/lcloak_hood
	w_class = ITEMSIZE_NORMAL
	var/frontcover = 0 // Alas, doesn't cover your items in hands and still show backpack straps.

// Goliath cloak
/obj/item/clothing/head/lcloak_hood/goliath
	name = "goliath cloak hood"
	icon_state = "golhood"
	desc = "A protective and concealing hood."
	armor = list("melee" = 35, "bullet" = 10, "laser" = 25, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0)
	flags_inv = BLOCKHEADHAIR|HIDEEARS|HIDEEYES

/obj/item/clothing/suit/storage/hooded/lcloak/goliath
	name = "goliath cloak"
	desc = "A staunch, practical cape made out of numerous monster materials, it is coveted amongst exiles & hermits."
	icon_state = "golclo"
	armor = list("melee" = 35, "bullet" = 10, "laser" = 25, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0)
	hoodtype = /obj/item/clothing/head/lcloak_hood/goliath
	body_parts_covered = UPPER_TORSO|ARMS

// Same stuff but no armor (AKA Replica).
/obj/item/clothing/head/lcloak_hood/goliath/fake
	name = "dark-red cloak hood"
	desc = "A concealing hood."
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0)

/obj/item/clothing/suit/storage/hooded/lcloak/goliath/fake
	name = "dark-red cloak"
	desc = "A practical, dark-red cloak."
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0)

// Code that makes long cloak special
/obj/item/clothing/suit/storage/hooded/lcloak/verb/adjust_cloak()
	set name = "Adjust Cloak"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return
	if(frontcover == 0)
		frontcover = 1
		flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDETIE|HIDEHOLSTER|HIDESUITSTORAGE|HIDETAIL
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS
		usr << "<span class='notice'>You adjust [src]'s fabric to front.</span>"
	else
		frontcover = 0
		flags_inv = 0
		body_parts_covered = initial(body_parts_covered)
		usr << "<span class='notice'>You move [src]'s fabric away.</span>"
	update_icon()

/obj/item/clothing/suit/storage/hooded/lcloak/goliath/adjust_cloak()
	if(frontcover == 0)
		frontcover = 1
		flags_inv = HIDEGLOVES|HIDETIE|HIDEHOLSTER|HIDESUITSTORAGE|HIDETAIL
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS
		usr << "<span class='notice'>You adjust [src] to front.</span>"
	else
		frontcover = 0
		flags_inv = 0
		body_parts_covered = initial(body_parts_covered)
		usr << "<span class='notice'>You move [src] back in place.</span>"
	update_icon()

/obj/item/clothing/suit/storage/hooded/lcloak/update_icon()
	icon_state = initial(icon_state)
	if(frontcover)
		icon_state += "_f"
	update_clothing_icon()


// Code that modifies hood-related code, so it will not break frontcover sprite
/obj/item/clothing/suit/storage/hooded/lcloak/RemoveHood()
	if(!frontcover)
		icon_state = toggleicon
	else
		icon_state = "[toggleicon]_f"
	suittoggled = 0
	hood.canremove = TRUE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/lcloak/ToggleHood()
	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
				hood.canremove = FALSE
				icon_state += "_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()
