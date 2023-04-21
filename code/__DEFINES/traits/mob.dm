//? mobility ; call update_mobility_blocked() and update_mobility_forced() when assigning these.
//? update_mobility() may assign additional flags.

#define TRAIT_MOBILITY_MOVE_BLOCKED "mobility_no_move"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_MOVE_BLOCKED)
#define TRAIT_MOBILITY_STAND_BLOCKED "mobility_no_stand"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_STAND_BLOCKED)
#define TRAIT_MOBILITY_PICKUP_BLOCKED "mobility_no_pickup"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_PICKUP_BLOCKED)
#define TRAIT_MOBILITY_USE_BLOCKED "mobility_no_use"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_USE_BLOCKED)
#define TRAIT_MOBILITY_UI_BLOCKED "mobility_no_ui"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_UI_BLOCKED)
#define TRAIT_MOBILITY_STORAGE_BLOCKED "mobility_no_storage"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_STORAGE_BLOCKED)
#define TRAIT_MOBILITY_PULL_BLOCKED "mobility_no_pull"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_PULL_BLOCKED)
#define TRAIT_MOBILITY_HOLD_BLOCKED "mobility_no_hold"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_HOLD_BLOCKED)
#define TRAIT_MOBILITY_RESIST_BLOCKED "mobility_no_resist"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_RESIST_BLOCKED)

#define TRAIT_MOBILITY_MOVE_FORCED "mobility_yes_move"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_MOVE_FORCED)
#define TRAIT_MOBILITY_STAND_FORCED "mobility_yes_stand"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_STAND_FORCED)
#define TRAIT_MOBILITY_PICKUP_FORCED "mobility_yes_pickup"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_PICKUP_FORCED)
#define TRAIT_MOBILITY_USE_FORCED "mobility_yes_use"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_USE_FORCED)
#define TRAIT_MOBILITY_UI_FORCED "mobility_yes_ui"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_UI_FORCED)
#define TRAIT_MOBILITY_STORAGE_FORCED "mobility_yes_storage"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_STORAGE_FORCED)
#define TRAIT_MOBILITY_PULL_FORCED "mobility_yes_pull"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_PULL_FORCED)
#define TRAIT_MOBILITY_HOLD_FORCED "mobility_yes_hold"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_HOLD_FORCED)
#define TRAIT_MOBILITY_RESIST_FORCED "mobility_yes_resist"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_RESIST_FORCED)

//? stat ; call update_stat(). update_stat() has the right to ignore.

#define TRAIT_MOB_UNCONSCIOUS "mob_unconscious"
DATUM_TRAIT(/mob, TRAIT_MOB_UNCONSCIOUS)
#define TRAIT_MOB_SLEEPING "mob_sleeping"
DATUM_TRAIT(/mob, TRAIT_MOB_SLEEPING)

//? misc

/// Tracks whether you're a mime or not.
#define TRAIT_MIMING "miming"
DATUM_TRAIT(/mob, TRAIT_MIMING)
/// Tracks if we're fishing right now
#define TRAIT_MOB_IS_FISHING "mob_fishing"
DATUM_TRAIT(/mob, TRAIT_MOB_IS_FISHING)
