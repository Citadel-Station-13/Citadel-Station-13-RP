//*                   interact_type                      *//
//* used on tgui side - update that if you change these. *//

/// no default interact, no hotbinding
#define ABILITY_INTERACT_NONE "none"
/// trigger interact, hot-bindable
#define ABILITY_INTERACT_TRIGGER "trigger"
/// toggle interact, hot-bindable
#define ABILITY_INTERACT_TOGGLE "toggle"

//? targeting_type - exclusively used for targeted abilities

#define ABILITY_TARGET_ALL "all"
#define ABILITY_TARGET_MOB "mob"
#define ABILITY_TARGET_TURF "turf"

//* ability_check_flags - If you add these, make sure to modify /datum/ability/proc/run_ability_check_flags() *//

/// Requires a free hand.
#define ABILITY_CHECK_HAS_FREE_HAND (1<<0)
/// Requires you to be resting.
#define ABILITY_CHECK_IS_RESTING (1<<1)
