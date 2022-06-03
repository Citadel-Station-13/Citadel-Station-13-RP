/**
 * deepmaint generation system
 * a system for prrocedurally generating dungeons from some root
 */

/**
 * represents the root of a deepmaint generation sequence
 */
/atom/movable/landmark/deepmaint_root
	name = "deepmaint generator"
	desc = "How can you see this?"

	/// generator directives
	var/directives = NONE
	/// state
	var/state = DEEPMAINT_GENERATION_STATE_NOT_STARTED
	/// algorithm
	var/algorithm = DEEPMAINT_ALGORITHM_DUNGEON_SPREAD
	/// state vars for the algorithm
	var/list/blackboard
	/// number of zlevels to spread upwards
	var/multiz_spread_up = 0
	/// number of zlevels to spread downwars
	var/multiz_spread_down = 0
	/// maximum path length to make, estimated
	var/max_path_length = INFINITY
	/// max distance from the root of the generator, estimated
	var/max_distance = 80
	/// max tiles to spawn
	var/max_tiles = INFINITY
	/// max danger to spawn - additive
	var/max_danger = INFINITY
	/// max rarity to spawn - additive
	var/max_rarity
