/**
 * deepmaint generation system
 * a system for prrocedurally generating dungeons from some root
 */

/**
 * represents the root of a deepmaint generation sequence
 */
/obj/landmark/deepmaint_root
	name = "invalid deepmaint generator"
	desc = "How can you see this?"

	//! Intrinsics
	/// generator id - used to link up with markers
	var/id

	//! Submaps
	/// type flags - only allows templates with matching types to spawn
	var/deepmaint_type = DEEPMAINT_TYPE_ANY
	/// theme flags - only allows tempaltes with matching themes to spawn
	var/deepmaint_theme = DEEPMAINT_THEME_ANY

	//! Limits
	/// number of zlevels to spread upwards
	var/multiz_spread_up = 0
	/// number of zlevels to spread downwars
	var/multiz_spread_down = 0
	/// max distance from the root of the generator, estimated
	var/max_distance = 80
	/// max tiles to spawn
	var/max_tiles = INFINITY
	/// max danger to spawn - additive
	var/max_danger = INFINITY
	/// max rarity to spawn - additive
	var/max_rarity = INFINITY
	/// maxrooms to spawn
	var/max_rooms = 50
	#warn should we support per-zlevel limits for budgets and max dist?
	#warn handle per-zlevel anchors?

	//! Generator
	/// generator directives
	var/directives = NONE
	/// state - enum, usually used for internal calculations. either not done, in progress, or done.
	var/state = DEEPMAINT_GENERATION_STATE_NOT_STARTED
	/// algorithm - enum, check defines, this determines the algorithm datum we'll use
	var/algorithm

	//! Generation
	/// state vars for the algorithm
	var/list/blackboard
	/// json to load into blackboard at start - WARNING: ADVANCED FEATURE
	var/blackboard_initial_json

	//! Paths
	/// path amount bias - 1 = 100% chance of putting back unnecessary paths, -1 = 100% chance of removing necessary paths, 0 = leave it alone
	var/path_pruning_bias = (1 / 3)
	/// cull invalid paths instead of generate them halfway
	var/path_culling = FALSE
	#warn impl below
	/// path edge irregularity
	var/edge_irregularity = 0.5
	/// path edge width
	var/max_edge_width = 3
	/// path edge width
	var/min_edge_width
	/// path irregularity
	var/path_irregularity = 0.1
	/// path width
	var/max_path_width = 3
	/// path width
	var/min_path_width = 2
	/// maximum path length to make, estimated
	var/max_path_length = INFINITY

	//! Turfs
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
