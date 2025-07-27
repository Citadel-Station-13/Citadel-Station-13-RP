//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/disk/design_disk
	name = "design disk"
	desc = "A disk holding fabricator designs."

	/// max designs
	var/design_capacity = 0
	/// designs held
	/// * lazy list
	var/list/datum/prototype/design/design_store

	/// cannot copy / move designs off of this
	var/drm_protected = FALSE

#warn impl
