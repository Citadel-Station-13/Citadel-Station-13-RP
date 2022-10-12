//! Widely used algorithm-fragments

/**
 * returns a list of deepmaint
 * metadata/directives drawn from a given blackboard key
 * blackboard entries are obviously strings!
 *
 * blackboard input:
 * center - turf to spread from
 * dist - max dist to spread
 * count - how many rooms max to place
 * markers - markers to consider
 * templates - templates to consider
 * rooms - pre-generated rooms
 * rooms_used - rooms used associated to number of times used.
 * danger_max - set this to how much danger should spawn
 * rarity_max - set this to how much rarity should spawn
 * danger_goal - "goal" - templates near this spawn more
 * rarity_goal - "goal" - templates near this spawn more
 *
 * blackboard output:
 * placed_danger - is set to how much danger we spawned
 * placed_rarity - is set to how much rarity we spawned
 * placed_rooms - is set to the list of rooms we placed
 */
/datum/deepmaint_algorithm/proc/_common_room_auto_spread(list/blackboard)
	// load blackboard vars
	var/list/obj/landmark/deepmaint_marker/generation/markers = blackboard["markers"]
	var/list/datum/map_template/submap/deepmaint/templates = blackboard["templates"]
	var/list/datum/deepmaint_room/used = blackboard["rooms_used"] || list()
	var/list/datum/deepmaint_room/rooms = blackboard["rooms"] || list()
	var/turf/center = blackboard["center"]
	var/danger_max = blackboard["danger_max"]
	var/danger_goal = blackboard["danger_goal"]
	var/rarity_max = blackboard["rarity_max"]
	var/rarity_goal = blackboard["rarity_goal"]
	var/rooms_max = blackboard["count"]
	var/dist_max = blackboard["dist"]

	// track current rooms we're aware of
	var/list/datum/deepmaint_room/current = used.Copy()
	// track rooms we placed
	var/list/datum/deepmaint_room/placed = blackboard["placed_rooms"] = list()
	// track placed danger
	var/placed_danger = 0
	// track placed rarity
	var/placed_rarity = 0

	#warn impl


	// set blackboard
	blackboard["placed_danger"] = placed_danger
	blackboard["placed_rarity"] = placed_rarity
