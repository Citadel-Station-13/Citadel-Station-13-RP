//! Widely used algorithm-fragments

/**
 * returns a list of deepmaint
 *
 * BLACKBOARD:
 * __spread_danger_budget__ - set this to how much danger should spawn
 * __spread_rarity_budget__ - set this to how much rarity should spawn
 * __spread_danger_used__ - is set to how much danger we spawned
 * __spread_rarity_used__ - is set to how much rarity we spawned
 */
/datum/deepmaint_algorithm/proc/_common_room_auto_spread(obj/landmark/deepmaint_root/host, turf/from, list/obj/landmark/deepmaint_marker/generation/markers, list/datum/map_template/submap/deepmaint/templates, zlevel)
	. = list()
