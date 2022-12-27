/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Cash Bag
 *		Chemistry Bag
 		Food Bag

 *	-Sayu
 */

//  Generic non-item
/obj/item/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 0 // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = 1
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/bag/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..()
	if(.) update_w_class()

/obj/item/storage/bag/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..()
	if(.) update_w_class()

/obj/item/storage/bag/can_be_inserted(obj/item/W, stop_messages = 0)
	var/mob/living/carbon/human/H = usr // if we're human, then we need to check if bag in a pocket
	if(istype(src.loc, /obj/item/storage) || ishuman(H) && (H.l_store == src || H.r_store == src))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("Take \the [src] out of [istype(src.loc, /obj) ? "\the [src.loc]" : "the pocket"] first."))
		return 0 //causes problems if the bag expands and becomes larger than src.loc can hold, so disallow it
	. = ..()

/obj/item/storage/bag/proc/update_w_class()
	w_class = initial(w_class)
	for(var/obj/item/I in contents)
		w_class = max(w_class, I.w_class)

	var/cur_storage_space = storage_space_used()
	while((max_storage_space / 5 * (w_class-1)) < cur_storage_space)
		w_class++

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "trashbag", SLOT_ID_LEFT_HAND = "trashbag")
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_SMALL * 21
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear)

/obj/item/storage/bag/trash/update_w_class()
	..()
	update_icon()
	switch(w_class)
		if(2) icon_state = "[initial(icon_state)]"
		if(3) icon_state = "[initial(icon_state)]1"
		if(4) icon_state = "[initial(icon_state)]2"
		if(5 to INFINITY) icon_state = "[initial(icon_state)]3"

/obj/item/storage/bag/trash/bluespace
	name = "trash bag of holding"
	max_w_class = ITEMSIZE_HUGE
	max_storage_space = ITEMSIZE_SMALL * 56
	desc = "The latest and greatest in custodial convenience, a trashbag that is capable of holding vast quantities of garbage."
	icon_state = "bluetrashbag"

/obj/item/storage/bag/trash/bluespace/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage/backpack/holding) || istype(W, /obj/item/storage/bag/trash/bluespace))
		to_chat(user, "<span class='warning'>The Bluespace interfaces of the two devices conflict and malfunction.</span>")
		qdel(W)
		return 1
	return ..()

// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_SMALL
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear)

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	name = "plant bag"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown)

/obj/item/storage/bag/plants/large
	name = "large plant bag"
	w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_NORMAL * 45

// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/storage/bag/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = ITEMSIZE_NORMAL
	storage_slots = 7

	allow_quick_empty = 1 // this function is superceded

/obj/item/storage/bag/sheetsnatcher/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W,/obj/item/stack/material))
		if(!stop_messages)
			to_chat(usr, "The snatcher does not accept [W].")
		return 0
	var/current = 0
	for(var/obj/item/stack/material/S in contents)
		current += S.amount
	if(capacity == current)//If it's full, you're done
		if(!stop_messages)
			to_chat(usr, "<span class='warning'>The snatcher is full.</span>")
		return 0
	return 1


// Modified handle_item_insertion.  Would prefer not to, but...
/obj/item/storage/bag/sheetsnatcher/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	var/amount
	var/inserted = 0
	var/current = 0
	for(var/obj/item/stack/material/S2 in contents)
		current += S2.amount
	if(capacity < current + S.amount)//If the stack will fill it up
		amount = capacity - current
	else
		amount = S.amount

	for(var/obj/item/stack/material/sheet in contents)
		if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
			sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
			S.amount -= amount
			inserted = 1
			break

	if(!inserted || !S.amount)
		if(!S.amount)
			qdel(S)
		else
			S.forceMove(src)

	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()
	return 1

// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
/obj/item/storage/bag/sheetsnatcher/orient2hud(mob/user as mob)
	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/stack/material/I in contents)
			adjusted_contents++
			var/datum/numbered_display/D = new/datum/numbered_display(I)
			D.number = I.amount
			numbered_contents.Add( D )

	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	src.slot_orient_objs(row_num, col_count, numbered_contents)
	return

// Modified quick_empty verb drops appropriate sized stacks
/obj/item/storage/bag/sheetsnatcher/quick_empty()
	var/location = get_turf(src)
	for(var/obj/item/stack/material/S in contents)
		while(S.amount)
			var/obj/item/stack/material/N = new S.type(location)
			var/stacksize = min(S.amount,N.max_amount)
			N.amount = stacksize
			S.amount -= stacksize
			N.update_icon()
		if(!S.amount)
			qdel(S) // todo: there's probably something missing here
	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()

// Instead of removing
/obj/item/storage/bag/sheetsnatcher/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	//I would prefer to drop a new stack, but the item/attack_hand code
	// that calls this can't recieve a different object than you clicked on.
	//Therefore, make a new stack internally that has the remainder.
	// -Sayu

	if(S.amount > S.max_amount)
		var/obj/item/stack/material/temp = new S.type(src)
		temp.amount = S.amount - S.max_amount
		S.amount = S.max_amount

	return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/storage/bag/cash
	name = "cash bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/coin,/obj/item/spacecash)

	// -----------------------------
	//           Chemistry Bag
	// -----------------------------
/obj/item/storage/bag/chemistry
	name = "chemistry bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "chembag"
	desc = "A bag for storing pills, patches, and bottles."
	max_storage_space = 200
	w_class = ITEMSIZE_LARGE
	slowdown = 1
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/glass/bottle)

	// -----------------------------
	//           Food Bag
	// -----------------------------
/obj/item/storage/bag/food
	name = "food bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing foods of all kinds."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks,/obj/item/reagent_containers/food/condiment)

	// -----------------------------
	//           Evidence Bag
	// -----------------------------
/obj/item/storage/bag/detective
	name = "secure satchel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "detbag"
	desc = "A bag for storing investigation things. You know, securely."
	max_storage_space = ITEMSIZE_COST_NORMAL * 15
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/forensics/swab,/obj/item/sample/print,/obj/item/sample/fibers,/obj/item/evidencebag)

/obj/item/storage/bag/dogborg
	name = "dog bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing things of all kinds."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks,/obj/item/reagent_containers/food/condiment,
	/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/glass/bottle,/obj/item/coin,/obj/item/spacecash,
	/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown,/obj/item/reagent_containers/pill)
