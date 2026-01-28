//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Checks if we should probably be considered as the bottom baseturf.
 * * Used to heuristucally check if something should PlaceOnTop or ChangeTurf, as they have
 *   different implications.
 */
/turf/proc/is_probably_baseturf_bottom()
	return length(baseturfs) <= 1

/**
 * A very niche proc. Puts a baseturf into baseturfs above the 'core' baseturf,
 * but only if it doesn't exist.
 * * Used by orbital deployment zones to mark the part that should be yeeted.
 * @return FALSE if already exists, TRUE if placed.
 */
/turf/proc/insert_baseturf_above_root_if_not_exists(baseturf_path)
	if(islist(baseturfs))
		if(baseturf_path in baseturfs)
			return FALSE
		if(!length(baseturfs))
			// should not be possible
			CRASH("found empty baseturfs list; how?")
		// baseturfs may be a cached list
		baseturfs = baseturfs.Copy()
		baseturfs.Insert(2, baseturf_path)
		return TRUE
	else
		if(baseturfs == baseturf_path)
			return FALSE
		// we assume the bottom baseturf is the root. this is actually sorta enforced
		// by assemble_baseturfs, but..
		baseturfs = list(baseturfs, baseturf_path)
		return TRUE
