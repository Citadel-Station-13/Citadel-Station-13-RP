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
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	allow_mass_gather = TRUE
	allow_quick_empty = TRUE

	var/auto_fit_weight_class_to_largest_contained = TRUE

/obj/item/storage/bag/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!isitem(AM))
		return
	refit_to(AM)

/obj/item/storage/bag/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(!isitem(AM))
		return
	refit_to(AM, TRUE)

/obj/item/storage/bag/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	refit_to(item, TRUE)
	return ..()

/obj/item/storage/bag/proc/refit_to(obj/item/thing, removing)
	var/their_weight_class = thing.get_weight_class()
	if(!removing)
		if(their_weight_class <= w_class)
			return
		else
			set_weight_class(their_weight_class)
	else
		if(their_weight_class < w_class)
			return
		else
			var/staged = initial(w_class)
			for(var/obj/item/contained in src)
				staged = max(staged, contained.get_weight_class())
			set_weight_class(staged)

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

	w_class = WEIGHT_CLASS_SMALL
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_CLASS_SMALL * 21
	insertion_whitelist = list() // any
	insertion_blacklist = list(/obj/item/disk/nuclear)

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
	max_single_weight_class = WEIGHT_CLASS_HUGE
	max_combined_volume = WEIGHT_CLASS_SMALL * 56
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

	w_class = WEIGHT_CLASS_BULKY
	max_single_weight_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list() // any
	insertion_blacklist = list(/obj/item/disk/nuclear)

// -----------------------------
//        Mining Satchel
// -----------------------------
/*
 * Mechoid - Orebags are the most common quick-gathering thing, and also have tons of lag associated with it. Their checks are going to be hyper-simplified due to this, and their INCREDIBLY singular target contents.
 * this now functions like an ore box, but limited capacity. - Blubelle
 */

/obj/item/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 25 //kinda irrelevant now :^)
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	storage_datum_path = /datum/object_system/storage/stack
	insertion_whitelist = list(/obj/item/stack/ore)
	var/stored_ore = list()
	var/total_ore = 0 //current ore stored
	var/max_ore = 300 //how much ore it can hold
	var/last_update = 0

/obj/item/storage/bag/ore/update_w_class()
	return

/obj/item/storage/bag/ore/gather_all(turf/T as turf, mob/user as mob, var/silent = 0)
	var/success = 0
	var/failure = 0
	for(var/obj/item/stack/ore/I in T) //Only ever grabs ores. Doesn't do any extraneous checks, as all ore is the same size. Tons of checks means it causes hanging for up to three seconds.
		if(istype(user.pulling, /obj/structure/ore_box))
			var/obj/structure/ore_box/O = user.pulling
			I.forceMove(O)
			if(world.time < last_message && !silent)
				to_chat(user, "<span class='notice'>You put the contents you scooped up into [O].</span>")
				last_message = world.time + 10
		else if(total_ore >= max_ore || contents.len >= max_combined_volume)
			failure = 1
			break
		else
			I.forceMove(src)
			success = 1
	if(success && !failure && !silent)
		if(world.time < last_message == 0)
			to_chat(user, "<span class='notice'>You put everything in [src].</span>")
			last_message = world.time + 10
	else if (success && (!silent || total_ore >= max_ore))
		to_chat(user, "<span class='notice'>You fill the [src].</span>")
		last_message = world.time + 10
	else if(!silent)
		if(world.time >= last_message == 0)
			to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")
			last_message = world.time + 90

/obj/item/storage/bag/ore/equipped(mob/user, slot, flags)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(autoload), override = TRUE)

/obj/item/storage/bag/ore/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/storage/bag/ore/proc/autoload(datum/source, atom/oldLoc, dir, forced)
	var/obj/item/stack/ore/O = locate() in get_turf(src)
	if(O)
		gather_all(get_turf(src), ismob(source)? source : null)

/obj/item/storage/bag/ore/attack_self(mob/user)
	. = ..()

	if(isOreEmpty())
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return

	to_chat(user, SPAN_NOTICE("You begin emptying [src]."))

	if(do_after(usr,10,src))
		while(!isOreEmpty())
			if(!do_after(user, 2, src))
				to_chat(user,SPAN_NOTICE("You stop emptying [src]."))
				return
			var/atom/A = drop_location()
			if(!A || (length(A.contents) > 200))
				to_chat(user, SPAN_WARNING("The area under [src] is too full."))
				return
			deposit(A,50)
		to_chat(user,SPAN_NOTICE("You finish emptying [src]."))

/obj/item/storage/bag/ore/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(istype(AM, /obj/item/stack/ore))
		take(AM)
	else //shouldn't be possible unless someone's adminbussing weirdly.
		AM.forceMove(drop_location())

/obj/item/storage/bag/ore/drop_products(method, atom/where)
	. = ..()
	var/i = 0
	while(!isOreEmpty() && i < 200) //may be laggy as hell if they're carrying 2,000+ sand, so capping it at 200 items dropped.
		deposit(where, 50)
		i++

