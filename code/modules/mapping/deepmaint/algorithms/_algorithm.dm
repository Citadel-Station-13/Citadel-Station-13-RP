/**
 * deepmaint algorithms
 */
/datum/deepmaint_algorithm
	/// name
	var/name = "unknown algorithm"

/datum/deepmaint_algorithm/proc/generate(obj/landmark/deepmaint_root/host, turf/root, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	CRASH("Base on deepmaint_algorithm generate() called")
