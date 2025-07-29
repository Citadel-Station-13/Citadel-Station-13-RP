//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/disk/design_disk
	name = "design disk"
	desc = "A disk holding fabricator designs."

/obj/item/disk/design_disk/proc/get_projected_designs() as /list

/obj/item/disk/design_disk/basic
	/// max designs
	var/design_capacity = 0
	/// designs held
	/// * lazy list
	/// * associate to design contexts
	var/list/datum/prototype/design/design_store

	/// shared node context
	VAR_PRIVATE/tmp/datum/techweb_design_context/cached_design

	/// cannot copy / move designs off of this
	var/drm_protected = FALSE

/obj/item/disk/design_disk/basic/proc/add_design(datum/prototype/design/design)
	LAZYDISTINCTADD(design_store, design)
	return TRUE

/obj/item/disk/design_disk/basic/proc/remove_design(datum/prototype/design/design)
	LAZYREMOVE(design_store, design)
	return TRUE

/obj/item/disk/design_disk/basic/proc/has_room(datum/prototype/design/design)
	return design_capacity > length(design_store)

/obj/item/disk/design_disk/basic/proc/has_design(datum/prototype/design/design)
	return design in design_store

#warn update signal

#warn impl

/obj/item/disk/design_disk/simple/proc/update_cached_design_context()
	if(!cached_design_context)
		cached_design_context = new
	. = cached_design_context
	cached_design_context.drm_protected = drm_protected

/datum/techweb_design_context/design_disk
