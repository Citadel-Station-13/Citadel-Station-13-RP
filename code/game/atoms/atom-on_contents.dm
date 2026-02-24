//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * called when an /obj/item Initialize()s in us.
 */
/atom/proc/on_contents_item_new(obj/item/item)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/atom/proc/on_contents_weight_change(atom/movable/entity, old_weight, new_weight)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/atom/proc/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/atom/proc/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
