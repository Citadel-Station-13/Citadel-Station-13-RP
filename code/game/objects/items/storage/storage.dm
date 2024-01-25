/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	w_class = WEIGHT_CLASS_NORMAL
	show_messages = 1

	//* Directly passed to storage system. *//

	var/list/insertion_whitelist
	var/list/insertion_blacklist
	var/list/insertion_allow

	var/max_single_weight_class = WEIGHT_CLASS_SMALL
	var/max_combined_weight_class
	var/max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	var/max_items

	var/weight_subtract = 0
	var/weight_multiply = 1

	var/allow_mass_gather = FALSE
	var/allow_mass_gather_mode_switch = TRUE
	var/mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL

	var/allow_quick_empty = FALSE
	var/allow_quick_empty_via_clickdrag = TRUE
	var/allow_quick_empty_via_attack_self = TRUE

	var/sfx_open = "rustle"
	var/sfx_insert = "rustle"
	var/sfx_remove = "rustle"

	var/ui_numerical_mode = FALSE

	//* Initialization *//

	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	var/list/starts_with
	/// set to prevent us from spawning starts_with
	var/empty = FALSE

/obj/item/storage/Initialize(mapload)
	. = ..()
	initialize_storage()
	spawn_contents()
	legacy_spawn_contents()

/**
 * Make sure to set [worth_dynamic] to TRUE if this does more than spawning what's in starts_with.
 */
/obj/item/storage/proc/spawn_contents()
	if(length(starts_with) && !empty)
		// this is way too permissive already
		var/safety = 256
		for(var/path in starts_with)
			var/amount = starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(src)
	starts_with = null

/**
 * Please get rid of this in favor of spawn_contents() and starts_with
 */
/obj/item/storage/proc/legacy_spawn_contents()
	return

/obj/item/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	obj_storage = new(src)
	obj_storage.set_insertion_allow(insertion_allow)
	obj_storage.set_insertion_whitelist(insertion_whitelist)
	obj_storage.set_insertion_blacklist(insertion_blacklist)

	obj_storage.max_single_weight_class = max_single_weight_class
	obj_storage.max_combined_weight_class = max_combined_weight_class
	obj_storage.max_combined_volume = max_combined_volume
	obj_storage.max_items = max_items

	obj_storage.weight_subtract = weight_subtract
	obj_storage.weight_multiply = weight_multiply

	obj_storage.allow_mass_gather = allow_mass_gather
	obj_storage.allow_mass_gather_mode_switch = allow_mass_gather_mode_switch
	obj_storage.mass_gather_mode = mass_gather_mode

	obj_storage.sfx_open = sfx_open
	obj_storage.sfx_insert = sfx_insert
	obj_storage.sfx_remove = sfx_remove

	obj_storage.ui_numerical_mode = ui_numerical_mode

#warn below

/obj/item/storage/Initialize(mapload)
	. = ..()
	reset_weight()

/obj/item/storage/get_weight()
	. = ..()
	. += max(0, (weight_cached * weight_multiply) - weight_subtract)

/obj/item/storage/proc/reset_weight()
	var/old_weight_cached = weight_cached
	weight_cached = 0
	for(var/obj/item/I in contents)
		weight_cached += I.get_weight()
	propagate_weight(old_weight_cached, weight_cached)
	update_weight()

/obj/item/storage/proc/stored_weight_changed(obj/item/I, old_weight, new_weight)
	var/diff = new_weight - old_weight
	var/old = weight_cached
	weight_cached += diff
	propagate_weight(old, weight_cached)

/obj/item/storage/proc/reset_weight_recursive()
	do_reset_weight_recursive(200)

/obj/item/storage/proc/do_reset_weight_recursive(safety)
	if(!(safety - 1))
		CRASH("out of safety")
	for(var/obj/item/storage/S in contents)
		S.do_reset_weight_recursive(safety - 1)
	reset_weight()

/obj/item/storage/OnMouseDrop(atom/over, mob/user, proximity, params)
	if(user != over)
		return ..()
	if(user in is_seeing)
		close(user)
	else if(isliving(user) && user.Reachability(src))
		open(user)
	else

/obj/item/storage/proc/__handle_item_insertion(obj/item/W as obj, mob/user, prevent_warning = 0)
	var/old_weight = weight_cached
	weight_cached += W.get_weight()
	propagate_weight(old_weight, weight_cached)

/obj/item/storage/proc/__remove_from_storage(obj/item/W as obj, atom/new_location, do_move = TRUE)
	var/old_weight = weight_cached
	weight_cached -= W.get_weight()
	propagate_weight(old_weight, weight_cached)

/*
 * Trinket Box - READDING SOON
 */
/obj/item/storage/trinketbox
	name = "trinket box"
	desc = "A box that can hold small trinkets, such as a ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "trinketbox"
	var/open = 0
	max_items = 1
	insertion_whitelist = list(
		/obj/item/clothing/gloves/ring,
		/obj/item/coin,
		/obj/item/clothing/accessory/medal
		)
	var/open_state
	var/closed_state

/obj/item/storage/trinketbox/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state

		if(contents.len >= 1)
			var/contained_image = null
			if(istype(contents[1],  /obj/item/clothing/gloves/ring))
				contained_image = "ring_trinket"
			else if(istype(contents[1], /obj/item/coin))
				contained_image = "coin_trinket"
			else if(istype(contents[1], /obj/item/clothing/accessory/medal))
				contained_image = "medal_trinket"
			if(contained_image)
				add_overlay(contained_image)
	else
		icon_state = closed_state

/obj/item/storage/trinketbox/Initialize(mapload)
	if(!open_state)
		open_state = "[initial(icon_state)]_open"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	. = ..()

/obj/item/storage/trinketbox/attack_self(mob/user)
	. = ..()
	if(.)
		return
	open = !open
	update_icon()
	..()

/obj/item/storage/trinketbox/examine(mob/user, dist)
	. = ..()
	if(open && contents.len)
		var/display_item = contents[1]
		. += "<span class='notice'>\The [src] contains \the [display_item]!</span>"

/obj/item/storage/AllowDrop()
	return TRUE

/obj/item/storage/clean_radiation(str, mul, cheap)
	. = ..()
	if(cheap)
		return
	for(var/atom/A as anything in contents)
		A.clean_radiation(str, mul, cheap)

/obj/item/storage/drop_products(method, atom/where)
	. = ..()
	for(var/atom/movable/AM as anything in contents)
		AM.forceMove(where)
