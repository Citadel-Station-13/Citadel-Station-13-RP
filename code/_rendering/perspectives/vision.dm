GLOBAL_LIST_EMPTY(cached_vision_holders)

/proc/cached_vision_holder(datum/vision/path_or_instance)
	if(istype(path_or_instance))
		return path_or_instance
	if(isnull(GLOB.cached_vision_holders[path_or_instance]))
		GLOB.cached_vision_holders[path_or_instance] = new path_or_instance
	return GLOB.cached_vision_holders[path_or_instance]

/**
 * holder data for darksight
 */
/datum/vision
	/// priority - lower is higher
	var/priority = DARKSIGHT_PRIORITY_DEFAULT

/datum/vision/proc/push(datum/perspective/perspective)
	return

/proc/cmp_vision_holders(datum/vision/A, datum/vision/B)
	return A.priority - B.priority

/**
 * baseline darksight holder - overwrites everything when applied
 */
/datum/vision/baseline
	/// hard darksight? 255 for none, otherwise alpha of lighting plane.
	var/hard_darksight = 255
	/// soft darksight radius
	var/soft_darksight_range = SOFT_DARKSIGHT_RANGE_DEFAULT
	/// soft darksight alpha
	var/soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_DEFAULT
	/// soft darksight color multiplication matrix, if any. null is baseline matrix.
	var/list/soft_darksight_matrix
	/// do we use smart darkvision, or dumb?
	var/soft_darksight_smartness = TRUE
	/// VISION CONES LETS GOOOO - enum for angle
	var/soft_darksight_fov = SOFT_DARKSIGHT_FOV_90
	//  todo: this makes mesons / matscanners not be op by limiting see_in_dark while it's active.
	var/legacy_throttle = INFINITY
	var/override_legacy_throttle = FALSE

/datum/vision/baseline/push(datum/perspective/perspective)
	perspective.hard_darkvision = hard_darksight
	perspective.darkvision_alpha = soft_darksight_alpha
	perspective.darkvision_range = soft_darksight_range
	perspective.darkvision_matrix = soft_darksight_matrix?.Copy() || construct_rgb_color_matrix()
	perspective.darkvision_smart = soft_darksight_smartness
	perspective.darkvision_fov = soft_darksight_fov
	perspective.darkvision_legacy_throttle = legacy_throttle
	perspective.legacy_throttle_overridden = override_legacy_throttle
	return ..()

/**
 * min/max-augmenting darksight provider
 * matrix is always multiplied.
 */
/datum/vision/augmenting
	var/hard_alpha
	var/soft_range
	var/soft_alpha
	var/list/soft_matrix
	var/disable_soft_smartness
	var/soft_darksight_fov
	//  todo: this makes mesons / matscanners not be op by limiting see_in_dark while it's active.
	var/legacy_throttle = INFINITY

/datum/vision/augmenting/push(datum/perspective/perspective)
	if(!isnull(hard_alpha))
		perspective.hard_darkvision = min(perspective.hard_darkvision, hard_alpha)
	if(!isnull(soft_alpha))
		perspective.darkvision_alpha = min(perspective.darkvision_alpha, soft_alpha)
	if(!isnull(soft_range))
		perspective.darkvision_range = max(perspective.darkvision_range, soft_range)
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrix)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	if(!isnull(soft_darksight_fov))
		perspective.darkvision_fov = max(perspective.darkvision_fov, soft_darksight_fov)
	if(!isnull(legacy_throttle))
		perspective.darkvision_legacy_throttle = min(perspective.darkvision_legacy_throttle, legacy_throttle)
	return ..()

/**
 * add-augmenting darksight provider
 * matrix is always multiplied.
 */
/datum/vision/additive
	var/hard_alpha = 0
	var/soft_range = 0
	var/soft_alpha = 0
	var/list/soft_matrix
	var/disable_soft_smartness

/datum/vision/multiplicative/push(datum/perspective/perspective)
	perspective.hard_darkvision += hard_alpha
	perspective.darkvision_alpha += soft_alpha
	perspective.darkvision_range += soft_range
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrix)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	return ..()

/**
 * multiply-augmenting darksight provider
 */
/datum/vision/multiplicative
	var/hard_alpha = 1
	var/soft_range = 1
	var/soft_alpha = 1
	var/list/soft_matrix
	var/disable_soft_smartness

/datum/vision/multiplicative/push(datum/perspective/perspective)
	perspective.hard_darkvision *= hard_alpha
	perspective.darkvision_alpha *= soft_alpha
	perspective.darkvision_range *= soft_range
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrix)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	return ..()

//? default baseline

GLOBAL_DATUM_INIT(default_darksight, /datum/vision/baseline/default, new)

/datum/vision/baseline/default
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_DEFAULT
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

//? silicons baseline

GLOBAL_DATUM_INIT(silicon_darksight, /datum/vision/baseline/silicons, new)
/datum/vision/baseline/silicons
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_DEFAULT
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

//? observer baseline

/datum/vision/baseline/observer
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = 0

//? species

/datum/vision/baseline/species_tier_0
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_DEFAULT
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_DEFAULT
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_DEFAULT
	soft_darksight_smartness = TRUE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/datum/vision/baseline/species_tier_1
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_1
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_TIER_1
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_TIER_1
	soft_darksight_smartness = TRUE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/datum/vision/baseline/species_tier_2
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_2
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_TIER_2
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_TIER_2
	soft_darksight_smartness = TRUE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/datum/vision/baseline/species_tier_3
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_3
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_TIER_3
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_TIER_3
	soft_darksight_smartness = TRUE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/datum/vision/baseline/species_tier_3/for_snowflake_ocs
	override_legacy_throttle = TRUE

/datum/vision/baseline/species_super
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_SUPER
	priority = DARKSIGHT_PRIORITY_INNATE
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_SUPER
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_SUPER
	soft_darksight_smartness = TRUE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

//? gear

/datum/vision/baseline/nvg_lowtech
	priority = DARKSIGHT_PRIORITY_GLASSES
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_NVGS
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_NVGS

	soft_darksight_fov = SOFT_DARKSIGHT_FOV_NVGS
	soft_darksight_smartness = FALSE
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/datum/vision/baseline/nvg_hightech
	priority = DARKSIGHT_PRIORITY_GLASSES
	soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_NVGS
	soft_darksight_range = SOFT_DARKSIGHT_RANGE_NVGS
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_NVGS
	/// greyscale
	soft_darksight_matrix = list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

//? misc

/datum/vision/augmenting/legacy_ghetto_nvgs
	priority = DARKSIGHT_PRIORITY_GLASSES
	hard_alpha = 90
	legacy_throttle = 3
