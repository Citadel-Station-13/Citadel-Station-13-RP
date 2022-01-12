//A variant of the suitstorage that can store multiple suits at once
//

/obj/machinery/suit_storage_unit/massive
	name = "Suit Storage Automated Closet"
	desc = "A repurposed automated closet to help manage space and voidsuits. Thank Frag Felix Storage for this gift."
	icon_state = "automatedCloset"
	var/list/obj/item/clothing/suit/space/suits = list()
	SUIT_TYPE = /obj/item/clothing/suit/space
	var/suit_amount
	var/list/obj/item/clothing/head/helmet/space/helmets = list()
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	var/helmet_amount
	var/list/obj/item/clothing/mask/masks = list()
	MASK_TYPE = /obj/item/clothing/mask/breath
	var/mask_amount
	var/list/obj/item/clothing/shoes/boots = list()
	BOOT_TYPE = /obj/item/clothing/shoes/boots/jackboots
	var/boots_amount

	var/starting_amount = 5
	var/max_amount = 10

/obj/machinery/suit_storage_unit/massive/Initialize(mapload, newdir)
	for(i=1;i < starting_amount; i++)
		LAZYADD(suits, SUIT_TYPE.new())
		LAZYADD(helmets, HELMET_TYPE.new())
		LAZYADD(masks, MASK_TYPE.new())
		LAZYADD(boots, BOOT_TYPE.new())

	update_amounts()
	update_icon()

/obj/machinery/suit_storage_unit/massive/proc/update_amounts()
	suit_amount = LAZYLEN(suits)
	helmet_amount = LAZYLEN(helmets)
	mask_amount = LAZYLEN(masks)
	boots_amount = LAZYLEN(boots)
