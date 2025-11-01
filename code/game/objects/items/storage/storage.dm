/**
 * ## Paths
 *
 * For an example of `/obj/item/storage/box/gimmicks`,
 * * /obj/item/storage/box/gimmicks should be empty
 * * /obj/item/storage/box/gimmicks/full should have preloaded contents in starts_with / procs
 * * /obj/item/storage/box/gimmicks/full/loaded should have filled containers, as an example, if it's a box of reagents or something.
 */
/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	w_class = WEIGHT_CLASS_NORMAL
	rad_flags = NONE
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

	var/allow_quick_empty = TRUE
	var/allow_quick_empty_via_clickdrag = TRUE
	var/allow_quick_empty_via_attack_self = FALSE

	var/sfx_open = "rustle"
	var/sfx_insert = "rustle"
	var/sfx_remove = "rustle"

	var/ui_numerical_mode = FALSE
	var/ui_expand_when_needed = FALSE
	var/ui_force_slot_mode = FALSE

	//* Initialization *//

	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	//  todo: stack handling
	var/list/starts_with
	/// set to prevent us from spawning starts_with
	var/empty = FALSE

/obj/item/storage/preloading_from_stack_recipe(datum/stack_recipe/recipe)
	..()
	if(recipe.product_auto_create_empty)
		empty = TRUE

/obj/item/storage/Initialize(mapload, empty)
	. = ..()
	initialize_storage()
	if(!empty && !src.empty)
		spawn_contents()
		legacy_spawn_contents()
	else
		starts_with = null

/**
 * Make sure to set [worth_dynamic] to TRUE if this does more than spawning what's in starts_with.
 */
/obj/item/storage/proc/spawn_contents()
	if(length(starts_with))
		// this is way too permissive already
		var/safety = 256
		var/atom/where_real_contents = obj_storage.real_contents_loc()
		for(var/path in starts_with)
			var/amount = starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(where_real_contents)
	starts_with = null

/**
 * Please get rid of this in favor of spawn_contents() and starts_with
 */
/obj/item/storage/proc/legacy_spawn_contents()
	return

/obj/item/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	init_storage(storage_datum_path)
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

	obj_storage.allow_quick_empty = allow_quick_empty
	obj_storage.allow_quick_empty_via_clickdrag = allow_quick_empty_via_clickdrag
	obj_storage.allow_quick_empty_via_attack_self = allow_quick_empty_via_attack_self

	obj_storage.sfx_open = sfx_open
	obj_storage.sfx_insert = sfx_insert
	obj_storage.sfx_remove = sfx_remove

	obj_storage.ui_numerical_mode = ui_numerical_mode
	obj_storage.ui_expand_when_needed = ui_expand_when_needed
	obj_storage.ui_force_slot_mode = ui_force_slot_mode
