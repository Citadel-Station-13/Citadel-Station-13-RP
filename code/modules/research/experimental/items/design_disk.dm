//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/disk/design_disk
	name = "design disk"
	desc = "A disk holding fabricator designs."

/obj/item/disk/design_disk/proc/get_projected_designs() as /list
	return list()

/**
 * You **must** call this when modifying the disk's contents.
 */
/obj/item/disk/design_disk/proc/notify_listeners_of_update(list/datum/prototype/design/added = list(), list/datum/prototype/design/removed = list())
	SEND_SIGNAL(src, COMSIG_DISK_DESIGNDISK_MODIFIED, added, removed)

/obj/item/disk/design_disk/basic
	/// max designs
	var/design_capacity = 0
	/// designs held
	/// * lazy list
	/// * associate to design contexts
	var/list/datum/prototype/design/design_store

	/// shared node context
	VAR_PRIVATE/tmp/datum/design_context/cached_design_context

	/// cannot copy / move designs off of this
	var/drm_protected = FALSE

/obj/item/disk/design_disk/basic/proc/add_design(datum/prototype/design/design)
	if(design in design_store)
		return TRUE
	LAZYADD(design_store, design)
	notify_listeners_of_update(added = list(design))
	return TRUE

/obj/item/disk/design_disk/basic/proc/remove_design(datum/prototype/design/design)
	if(!(design in design_store))
		return TRUE
	LAZYREMOVE(design_store, design)
	notify_listeners_of_update(removed = list(design))
	return TRUE

/obj/item/disk/design_disk/basic/proc/has_room(datum/prototype/design/design)
	return design_capacity > length(design_store)

/obj/item/disk/design_disk/basic/proc/has_design(datum/prototype/design/design)
	return design in design_store

/obj/item/disk/design_disk/basic/proc/update_cached_design_context()
	if(!cached_design_context)
		cached_design_context = new
	. = cached_design_context
	cached_design_context.drm_protected = drm_protected

/datum/techweb_design_context/design_disk
