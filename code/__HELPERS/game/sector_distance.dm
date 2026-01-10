//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Checks if two entities are on in the same map.
 * * Levels in the same `map` (usually the case for levels in the same overmap sector) are considered on the same map.
 * * If levels are not in a map struct, they must be the same level.
 * * This does **not** work on overmap entity objects.
 *
 * returns TRUE if same sector, FALSE otherwise
 */
/proc/is_same_map(atom/A, atom/B)
	var/Z_A = get_z(A)
	var/Z_B = get_z(B)
	if(!Z_A || !Z_B)
		return FALSE
	if(Z_A == Z_B)
		return TRUE
	// not same level, check if same map
	return SSmapping.ordered_levels[Z_A].parent_map == SSmapping.ordered_levels[Z_B].parent_map

/**
 * Checks if two entities are on the same overmap sector
 * * Like `is_same_map(A, B)` but for overmap sectors with multiple maps (very rare) this passes;
 *   use if semantically this should pass if something is on the same planet.
 * * This uses **enclosing** overmap sector; this means shuttles are considered the same sector
 *   as their landed maps!
 * * This does **not** work on overmap entity objects.
 */
/proc/is_same_sector(atom/A, atom/B)
	return SSovermaps.get_enclosing_overmap_entity(A) == SSovermaps.get_enclosing_overmap_entity(B)

/**
 * Gets overmap sector distance in pixels between two entities.
 * * This does **not** work on overmap entity objects.
 * * This uses **enclosing** overmap sector; this means shuttles are considered the same sector
 *   as their landed maps!
 * * This uses bounds_dist(); this means that the distance measured is edge-to-edge, not center-to-center.
 *
 * returns number of pixels; 0 if same sector, INFINITY if unreachable / on a different overmap
 */
/proc/get_atom_sector_dist(atom/A, atom/B)
	var/obj/overmap/entity/O_A = SSovermaps.get_enclosing_overmap_entity(A)
	var/obj/overmap/entity/O_B = SSovermaps.get_enclosing_overmap_entity(B)
	if(O_A == O_B)
		return 0
	else if((O_A.overmap != O_B.overmap) || !O_A.overmap)
		return INFINITY
	return max(0, bounds_dist(O_A, O_B))
