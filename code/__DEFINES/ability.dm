//* interact_type; used on tgui side - update that if you change these.

/// no default interact, no hotbinding
#define ABILITY_INTERACT_NONE "none"
/// trigger interact, hot-bindable
#define ABILITY_INTERACT_TRIGGER "trigger"
/// toggle interact, hot-bindable
#define ABILITY_INTERACT_TOGGLE "toggle"
/// single target interact, hot-bindable
#define ABILITY_INTERACT_SINGLE_TARGET "single_target"

//* ability_check_flags - if you add new ones, make sure to modify available_check() and unavailable_reason().

#define ABILITY_CHECK_CONSCIOUS (1<<0)
#define ABILITY_CHECK_STANDING (1<<1)
#define ABILITY_CHECK_FREE_HAND (1<<2)
#define ABILITY_CHECK_STUNNED (1<<3)
#define ABILITY_CHECK_RESTING (1<<4)

DEFINE_BITFIELD(ability_check_flags, list(
	BITFIELD(ABILITY_CHECK_CONSCIOUS),
	BITFIELD(ABILITY_CHECK_STANDING),
	BITFIELD(ABILITY_CHECK_FREE_HAND),
	BITFIELD(ABILITY_CHECK_STUNNED),
	BITFIELD(ABILITY_CHECK_RESTING),
))

//* ability_ai_type

/// single target offensive - targets a discrete atom
#define ABILITY_AI_TYPE_OFFENSIVE_SINGLE 1
/// multi target offensive - aoe - targets a discrete atom or a turf
#define ABILITY_AI_TYPE_OFFENSIVE_AOE 2
/// chase / targeting assistance - targets a discrete atom or a turf
#define ABILITY_AI_TYPE_CHASE 3
/// fleeing / retreating assistance - targets a turf
#define ABILITY_AI_TYPE_FLEE 4
/// AoE centered on self against enemies
#define ABILITY_AI_TYPE_DEFENSIVE_AOE 5
/// AoE centered of self for allies
#define ABILITY_AI_TYPE_BUFF_AOE 6

/// total ability AI types
#define ABILITY_AI_TYPE_TOTAL 6

//* ability_ai_flags

/// enrage / end of life ability, such as phoron spider detonation
#define ABILITY_AI_FLAG_ENRAGE (1<<0)

DEFINE_BITFIELD(ability_ai_flags, list(
	BITFIELD(ABILITY_AI_FLAG_ENRAGE),
))
