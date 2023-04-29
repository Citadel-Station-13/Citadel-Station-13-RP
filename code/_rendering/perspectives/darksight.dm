GLOBAL_LIST_EMPTY(cached_darksight_holders)

/proc/cached_darksight_holder(datum/darksight/path_or_instance)
	if(istype(path_or_instance))
		return path_or_instance
	if(isnull(GLOB.cached_darksight_holders[path_or_instance]))
		GLOB.cached_darksight_holders += new path_or_instance
	return GLOB.cached_darksight_holders[path_or_instance]

/**
 * holder data for darksight
 */
/datum/darksight
	/// priority - lower is higher
	var/priority = DARKSIGHT_PRIORITY_DEFAULT

/datum/darksight/proc/push(datum/perspective/perspective)
	return

/proc/cmp_darksight_holders(datum/darksight/A, datum/darksight/B)
	return A.priority - B.priority

/**
 * baseline darksight holder - overwrites everything when applied
 */
/datum/darksight/baseline
	/// hard darksight? null for none, otherwise alpha of lighting plane.
	var/hard_darksight
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

/datum/darksight/baseline/push(datum/perspective/perspective)
	perspective.hard_darkvision = hard_darksight
	perspective.darkvision_alpha = soft_darksight_alpha
	perspective.darkvision_range = soft_darksight_range
	perspective.darkvision_matrix = soft_darksight_matrix?.Copy() || construct_rgb_color_matrix()
	perspective.darkvision_smart = soft_darksight_smartness
	perspective.darkvision_fov = soft_darksight_fov
	perspective.darkvision_legacy_throttle = legacy_throttle
	return ..()

/**
 * min/max-augmenting darksight provider
 * matrix is always multiplied.
 */
/datum/darksight/augmenting
	var/hard_alpha
	var/soft_range
	var/soft_alpha
	var/list/soft_matrix
	var/disable_soft_smartness
	var/soft_darksight_fov
	//  todo: this makes mesons / matscanners not be op by limiting see_in_dark while it's active.
	var/legacy_throttle = INFINITY

/datum/darksight/augmenting/push(datum/perspective/perspective)
	perspective.hard_darkvision = min(perspective.hard_darkvision, hard_alpha)
	perspective.darkvision_alpha = min(perspective.darkvision_alpha, soft_alpha)
	perspective.darkvision_range = max(perspective.darkvision_range, soft_range)
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrix)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	perspective.darkvision_fov = max(perspective.darkvision_fov, soft_darksight_fov)
	perspective.darkvision_legacy_throttle = min(perspective.darkvision_legacy_throttle, legacy_throttle)
	return ..()

/**
 * add-augmenting darksight provider
 * matrix is always multiplied.
 */
/datum/darksight/additive
	var/hard_alpha = 0
	var/soft_range = 0
	var/soft_alpha = 0
	var/list/soft_matrix
	var/disable_soft_smartness

/datum/darksight/multiplicative/push(datum/perspective/perspective)
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
/datum/darksight/multiplicative
	var/hard_alpha = 1
	var/soft_range = 1
	var/soft_alpha = 1
	var/list/soft_matrix
	var/disable_soft_smartness

/datum/darksight/multiplicative/push(datum/perspective/perspective)
	perspective.hard_darkvision *= hard_alpha
	perspective.darkvision_alpha *= soft_alpha
	perspective.darkvision_range *= soft_range
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrix)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	return ..()

//? default baseline

GLOBAL_DATUM_INIT(default_darksight, /datum/darksight/baseline/default, new)

/datum/darksight/baseline/default
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_DEFAULT

//? silicons baseline

GLOBAL_DATUM_INIT(silicon_darksight, /datum/darksight/baseline/silicons, new)
/datum/darksight/baseline/silicons
	hard_darksight = 0

//? species

/datum/darksight/baseline/species_tier_0
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_DEFAULT

/datum/darksight/baseline/species_tier_1
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_1

/datum/darksight/baseline/species_tier_2
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_2

/datum/darksight/baseline/species_tier_3
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_TIER_3

/datum/darksight/baseline/species_super
	soft_darksight_fov = SOFT_DARKSIGHT_FOV_SUPER

#warn impl all

//? misc

/datum/darksight/augmenting/legacy_ghetto_nvgs
	hard_alpha = 140
	legacy_throttle = 3
