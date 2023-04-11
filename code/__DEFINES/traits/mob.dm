//? mobility ; call update_mobility(). update_mobility() may assign additional flags.

#define TRAIT_MOBILITY_CAN_MOVE_BLOCKED "mobility_no_move"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_MOVE_BLOCKED)
#define TRAIT_MOBILITY_CAN_STAND_BLOCKED "mobility_no_stand"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_STAND_BLOCKED)
#define TRAIT_MOBILITY_CAN_PICKUP_BLOCKED "mobility_no_pickup"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_PICKUP_BLOCKED)
#define TRAIT_MOBILITY_CAN_USE_BLOCKED "mobility_no_use"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_USE_BLOCKED)
#define TRAIT_MOBILITY_CAN_UI_BLOCKED "mobility_no_ui"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_UI_BLOCKED)
#define TRAIT_MOBILITY_CAN_STORAGE_BLOCKED "mobility_no_storage"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_STORAGE_BLOCKED)
#define TRAIT_MOBILITY_CAN_PULL_BLOCKED "mobility_no_pull"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_PULL_BLOCKED)
#define TRAIT_MOBILITY_CAN_HOLD_BLOCKED "mobility_no_hold"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_HOLD_BLOCKED)
#define TRAIT_MOBILITY_CAN_RESIST_BLOCKED "mobility_no_resist"
DATUM_TRAIT(/mob, TRAIT_MOBILITY_CAN_RESIST_BLOCKED)

//? stat ; call update_stat(). update_stat() has the right to ignore.

#define TRAIT_MOB_UNCONSCIOUS "mob_unconscious"
DATUM_TRAIT(/mob, TRAIT_MOB_UNCONSCIOUS)
#define TRAIT_MOB_SLEEPING "mob_sleeping"
DATUM_TRAIT(/mob, TRAIT_MOB_SLEEPING)

//? misc

///Tracks whether you're a mime or not.
#define TRAIT_MIMING			"miming"
DATUM_TRAIT(/mob, TRAIT_MIMING)
