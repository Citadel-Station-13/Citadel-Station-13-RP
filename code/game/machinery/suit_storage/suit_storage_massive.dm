//A variant of the suitstorage that can store multiple suits at once
//

/obj/machinery/suit_storage_closet
	name = "Suit Storage Automated Closet"
	desc = "A repurposed automated closet to help manage space and voidsuits. Thank Frag Felix Storage for this gift."
	icon_state = "automatedCloset"
	var/list/obj/item/clothing/suit/space/suits = list()
	var/suit_stored_TYPE = /obj/item/clothing/suit/space
	var/suit_amount

	var/list/obj/item/clothing/head/helmet/space/helmets = list()
	var/helmet_stored_TYPE = /obj/item/clothing/head/helmet/space
	var/helmet_amount

	var/list/obj/item/clothing/mask/masks = list()
	var/mask_stored_TYPE = /obj/item/clothing/mask/breath
	var/mask_amount

	var/list/obj/item/clothing/shoes/boots = list()
	var/boots_stored_TYPE = /obj/item/clothing/shoes/boots/jackboots
	var/boots_amount

	var/starting_amount = 5
	var/max_amount = 10

/obj/machinery/suit_storage_closet/Initialize(mapload, newdir)
	for(var/i=1;i < starting_amount; i++)
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

/obj/machinery/suit_storage_unit/power_change()
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
	else
		//Todo: add lockdown

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
		if(2.0)
			if(prob(50))
				dump_everything()
				qdel(src)

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	ui_interact(user)

/obj/machinery/suit_storage_unit/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/suit_storage_unit/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuitStorageUnit", name)
		ui.open()


/obj/machinery/suit_storage_closet/ui_data()
	return ..()

/obj/machinery/suit_storage_unit/ui_act(action, params)
	return ..()

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
		return

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
