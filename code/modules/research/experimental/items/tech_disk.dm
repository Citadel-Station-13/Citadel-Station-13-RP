//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/disk/tech_disk
	name = "tech disk"
	desc = "A disk holding technology, presumably."

	/// max techweb nodes
	var/node_capacity = 0
	/// nodes held
	/// * lazy list
	var/list/datum/prototype/techweb_node/node_store

	/// cannot copy / move nodes off of this
	var/drm_protected = FALSE

#warn impl
