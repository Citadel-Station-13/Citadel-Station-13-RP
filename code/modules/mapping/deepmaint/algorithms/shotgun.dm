/obj/landmark/deepmaint_root/shotgun
	name = "deepmaint generator - seed submaps (naive)"
	algorithm = /datum/deepmaint_algorithm/shotgun

	//! general
	/// what to do post seeding - 'none', 'caves', 'paths'
	var/postprocessing_mode = "none"

	//! caves


	//! paths

/obj/landmark/deepmaint_root/shotgun/caves
	postprocessing_mode = "caves"

/obj/landmark/deepmaint_root/shotgun/paths
	postprocessing_mode = "paths"

/obj/landmark/deepmaint_root/shotgun/init_blackboard()
	. = ..()
	#warn include data

/**
 * extremely naive algorithm that literally just shotguns submaps out like it's seed_submaps all over again
 */
/datum/deepmaint_algorithm/shotgun
	name = "random placement"
	desc = "randomly places rooms with no regards to anything"


/datum/deepmaint_algorithm/shotgun/generate(obj/landmark/deepmaint_root/host, turf/root, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	host.blackboard["rooms"] = list()

	// detect levels
	var/list/level_detect = list(host.z)
	host.blackboard["levels"] = level_detect
	var/turf/current = get_turf(host)
	for(var/i in 1 to host.multiz_spread_up)
		current = current.Above()
		if(level_detect.Find(current.z))
			stack_trace("collision when spreading up against level - are we somehow looped?")
			break
		level_detect += current.z

	current = get_turf(host)
	for(var/i in 1 to host.multiz_spread_down)
		current = current.Below()
		if(level_detect.Find(current.z))
			stack_trace("collision when spreading up against level - are we somehow looped?")
			break
		level_detect += current.z

	// randomly shotgun ruins, spreading as necessary
	spread(host, root, markers, templates)


/datum/deepmaint_algorithm/shotgun/proc/spread(obj/landmark/deepmaint_root/host, turf/root, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates)
	// track current rooms
	var/list/datum/deepmaint_room/rooms_current = list()
	var/list/datum/deepmaint_room/rooms_totality = host.blackboard["rooms"]

	// postprocessing of current level
	var/processing_mode = blackboard["postprocessing_mode"]
