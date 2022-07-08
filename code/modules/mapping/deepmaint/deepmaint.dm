/**
 * deepmaint generation system
 * a system for prrocedurally generating dungeons from some root
 */

/**
 * represents the root of a deepmaint generation sequence
 */
/obj/landmark/deepmaint_root
	name = "deepmaint generator"
	desc = "How can you see this?"

	/// generator id - used to link up with markers
	var/id
	/// generator directives
	var/directives = NONE
	/// state - enum, usually used for internal calculations. either not done, in progress, or done.
	var/state = DEEPMAINT_GENERATION_STATE_NOT_STARTED
	/// algorithm - enum, check defines, this determines the algorithm datum we'll use
	var/algorithm = DEEPMAINT_ALGORITHM_DUNGEON
	/// type flags - only allows templates with matching types to spawn
	var/deepmaint_type = DEEPMAINT_TYPE_ANY
	/// theme flags - only allows tempaltes with matching themes to spawn
	var/deepmaint_theme = DEEPMAINT_THEME_ANY
	/// state vars for the algorithm
	var/list/blackboard
	/// json to load into blackboard at start - WARNING: ADVANCED FEATURE
	var/blackboard_initial_json
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
	var/max_rarity = INFINITY
	/// interior floor type
	var/interior_floor_type
	/// interior plating type
	var/interior_plating_type
	/// exterior floor type
	var/exterior_floor_type
	/// interior wall type
	var/interior_wall_type
	/// exterior wall type
	var/exterior_wall_type

/obj/landmark/deepmaint_root/New()
	SSmapping.deepmaint_loaders += src
	return ..()

/obj/landmark/deepmaint_root/Destroy()
	SSmapping.deepmaint_loaders -= src
	return ..()
