//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * **USE AT YOUR OWN PERIL**
 */
/datum/object_system/storage/proc/indirect(atom/where)
	ASSERT(isnull(indirection))
	indirection = new(where, src)

/**
 * remove indirection by obliterating contents
 */
/datum/object_system/storage/proc/destructively_remove_indirection()
	QDEL_NULL(indirection)

/**
 * remove indirection by moving contents
 */
/datum/object_system/storage/proc/relocate_remove_indirection(atom/where_to)
	ASSERT(!isnull(where_to) && where_to != indirection)
	for(var/atom/movable/AM as anything in indirection)
		AM.forceMove(where_to)
	QDEL_NULL(indirection)

/**
 * move indirection somewhere else
 */
/datum/object_system/storage/proc/move_indirection_to(atom/where_to)
	indirection.forceMove(where_to)
