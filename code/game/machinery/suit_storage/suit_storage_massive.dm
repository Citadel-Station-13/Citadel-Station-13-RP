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
