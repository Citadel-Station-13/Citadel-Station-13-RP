//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/disk/tech_disk
	name = "tech disk"
	desc = "A disk holding technology, presumably."

/obj/item/disk/tech_disk/proc/get_projected_nodes() as /list
	CRASH("unimplemented proc")

/obj/item/disk/tech_disk/simple
	/// max techweb nodes
	var/node_capacity = 0
	/// nodes held
	/// * lazy list
	var/list/datum/prototype/techweb_node/node_store

	/// shared node context
	VAR_PRIVATE/tmp/datum/techweb_node_context/cached_node_context

	/// cannot copy / move nodes off of this, or add to it
	var/drm_protected = FALSE

/obj/item/disk/tech_disk/simple/get_projected_nodes() as /list
	. = list()
	cached_node_context = update_cached_node_context()
	for(var/k in node_store)
		.[k] = cached_node_context

/obj/item/disk/tech_disk/simple/proc/add_node(datum/prototype/techweb_node/node)
	LAZYDISTINCTADD(node_store, node)
	return TRUE

/obj/item/disk/tech_disk/simple/proc/remove_node(datum/prototype/techweb_node/node)
	LAZYREMOVE(node_store, node)
	return TRUE

/obj/item/disk/tech_disk/simple/proc/has_room(datum/prototype/techweb_node/node)
	return node_capacity > length(node_store)

/obj/item/disk/tech_disk/simple/proc/has_node(datum/prototype/techweb_node/node)
	return node in node_store

#warn update signal

/obj/item/disk/tech_disk/simple/proc/update_cached_node_context()
	if(!cached_node_context)
		cached_node_context = new
	. = cached_node_context
	cached_node_context.drm_protected = drm_protected

/datum/techweb_node_context/tech_disk
