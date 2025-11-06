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
	allow_quick_empty_via_attack_self = TRUE

	worth_intrinsic = 75

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

/obj/item/storage/bag/trash/initialize_storage()
	. = ..()
	obj_storage.update_icon_on_item_change = TRUE

/obj/item/storage/bag/trash/update_icon_state()
	switch(w_class)
		if(3)
			icon_state = "[initial(icon_state)]1"
		if(4)
			icon_state = "[initial(icon_state)]2"
		if(5 to INFINITY)
			icon_state = "[initial(icon_state)]3"
		else
			icon_state = "[initial(icon_state)]"
	return ..()

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
	max_combined_volume = null
	max_combined_weight_class = null
	max_items = 300
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR
	storage_datum_path = /datum/object_system/storage/stack
	ui_expand_when_needed = TRUE
	insertion_whitelist = list(/obj/item/stack/ore)
	auto_fit_weight_class_to_largest_contained = FALSE

/obj/item/storage/bag/ore/proc/autodump()
	var/mob/living/user = loc
	if(!istype(user))
		return
	if(!istype(user.pulling, /obj/structure/ore_box))
		return
	var/obj/structure/ore_box/box = user.pulling
	for(var/obj/item/stack/ore/ore in src)
		ore.forceMove(box)

/obj/item/storage/bag/ore/equipped(mob/user, slot, flags)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(signal_autoload), override = TRUE)

/obj/item/storage/bag/ore/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/storage/bag/ore/proc/signal_autoload(datum/source, atom/oldLoc, dir, forced)
	// todo: this is weird with SSinput.
	if(TICK_CHECK)
		return // not if we're already overloaded
	var/obj/item/stack/ore/O = locate() in get_turf(source)
	if(isnull(O))
		return
	var/mob/user = get_worn_mob()
	if(isnull(user))
		return
	INVOKE_ASYNC(src, PROC_REF(autoload), user, O)

/obj/item/storage/bag/ore/proc/autoload(mob/user, obj/item/stack/ore/piece_of_ore)
	var/turf/target = piece_of_ore.loc
	var/list/ores = list()
	for(var/obj/item/stack/ore/ore in target)
		ores += ore
	obj_storage?.mass_storage_pickup_handler(ores, target)
	autodump()
	obj_storage?.ui_queue_refresh()

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
	// :omegawheelchair:
	max_items = SHORT_REAL_LIMIT


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
	max_combined_volume = null
	max_combined_weight_class = null
	max_items = 300
	allow_quick_empty = TRUE
	allow_mass_gather = TRUE
	allow_mass_gather_mode_switch = FALSE
	auto_fit_weight_class_to_largest_contained = FALSE
	ui_expand_when_needed = TRUE

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	max_items = 600

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
