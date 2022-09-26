/datum/deepmaint_pathing
	//! Intrinsics
	/// name
	var/name = "Unknown Pathing Module"
	/// abstract type
	var/abstract_type = /datum/deepmaint_pathing

	//! Generic Path Properties
	/// default path turf
	var/path_turf_default = /turf/simulated/floor/plating
	/// default wall turf
	var/path_edge_default = /turf/simulated/wall

	//! Generic Path Geometrics
	/// general edge width average (outwards from path)
	var/edge_max_width = 2
	/// general edge width average (outwards from path)
	var/edge_min_width = 1
	/// general edge irregularity from 0 to 1
	var/edge_irregularity = 0.33
	/// general path irregularity from 0 to 1
	var/path_irregularity = 0.05
	/// general path width average (radius from center)
	var/path_min_width = 1
	/// general path width average (radius from center)
	var/path_max_width = 1


/datum/deepmaint_pathing/proc/encode_directives(...)
	return args.Copy()

/datum/deepmaint_pathing/proc/generate(datum/deepmaint_algorithm/algorithm, list/directives)
	CRASH("base generate() called on /datum/deepmaint_pathing")

/datum/deepmaint_pathing/proc/encode_and_generate(...)
	return generate(encode_directives(arglist(args)))

/datum/deepmaint_pathing/proc/can_place_tile(datum/deepmaint_algorithm/algorithm, list/directives, turf/T, placing_type)
