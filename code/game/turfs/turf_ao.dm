#ifdef AO_USE_LIGHTING_OPACITY
#define AO_TURF_CHECK(T) (!T.has_opaque_atom || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.has_opaque_atom)
#else
#define AO_TURF_CHECK(T) (!T.density || !T.opacity || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.density && !T.opacity)
#endif

/turf
	var/permit_ao = TRUE
	/// Current ambient occlusion overlays. Tracked so we can reverse them without dropping all priority overlays.
	var/tmp/list/ao_overlays
	var/tmp/ao_neighbors
	var/tmp/list/ao_overlays_mimic
	var/tmp/ao_neighbors_mimic
	var/ao_queued = AO_UPDATE_NONE

/turf/proc/regenerate_ao()
	for (var/thing in RANGE_TURFS(1, src))
		var/turf/T = thing
		if (T?.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/calculate_ao_neighbors()
	ao_neighbors = NONE
	ao_neighbors_mimic = NONE
	if (!permit_ao)
		return

	var/turf/T
	if (mz_flags & MZ_MIMIC_BELOW)
		CALCULATE_NEIGHBORS(src, ao_neighbors_mimic, T, (T.mz_flags & MZ_MIMIC_BELOW))
	if (AO_SELF_CHECK(src) && !(mz_flags & MZ_MIMIC_NO_AO))
		CALCULATE_NEIGHBORS(src, ao_neighbors, T, AO_TURF_CHECK(T))

/proc/make_ao_image(corner, px = 0, py = 0, pz = 0, pw = 0, alpha)
	var/list/cache = SSao.image_cache
	var/cstr = "ao-[corner]"
	// PROCESS_AO below also uses this cache, check it before changing this key.
	var/key = "[cstr]|[px]/[py]/[pz]/[pw]|[alpha]"

	var/image/I = image('icons/turf/flooring/shadows.dmi', cstr)
	I.alpha = alpha
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA|RESET_COLOR|TILE_BOUND
	I.layer = AO_LAYER
	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

#define PROCESS_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA) \
	if (NEIGHBORS != AO_ALL_NEIGHBORS) { \
		var/image/I = cache["ao-[NEIGHBORS]|[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]|[ALPHA]"]; \
		if (!I) { \
			I = make_ao_image(NEIGHBORS, TARGET.pixel_x, TARGET.pixel_y, TARGET.pixel_z, TARGET.pixel_w, ALPHA)	/* this will also add the image to the cache. */ \
		} \
		LAZYADD(AO_LIST, I); \
	}

#define CUT_AO(TARGET, AO_LIST) \
	if (AO_LIST) { \
		TARGET.cut_overlay(AO_LIST, TRUE); \
		AO_LIST.Cut(); \
	}

#define REGEN_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		PROCESS_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA); \
	} \
	UNSETEMPTY(AO_LIST); \
	if (AO_LIST) { \
		TARGET.add_overlay(AO_LIST, TRUE); \
	}

/turf/proc/update_ao()
	var/list/cache = SSao.image_cache
	CUT_AO(shadower, ao_overlays_mimic)
	CUT_AO(src, ao_overlays)
	if (mz_flags & MZ_MIMIC_BELOW)
		REGEN_AO(shadower, ao_overlays_mimic, ao_neighbors_mimic, Z_AO_ALPHA)
	if (AO_TURF_CHECK(src) && !(mz_flags & MZ_MIMIC_NO_AO))
		REGEN_AO(src, ao_overlays, ao_neighbors, WALL_AO_ALPHA)

/**
 * Scans direction to find targets to smooth with.
 */
/atom/proc/find_dense_turf_in_direction(direction)
	var/turf/target_turf = get_step(src, direction)
	if(!target_turf)
		return NULLTURF_BORDER

	if(AO_TURF_CHECK(target_turf))
		return ADJ_FOUND

	return NO_ADJ_FOUND

/**
 * Scans all adjacent turfs to find valid turfs to smooth ao with.
 */
/atom/proc/calculate_ao_adjacencies()
	. = NONE

	if(!loc)
		return

	for(var/direction in GLOB.cardinal)
		switch(find_dense_turf_in_direction(direction))
			if(NULLTURF_BORDER, ADJ_FOUND)
				// BYOND and smooth dirs are the same for cardinals.
				. |= direction

	if(. & NORTH_JUNCTION)
		if(. & WEST_JUNCTION)
			switch(find_dense_turf_in_direction(NORTHWEST))
				if(NULLTURF_BORDER, ADJ_FOUND)
					. |= NORTHWEST_JUNCTION

		if(. & EAST_JUNCTION)
			switch(find_dense_turf_in_direction(NORTHEAST))
				if(NULLTURF_BORDER, ADJ_FOUND)
					. |= NORTHEAST_JUNCTION

	if(. & SOUTH_JUNCTION)
		if(. & WEST_JUNCTION)
			switch(find_dense_turf_in_direction(SOUTHWEST))
				if(NULLTURF_BORDER, ADJ_FOUND)
					. |= SOUTHWEST_JUNCTION

		if(. & EAST_JUNCTION)
			switch(find_dense_turf_in_direction(SOUTHEAST))
				if(NULLTURF_BORDER, ADJ_FOUND)
					. |= SOUTHEAST_JUNCTION

#undef REGEN_AO
#undef PROCESS_AO
#undef AO_TURF_CHECK
#undef AO_SELF_CHECK
