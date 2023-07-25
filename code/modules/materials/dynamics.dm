//* Page has all balancing parameters + algorithms for dynamic attribute computations for things like armor

/**
 * creates an armor datum based off of our stats
 *
 * @params
 * * significance - relative amount of this material used should be a multiplier of MATERIAL_SIGNIFICANCE_BASELINE
 * * mob_armor - is this going to be used as mob armor? mob armor generally won't have vulnerability.
 */
/datum/material/proc/create_armor(significance = MATERIAL_SIGNIFICANCE_BASELINE, mob_armor)
	#warn params
	#warn impl

/**
 * combines multiple material armors into one
 *
 * @params
 * * materials - material instances associated to significance.
 */
/datum/controller/subsystem/materials/proc/combined_materials_armor(list/datum/material/materials)
	#warn impl

/**
 * combines multiple material armors into one
 * used for reinforcing / whatevers
 *
 * @params
 * * materials - material instances associated to significance. first is lowest; put exterior armors on last!
 */
/datum/controller/subsystem/materials/proc/reinforcing_materials_armor(list/datum/material/materials)
	#warn impl