/obj/item/storage/bag/ore/proc/take(obj/item/stack/ore/O)
	if(!istype(O))
		return FALSE
	var/overflow = max((total_ore + O.amount) - max_ore, 0)
	var/store_amount = O.amount - overflow

	if(!stored_ore[O.type])
		stored_ore[O.type] = store_amount
	else
		stored_ore[O.type] += store_amount
	total_ore += O.amount

	if(overflow)
		O.use(store_amount)
		O.forceMove(drop_location())
		return FALSE
	else
		qdel(O)
		return TRUE

/obj/item/storage/bag/ore/proc/deposit(atom/newloc, amount = 50)
	if(isOreEmpty())
		return FALSE
	var/path = stored_ore[1]
	if(amount > stored_ore[path])
		amount = stored_ore[path]
	new path(newloc, amount)
	stored_ore[path] -= amount
	total_ore -= amount
	if(stored_ore[path] <= 0)
		stored_ore -= path
	return TRUE

/obj/item/storage/bag/ore/proc/isOreEmpty()
	return !length(stored_ore)

/obj/item/storage/bag/ore/examine(mob/user, dist)
	. = ..()
	if(!Adjacent(user)) //Can only check the contents of ore bags if you can physically reach them.
		return
	if(istype(user, /mob/living))
		add_fingerprint(user)
	if(isOreEmpty())
		. += "It is empty."
		return

	if(world.time > last_update + 10)
		last_update = world.time

	. += "<span class='notice'>It holds:</span>"
	for(var/ore in stored_ore)
		var/obj/item/stack/ore/O = ore
		. += "<span class='notice'>- [stored_ore[ore]] [initial(O.name)]</span>"

/obj/item/storage/bag/ore/open(mob/user as mob) //No opening it since the ores are nonexistent
	user.do_examinate(src)

//Ashlander variant!
/obj/item/storage/bag/ore/ashlander
	name = "goliath hide mining satchel"
	desc = "This hide bag can be used to store and transport ores."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "golisatchel"

//Bluespace.
/obj/item/storage/bag/ore/bluespace
	name = "mining satchel of holding"
	desc = "This advanced spacious storage efficiently stores and transports ores using bluespace technology. It's like having an ore box latched onto your pocket!"
	icon_state = "satchel_bspace"
	max_ore = SHORT_REAL_LIMIT //if someone manages to reach 16+ million ores in a single 5 hour round, they'd have to be something else.


// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	name = "plant bag"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 25
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown)

/obj/item/storage/bag/plants/large
	name = "large plant bag"
	w_class = WEIGHT_CLASS_SMALL
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 45

/obj/item/storage/bag/plants/ashlander
	name = "goliath hide plant bag"
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "golisatchel_plant"

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

	w_class = WEIGHT_CLASS_NORMAL

	storage_datum_path = /datum/object_system/storage/stack
	max_items = 300
	allow_quick_empty = TRUE
	allow_mass_gather = TRUE
	allow_mass_gather_mode_switch = FALSE

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
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 25
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/coin,/obj/item/spacecash)

	// -----------------------------
	//           Chemistry Bag
	// -----------------------------
/obj/item/storage/bag/chemistry
	name = "chemistry bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "chembag"
	desc = "A bag for storing pills, patches, bottles, and hypovials."
	max_combined_volume = 200
	w_class = WEIGHT_CLASS_BULKY
	insertion_whitelist = list(
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/glass/hypovial,
	)

	// -----------------------------
	//           Xenobiology Bag
	// -----------------------------
/obj/item/storage/bag/xenobio
	name = "xenobiology bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "biobag"
	desc = "A bag for storing slime extracts, slime potions, monkey cubes, and beakers."
	max_combined_volume = 200
	w_class = WEIGHT_CLASS_BULKY
	insertion_whitelist = list(
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/slime_extract,
		/obj/item/slimepotion
	)

	// -----------------------------
	//           Food Bag
	// -----------------------------
/obj/item/storage/bag/food
	name = "food bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing foods of all kinds."
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 25
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/reagent_containers/food/snacks,/obj/item/reagent_containers/food/condiment)

	// -----------------------------
	//           Evidence Bag
	// -----------------------------
/obj/item/storage/bag/detective
	name = "secure satchel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "detbag"
	desc = "A bag for storing investigation things. You know, securely."
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 15
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/forensics/swab,/obj/item/sample/print,/obj/item/sample/fibers,/obj/item/evidencebag)

/obj/item/storage/bag/dogborg
	name = "dog bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing things of all kinds."
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 25
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/reagent_containers/food/snacks,/obj/item/reagent_containers/food/condiment,
	/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/glass/bottle,/obj/item/coin,/obj/item/spacecash,
	/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown,/obj/item/reagent_containers/pill)
