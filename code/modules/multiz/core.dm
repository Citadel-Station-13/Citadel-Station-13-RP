//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * This is the basic get multiz step.
 * It will not look across lateral transitions, only up/down.
 */
/proc/get_vertical_step(atom/A, dir)
	return get_turf(A)?.vertical_step(dir)

/**
 * Basic multiz get dir
 * Will not look across lateral transitions, only directly up/down.
 */
/proc/get_vertical_dir(atom/A, atom/B)
	return get_turf(A)?.vertical_dir(get_turf(B))

/**
 * This is the full get multiz step.
 * It will look across lateral transitions and other struct magic.
 */
/proc/get_virtual_step(atom/A, dir)
	return get_turf(A)?.virtual_step(dir)
