//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/atom/movable/storage_indirection
	atom_flags = ATOM_ABSTRACT

	/// owner
	var/datum/object_system/storage/parent

/atom/movable/storage_indirection/Initialize(mapload, datum/object_system/storage/parent)
	src.parent = parent
	return ..()

/atom/movable/storage_indirection/Destroy()
	if(src.parent.indirection == src)
		src.parent.indirection = null
	src.parent = null
	return ..()

/atom/movable/storage_indirection/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return TRUE

/atom/movable/storage_indirection/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return TRUE

/atom/movable/storage_indirection/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(isitem(AM))
		parent.on_item_exited(AM)

/atom/movable/storage_indirection/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isitem(AM))
		parent.on_item_entered(AM)

/atom/movable/storage_indirection/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	parent.on_contents_weight_class_change(item, old_weight_class, new_weight_class)

/atom/movable/storage_indirection/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	parent.on_contents_weight_volume_change(item, old_weight_volume, new_weight_volume)

/atom/movable/storage_indirection/on_contents_weight_change(obj/item/item, old_weight, new_weight)
	parent.on_contents_weight_change(item, old_weight, new_weight)

/atom/movable/storage_indirection/on_contents_item_new(obj/item/item)
	parent.on_contents_item_new(item)
