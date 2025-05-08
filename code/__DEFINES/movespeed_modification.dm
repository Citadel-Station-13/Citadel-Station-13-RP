//* movespeed_modifier_flags *//

/// doesn't apply while in gravity
#define MOVESPEED_MODIFIER_REQUIRES_GRAVITY (1<<0)

DEFINE_SHARED_BITFIELD(movespeed_modifier_flags, list(
	"movespeed_modifier_flags",
), list(
	BITFIELD_NAMED("Requires Gravity", MOVESPEED_MODIFIER_REQUIRES_GRAVITY),
))

//* params for add_or_update_variable_movespeed_modifier *//

// TODO: these shouldn't be nameof as if we change var names, persistence will break
#define MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN NAMEOF_TYPE(/datum/movespeed_modifier, mod_hyperbolic_slowdown)
#define MOVESPEED_PARAM_MOD_MULTIPLY_SPEED NAMEOF_TYPE(/datum/movespeed_modifier, mod_multiply_speed)
#define MOVESPEED_PARAM_MOD_TILES_PER_SECOND NAMEOF_TYPE(/datum/movespeed_modifier, mod_tiles_per_second)
#define MOVESPEED_PARAM_LIMIT_TPS_MAX NAMEOF_TYPE(/datum/movespeed_modifier, limit_tiles_per_second_max)
#define MOVESPEED_PARAM_LIMIT_TPS_ADD NAMEOF_TYPE(/datum/movespeed_modifier, limit_tiles_per_second_add)
#define MOVESPEED_PARAM_LIMIT_TPS_MIN NAMEOF_TYPE(/datum/movespeed_modifier, limit_tiles_per_second_min)

#define MOVESPEED_PARAM_VALID_SET list( \
	MOVESPEED_PARAM_MOD_HYPERBOLIC_SLOWDOWN = TRUE, \
	MOVESPEED_PARAM_MOD_MULTIPLY_SPEED = TRUE, \
	MOVESPEED_PARAM_MOD_TILES_PER_SECOND = TRUE, \
	MOVESPEED_PARAM_LIMIT_TPS_MAX = TRUE, \
	MOVESPEED_PARAM_LIMIT_TPS_ADD = TRUE, \
	MOVESPEED_PARAM_LIMIT_TPS_MIN = TRUE, \
)

//* Priorities - Lower is applied first *//

#define MOVESPEED_PRIORITY_BASE_MOVE_SPEED -10000000
#define MOVESPEED_PRIORITY_DEFAULT 0
#define MOVESPEED_PRIORITY_CARRY_WEIGHT 10
#define MOVESPEED_PRIORITY_FORCED_SPEEDUP 10000
#define MOVESPEED_PRIORITY_MOVEMENT_INTENT 1000000

//* Constants *//

/// minimum TPS mobs may move at; used to prevent softlocks
#define MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND (1 / 3)

//* Conflicts IDs *//
// None yet

//* IDs *//
// None yet
