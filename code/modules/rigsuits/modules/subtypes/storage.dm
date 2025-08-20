//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/storage
	/// are we a primary storage module? if so, a rig can only have one of us,
	/// and clicking on the back / trying to insert stuff into the back uses us.
	/// * primary storage modules cannot be locked from a wearer.
	var/is_primary_storage = FALSE

	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	var/list/storage_starts_with
	/// set to prevent us from spawning starts_with
	var/storage_empty = FALSE

	var/list/storage_insertion_whitelist
	var/list/storage_insertion_blacklist
	var/list/storage_insertion_allow

	var/storage_max_single_weight_class = WEIGHT_CLASS_NORMAL
	var/storage_max_combined_weight_class
	var/storage_max_combined_volume = WEIGHT_VOLUME_NORMAL * 7
	var/storage_max_items

	var/storage_weight_subtract = 0
	var/storage_weight_multiply = 1

	var/storage_allow_quick_empty = TRUE
	var/storage_allow_quick_empty_via_clickdrag = TRUE
	var/storage_allow_quick_empty_via_attack_self = FALSE

	var/storage_sfx_open = "rustle"
	var/storage_sfx_insert = "rustle"
	var/storage_sfx_remove = "rustle"

	var/storage_ui_numerical_mode = FALSE

/obj/item/rig_module/storage/Initialize(mapload)
	. = ..()
	initialize_storage()
	spawn_storage_contents()

/obj/item/rig_module/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	init_storage(storage_datum_path, indirected = TRUE)

	obj_storage.set_insertion_allow(storage_insertion_allow)
	obj_storage.set_insertion_whitelist(storage_insertion_whitelist)
	obj_storage.set_insertion_blacklist(storage_insertion_blacklist)

	obj_storage.max_single_weight_class = storage_max_single_weight_class
	obj_storage.max_combined_weight_class = storage_max_combined_weight_class
	obj_storage.max_combined_volume = storage_max_combined_volume
	obj_storage.max_items = storage_max_items

	obj_storage.weight_subtract = storage_weight_subtract
	obj_storage.weight_multiply = storage_weight_multiply

	obj_storage.allow_quick_empty = storage_allow_quick_empty
	obj_storage.allow_quick_empty_via_clickdrag = storage_allow_quick_empty_via_clickdrag
	obj_storage.allow_quick_empty_via_attack_self = storage_allow_quick_empty_via_attack_self

	obj_storage.sfx_open = storage_sfx_open
	obj_storage.sfx_insert = storage_sfx_insert
	obj_storage.sfx_remove = storage_sfx_remove

	obj_storage.ui_numerical_mode = storage_ui_numerical_mode

/obj/item/hardsuit/proc/spawn_storage_contents()
	if(length(storage_starts_with) && !storage_empty)
		// this is way too permissive already
		var/safety = 256
		var/atom/where_real_contents = obj_storage.real_contents_loc()
		for(var/path in storage_starts_with)
			var/amount = storage_starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(where_real_contents)
	storage_starts_with = null

/obj/item/rig_module/storage/on_install(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	. = ..()

/obj/item/rig_module/storage/on_uninstall(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	. = ..()

/obj/item/rig_module/storage/is_valid_install(obj/item/rig/rig, datum/event_args/actor/actor, silent)
	. = ..()
	if(!.)
		return
	if(is_primary_storage)
		for(var/obj/item/rig_module/storage/storage_module in rig.get_modules())
			if(storage_module.is_primary_storage)
				if(!silent)
					actor?.chat_feedback(
						SPAN_WARNING("[rig] already has a primary storage module."),
						target = src,
					)
				return FALSE

#warn impl all
