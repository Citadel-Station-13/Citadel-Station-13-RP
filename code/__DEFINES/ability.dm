//? interact_type; used on tgui side - update that if you change these.

/// no default interact, no hotbinding
#define ABILITY_INTERACT_NONE "none"
/// trigger interact, hot-bindable
#define ABILITY_INTERACT_TRIGGER "trigger"
/// toggle interact, hot-bindable
#define ABILITY_INTERACT_TOGGLE "toggle"

//? ability_check_flags - if you add new ones, make sure to modify available_check() and unavailable_reason().

#define ABILITY_CHECK_CONSCIOUS (1<<0)
#define ABILITY_CHECK_STANDING (1<<1)
#define ABILITY_CHECK_FREE_HAND (1<<2)
#define ABILITY_CHECK_STUNNED (1<<3)
#define ABILITY_CHECK_RESTING (1<<4)
