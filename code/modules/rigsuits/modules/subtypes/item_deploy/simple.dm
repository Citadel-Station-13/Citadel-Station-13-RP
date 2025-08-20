//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * stores things to deploy
 */
/obj/item/rig_module/item_deploy/simple
	/// stored items
	/// * all items will be item mounted.
	/// * set to list of typepaths or anonymous types to init.
	var/list/obj/item/stored

/obj/item/rig_module/item_deploy/simple/Initialize(mapload)
	. = ..()
	#warn init stored

/obj/item/rig_module/item_deploy/simple/Destroy()
	QDEL_LIST_NULL(stored)
	return ..()

#warn impl
