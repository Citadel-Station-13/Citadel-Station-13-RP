/**
 * holder data for darksight
 */
/datum/darksight
	/// hard darksight? null for none, otherwise alpha of lighting plane.
	var/hard_darksight
	/// soft darksight radius
	var/soft_darksight_range = SOFT_DARKSIGHT_RANGE_DEFAULT
	/// soft darksight alpha
	var/soft_darksight_alpha = SOFT_DARKSIGHT_ALPHA_DEFAULT
	/// soft darksight color multiplication matrix, if any
	var/list/soft_darksight_matrix

/datum/darksight/New(hard, soft_range, soft_alpha, soft_matrix)
	if(!isnull(hard))
		src.hard_darksight = hard
	if(!isnull(soft_range))
		src.soft_darksight_range = soft_range
	if(!isnull(soft_alpha))
		src.soft_darksight_alpha = soft_darksight_alpha
	if(!isnull(soft_matrix))
		src.soft_darksight_matrix = soft_matrix

GLOBAL_DATUM_INIT(default_darksight, /datum/darksight/default, new)

/datum/darksight/default
