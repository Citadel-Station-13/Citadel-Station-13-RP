//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/on_contents_item_new(obj/item/item)
	. = ..()
	if(!isnull(obj_storage?.indirection))
		return
	obj_storage?.on_contents_item_new(item)

/obj/on_contents_weight_change(atom/movable/entity, old_weight, new_weight)
	..()
	if(!isnull(obj_storage?.indirection))
		return
	obj_storage?.on_contents_weight_change(entity, old_weight, new_weight)

/obj/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	. = ..()
	if(!isnull(obj_storage?.indirection))
		return
	obj_storage?.on_contents_weight_class_change(item, old_weight_class, new_weight_class)

/obj/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	. = ..()
	if(!isnull(obj_storage?.indirection))
		return
	obj_storage?.on_contents_weight_volume_change(item, old_weight_volume, new_weight_volume)
