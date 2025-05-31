//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Called when a supply export is first enumerating us.
 *
 * This lets us register in its lists as necessary.
 *
 * * If overriding, be mindful that returning ..() is often not sound behavior,
 *   as the default behavior is to throw us in the leftover bin!
 */
/atom/movable/proc/supply_export_enumerate(datum/supply_export/export)
	export.entities_leftover += src

/**
 * Checks if we're a supply container, or if we should be exported as-is.
 *
 * Containers will be exported with themselves and their contents.
 */
/atom/movable/proc/supply_export_is_container()
	return FALSE

/**
 * Checks if supply exporting should recurse inside.
 *
 * * This is not the same as is-container; a container is a logical export split.
 *   This is just allowing our contents to be discovered.
 * * It is undefined behavaior to return contents that are either not actually inside us (we hold the sole reference),
 *   or to return ourselves as part of this. Don't do it.
 *
 * @return entities inside to export, as a list
 */
/atom/movable/proc/supply_export_recurse()
	return null
