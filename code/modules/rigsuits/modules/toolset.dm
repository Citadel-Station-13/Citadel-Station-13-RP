//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Root subtype of toolset modules
 *
 * Toolset modules allow for deploying a set of items in hand.
 * Said items work with item mounts/energy draw/etc.
 */
/obj/item/rig_module/toolset
	abstract_type = /obj/item/rig_module/toolset

	/// list of items; set to a list of typepaths to init.
	var/list/obj/item/items = list()

#warn impl all
