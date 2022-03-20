//A variant of the suitstorage that can store multiple suits at once
//

/obj/machinery/suit_storage_closet
	name = "Suit Storage Automated Closet"
	desc = "A repurposed automated closet to help manage space and voidsuits. Thank Frag Felix Storage for this gift."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "automatedCloset"

	anchored = 1
	density = 1

	var/list/obj/item/clothing/suit/space/suits = list()
	var/suit_stored_TYPE = /obj/item/clothing/suit/space/void
	var/suit_amount

	var/list/obj/item/clothing/head/helmet/space/helmets = list()
	var/helmet_stored_TYPE = /obj/item/clothing/head/helmet/space/void
	var/helmet_amount

	var/list/obj/item/clothing/mask/masks = list()
	var/mask_stored_TYPE = /obj/item/clothing/mask/breath
	var/mask_amount

	var/list/obj/item/clothing/shoes/boots = list()
	var/boots_stored_TYPE = /obj/item/clothing/shoes/boots/jackboots
	var/boots_amount

	var/starting_amount = 5
	var/max_amount = 10
	var/ispowered = 1

/obj/machinery/suit_storage_closet/Initialize(mapload, newdir)
	. = ..()
	for(var/i=0;i < starting_amount; i++)
		LAZYADD(suits, new suit_stored_TYPE(src))
		LAZYADD(helmets, new helmet_stored_TYPE(src))
		LAZYADD(masks, new mask_stored_TYPE(src))
		LAZYADD(boots, new boots_stored_TYPE(src))

	update_amounts()

/obj/machinery/suit_storage_closet/proc/update_amounts()
	suit_amount = LAZYLEN(suits)
	helmet_amount = LAZYLEN(helmets)
	mask_amount = LAZYLEN(masks)
	boots_amount = LAZYLEN(boots)

/obj/machinery/suit_storage_closet/power_change()
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
	else
		ispowered = 0
		//Todo: add lockdown

/obj/machinery/suit_storage_closet/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_closet/attack_hand(mob/user as mob)
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	removal_menu(user)

/obj/machinery/suit_storage_closet/proc/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		if(helmet_amount > 0)
			menuoptions += "Helmet"
		if(suit_amount > 0)
			menuoptions += "Suit"
		if(boots_amount > 0)
			menuoptions += "Boots"
		if(mask_amount > 0)
			menuoptions += "Mask"
		var/selection = input(user, "Which type would you like to remove?", "Remove Contents") as null|anything in menuoptions
		switch(selection)
			if("Helmet")
				if(helmet_amount <= 0)
					to_chat(user, "<span class='warning'>There are no helmets stored in this storage unit</span>")
				var/obj/item/clothing/head/helmet/space/helmet_selection = input(user, "Which Helmet would you like to remove?", "Remove Contents") as null|anything in helmets
				if(istype(helmet_selection))
					helmet_selection.loc = src.loc
					LAZYREMOVE(helmets, helmet_selection)
					update_amounts()
			if("Suit")
				if(suit_amount <= 0)
					to_chat(user, "<span class='warning'>There are no suits stored in this storage unit</span>")
				var/obj/item/clothing/suit/space/suit_selection = input(user, "Which Suit would you like to remove?", "Remove Contents") as null|anything in suits
				if(istype(suit_selection))
					suit_selection.loc = src.loc
					LAZYREMOVE(suits, suit_selection)
					update_amounts()
			if("Boots")
				if(boots_amount <= 0)
					to_chat(user, "<span class='warning'>There are no suits stored in this storage unit</span>")
				var/obj/item/clothing/shoes/boot_selection = input(user, "Which Boots would you like to remove?", "Remove Contents") as null|anything in boots
				if(istype(boot_selection))
					boot_selection.loc = src.loc
					LAZYREMOVE(boots, boot_selection)
					update_amounts()
			if("Mask")
				if(mask_amount <= 0)
					to_chat(user, "<span class='warning'>There are no masks stored in this storage unit</span>")
				var/obj/item/clothing/mask/mask_selection = input(user, "Which Mask would you like to remove?", "Remove Contents") as null|anything in masks
				if(istype(mask_selection))
					mask_selection.loc = src.loc
					LAZYREMOVE(masks, mask_selection)
					update_amounts()
		return 1
	return 0

/obj/machinery/suit_storage_closet/proc/can_remove_items(var/mob/user)
	if (!Adjacent(user))
		return 0

	if (isanimal(user))
		return 0

	return 1
