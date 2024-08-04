//* movespeed_modifier_flags
/// doesn't apply while in gravity
#define MOVESPEED_MODIFIER_REQUIRES_GRAVITY (1<<0)

DEFINE_SHARED_BITFIELD(movespeed_modifier_flags, list(
	"movespeed_modifier_flags",
), list(
	BITFIELD_NAMED("Requires Gravity", MOVESPEED_MODIFIER_REQUIRES_GRAVITY),
))
//* calculation_type

/// just use multiplicative_slowdown
#define MOVESPEED_CALCULATION_HYPERBOLIC "hyperbolic"
/// use multiplicative_slowdown and TILE_BOOST calculations
#define MOVESPEED_CALCULATION_HYPERBOLIC_BOOST "hyperbolic_boost"
/// use % change and TILE_BOOST calculations
#define MOVESPEED_CALCULATION_MULTIPLY "multiply"
/// legacy multiply
//! TODO: REMOVE THIS SHIT
#define MOVESPEED_CALCULATION_LEGACY_MULTIPLY "legacy_multiply"

DEFINE_ENUM(movespeed_modifier_calculation_type, list(
	/datum/movespeed_modifier = list(
		"calculation_type",
	),
), list(
	ENUM("Hyperbolic", MOVESPEED_CALCULATION_HYPERBOLIC),
	ENUM("Hyperbolic w/ Limit", MOVESPEED_CALCULATION_HYPERBOLIC_BOOST),
	ENUM("Multiply", MOVESPEED_CALCULATION_MULTIPLY),
	ENUM("Legacy Multiply", MOVESPEED_CALCULATION_LEGACY_MULTIPLY),
))

//* params for add_or_update_variable_movespeed_modifier

/// multiplicative_slowdown
#define MOVESPEED_PARAM_DELAY_MOD "delay"
/// multiply_speed
#define MOVESPEED_PARAM_MULTIPLY_SPEED "multiply"
/// absolute_max_tiles_per_second
#define MOVESPEED_PARAM_MAX_TILE_ABSOLUTE "absolute_tiles"
/// max_tiles_per_second_boost
#define MOVESPEED_PARAM_MAX_TILE_BOOST "max_tlies"

//* Constants

/// minimum movespeed
#define MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND 0.25

//* Priorities - Lower is applied first

#define MOVESPEED_PRIORITY_DEFAULT 0
#define MOVESPEED_PRIORITY_CARRY_WEIGHT 10

//* Conflicts IDs
// None yet

//* IDs
// None yet
