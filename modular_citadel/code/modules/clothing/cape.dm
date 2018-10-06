// I gave up.
// Toggle front function is from flannel verbs.
// Also contains modified hood toggle and hood remove procs for cape.

/obj/item/clothing/head/cape_hood
	name = "cape hood"
	desc = "It's a hood that covers the head."
	icon = 'modular_citadel/icons/obj/clothing/cape.dmi'
	icon_override = 'modular_citadel/icons/mob/cape.dmi'
	icon_state = "cape_hood"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	flags_inv = BLOCKHEADHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/storage/hooded/cape
	name = "cape"
	desc = "A bland, rough, dark cape."
	icon = 'modular_citadel/icons/obj/clothing/cape.dmi'
	icon_override = 'modular_citadel/icons/mob/cape.dmi'
	icon_state = "cape"
	body_parts_covered = 0
	flags_inv = 0
	hoodtype = /obj/item/clothing/head/cape_hood
	w_class = ITEMSIZE_NORMAL
	var/frontcover = 0 // Alas, doesn't cover your items in hands and still show backpack straps.

/obj/item/clothing/suit/storage/hooded/cape/verb/adjust_cape()
	set name = "Adjust Cape"
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
		body_parts_covered = 0
		usr << "<span class='notice'>You move [src]'s fabric away.</span>"
	update_icon()

/obj/item/clothing/suit/storage/hooded/cape/update_icon()
	icon_state = initial(icon_state)
	if(frontcover)
		icon_state += "_f"
	update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/cape/RemoveHood()
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

/obj/item/clothing/suit/storage/hooded/cape/ToggleHood()
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