/*
/obj/machinery/suit_storage_closet/proc/dispense_helmet(mob/user as mob, var/list_index)
	if(helmet_amount <= 0)
		return
	else
		var/obj/item/clothing/head/helmet/space/helmet_dispense = LAZYACCESS(helmets, list_index)
		LAZYREMOVE(helmets,helmet_dispense)
		helmet_dispense.loc = src.loc
		return

/obj/machinery/suit_storage_closet/proc/dispense_mask(mob/user as mob, var/list_index)
	if(mask_amount <= 0)
		return
	else
		var/obj/item/clothing/mask/breath/mask_dispense = LAZYACCESS(masks, list_index)
		LAZYREMOVE(masks,mask_dispense)
		mask_dispense.loc = src.loc
		return

/obj/machinery/suit_storage_closet/proc/dispense_suit(mob/user as mob, var/list_index)
	if(suit_amount <= 0)
		return
	else
		var/obj/item/clothing/suit/space/suit_dispense = LAZYACCESS(suits, list_index)
		LAZYREMOVE(suits,suit_dispense)
		suit_dispense.loc = src.loc
		return

/obj/machinery/suit_storage_closet/proc/dispense_boot(mob/user as mob, var/list_index)
	if(boots_amount <= 0)
		return
	else
		var/obj/item/clothing/shoes/boots/boot_dispense = LAZYACCESS(boots, list_index)
		LAZYREMOVE(boots,boot_dispense)
		boot_dispense.loc = src.loc
		return*/

/obj/machinery/suit_storage_closet/proc/dump_everything()
	helmet_amount = 0
	suit_amount = 0
	mask_amount = 0
	boots_amount = 0
	var/obj/item/clothing/dispense_item = null
	while(LAZYLEN(suits)>0)
		dispense_item = SAFEPICK(suits)
		if(dispense_item)
			dispense_item.loc = src.loc
			LAZYREMOVE(suits, dispense_item)
	while(LAZYLEN(helmets)>0)
		dispense_item = SAFEPICK(helmets)
		if(dispense_item)
			dispense_item.loc = src.loc
			LAZYREMOVE(helmets, dispense_item)
	while(LAZYLEN(masks)>0)
		dispense_item = SAFEPICK(masks)
		if(dispense_item)
			dispense_item.loc = src.loc
			LAZYREMOVE(masks, dispense_item)
	while(LAZYLEN(boots)>0)
		dispense_item = SAFEPICK(boots)
		if(dispense_item)
			dispense_item.loc = src.loc
			LAZYREMOVE(boots, dispense_item)
	return

/obj/machinery/suit_storage_closet/attackby(obj/item/I as obj, mob/user as mob)
	if(!ispowered)
		return
	/*if(I.is_screwdriver())
		panelopen = !panelopen
		playsound(src, I.usesound, 100, 1)
		to_chat(user, "<font color=#4F49AF>You [panelopen ? "open up" : "close"] the unit's maintenance panel.</font>")
		updateUsrDialog()
		return*/
	/*if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!(ismob(G.affecting)))
			return
		if(!isopen)
			to_chat(user, "<font color='red'>The unit's doors are shut.</font>")
			return
		if(!ispowered || isbroken)
			to_chat(user, "<font color='red'>The unit is not operational.</font>")
			return
		if((OCCUPANT) || (helmet_stored) || (suit_stored)) //Unit needs to be absolutely empty
			to_chat(user, "<font color='red'>The unit's storage area is too cluttered.</font>")
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20))
			if(!G || !G.affecting) return //derpcheck
			var/mob/M = G.affecting
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			OCCUPANT = M
			isopen = 0 //close ittt

			//for(var/obj/O in src)
			//	O.loc = src.loc
			add_fingerprint(user)
			qdel(G)
			updateUsrDialog()
			update_icon()
			return
		return*/
	if(istype(I,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/S = I
		if(suit_amount >= max_amount)
			to_chat(user, "<font color=#4F49AF>[src] is already at capacity. [S] won't fit!</font>")
			return
		to_chat(user, "You load the [S.name] into [src].")
		user.drop_item()
		S.loc = src
		LAZYADD(suits, S)
		update_amounts()
		return
	if(istype(I,/obj/item/clothing/head/helmet))
		var/obj/item/clothing/head/helmet/H = I
		if(helmet_amount >= max_amount)
			to_chat(user, "<font color=#4F49AF>[src] is already at capacity. [H] won't fit!</font>")
			return
		to_chat(user, "You load the [H.name] into [src].")
		user.drop_item()
		H.loc = src
		LAZYADD(helmets, H)
		update_amounts()
		return
	if(istype(I,/obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = I
		if(mask_amount >= max_amount)
			to_chat(user, "<font color=#4F49AF>[src] is already at capacity. [M] won't fit!</font>")
			return
		to_chat(user, "You load the [M.name] into [src].")
		user.drop_item()
		M.loc = src
		LAZYADD(masks, M)
		update_amounts()
		return
	if(istype(I,/obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/B = I
		if(mask_amount >= max_amount)
			to_chat(user, "<font color=#4F49AF>[src] is already at capacity. [B] won't fit!</font>")
			return
		to_chat(user, "You load the [B.name] into [src].")
		user.drop_item()
		B.loc = src
		LAZYADD(boots, B)
		update_amounts()
		return
	return
