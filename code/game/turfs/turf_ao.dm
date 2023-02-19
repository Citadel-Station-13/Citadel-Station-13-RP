#ifdef AO_USE_LIGHTING_OPACITY
#define AO_TURF_CHECK(T) (!T.has_opaque_atom || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.has_opaque_atom)
#else
#define AO_TURF_CHECK(T) (!T.density || !T.opacity || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.density && !T.opacity)
#endif

#define PROCESS_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		if (NEIGHBORS != AO_ALL_NEIGHBORS) { \
			var/image/I = cache["ao-[NEIGHBORS]|[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]|[ALPHA]"]; \
			if (!I) { \
				/* This will also add the image to the cache. */ \
				I = make_ao_image(NEIGHBORS, TARGET.pixel_x, TARGET.pixel_y, TARGET.pixel_z, TARGET.pixel_w, ALPHA) \
			} \
			LAZYADD(AO_LIST, I); \
		} \
	} \
	UNSETEMPTY(AO_LIST); \
	if (AO_LIST) { \
		TARGET.add_overlay(AO_LIST, TRUE); \
	}

#define CUT_AO(TARGET, AO_LIST) \
	if (AO_LIST) { \
		TARGET.cut_overlay(AO_LIST, TRUE); \
		AO_LIST.Cut(); \
	}

/proc/make_ao_image(corner, px = 0, py = 0, pz = 0, pw = 0, alpha)
	var/list/cache = SSao.image_cache
	var/cstr = "ao-[corner]"
	// PROCESS_AO above also uses this cache, check it before changing this key.
	var/key = "[cstr]|[px]/[py]/[pz]/[pw]|[alpha]"

	var/image/I = image('icons/turf/flooring/shadows.dmi', cstr)
	I.alpha = alpha
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA | RESET_COLOR | TILE_BOUND
	I.layer = TURF_AO_LAYER
	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf
	/**
	 * Whether this turf is allowed to have ambient occlusion.
	 * If FALSE, this turf will not be considered for ambient occlusion.
	 */
	var/permit_ao = TRUE

	/**
	 * Current ambient occlusion overlays.
	 * Tracked so we can reverse them without dropping all priority overlays.
	 */
	var/tmp/list/ao_overlays

	/**
	 * What directions this is currently smoothing with.
	 * This starts as null for us to know when it's first set, but after that it will hold a 8-bit mask ranging from 0 to 255.
	 *
	 * IMPORTANT: This uses the smoothing direction flags as defined in icon_smoothing.dm, instead of the BYOND flags.
	 */
	var/tmp/ao_junction

	/// The same as ao_overlays, but for the mimic turf.
	var/tmp/list/ao_overlays_mimic

	/// The same as ao_junction, but for the mimic turf.
	var/tmp/ao_junction_mimic

	/// Whether this turf is currently queued for ambient occlusion.
	var/ao_queued = AO_UPDATE_NONE

/turf/proc/calculate_ao_junction()
	ao_junction = NONE
	ao_junction_mimic = NONE
	if (!permit_ao)
		return

	var/turf/T
	if (mz_flags & MZ_MIMIC_BELOW)
		CALCULATE_JUNCTIONS(src, ao_junction_mimic, T, (T.mz_flags & MZ_MIMIC_BELOW))
	if (AO_SELF_CHECK(src) && !(mz_flags & MZ_MIMIC_NO_AO))
		CALCULATE_JUNCTIONS(src, ao_junction, T, AO_TURF_CHECK(T))

/turf/proc/regenerate_ao()
	for (var/thing in RANGE_TURFS(1, src))
		var/turf/T = thing
		if (T?.permit_ao)
			T.queue_ao(TRUE)

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

/turf/proc/update_ao()
	var/list/cache = SSao.image_cache
	CUT_AO(shadower, ao_overlays_mimic)
	CUT_AO(src, ao_overlays)
	if (mz_flags & MZ_MIMIC_BELOW)
		PROCESS_AO(shadower, ao_overlays_mimic, ao_junction_mimic, Z_AO_ALPHA)
	if (AO_TURF_CHECK(src) && !(mz_flags & MZ_MIMIC_NO_AO))
		PROCESS_AO(src, ao_overlays, ao_junction, WALL_AO_ALPHA)

#undef AO_TURF_CHECK
#undef AO_SELF_CHECK
#undef PROCESS_AO
