/**
 * holder data for darksight
 */
/datum/darksight
	#warn priority, binary insert, modifier time woo yea

/datum/darksight/proc/push(datum/perspective/perspective)
	return

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
	var/soft_darksight_smartness = FALSE

/datum/darksight/baseline/New(hard, soft_range, soft_alpha, soft_matrix, soft_smart)
	if(!isnull(hard))
		src.hard_darksight = hard
	if(!isnull(soft_range))
		src.soft_darksight_range = soft_range
	if(!isnull(soft_alpha))
		src.soft_darksight_alpha = soft_darksight_alpha
	if(!isnull(soft_matrix))
		src.soft_darksight_matrix = soft_matrix
	if(!isnull(soft_smart))
		src.soft_darksight_smartness = soft_smart

/datum/darksight/baseline/push(datum/perspective/perspective)
	perspective.hard_darkvision = hard_darksight
	perspective.darkvision_alpha = soft_darkvision_alpha
	perspective.darkvision_range = soft_darkvision_range
	perspective.darkvision_matrix = soft_darkvision_matrix?.Copy() || construct_rgb_color_matrix()
	perspective.darkvision_smart = soft_darkvision_smartness
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

/datum/darksight/augmenting/push(datum/perspective/perspective)
	perspective.hard_darksight = min(perspective.hard_darksight, hard_alpha)
	perspective.darkvision_alpha = min(perspective.darkvision_alpha, soft_alpha)
	perspective.darkvision_range = max(perspective.darkvision_range, soft_range)
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrx)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
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
	perspective.hard_darksight += hard_alpha
	perspective.darkvision_alpha += soft_alpha
	perspective.darkvision_range += soft_range
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrx)
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
	perspective.hard_darksight *= hard_alpha
	perspective.darkvision_alpha *= soft_alpha
	perspective.darkvision_range *= soft_range
	if(!isnull(soft_matrix))
		perspective.darkvision_matrix = color_matrix_multiply(perspective.darkvision_matrix, soft_matrx)
	if(disable_soft_smartness)
		perspective.darkvision_smart = FALSE
	return ..()

//? default baseline

GLOBAL_DATUM_INIT(default_darksight, /datum/darksight/baseline/default, new)

/datum/darksight/baseline/default
