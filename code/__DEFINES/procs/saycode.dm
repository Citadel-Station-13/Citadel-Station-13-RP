//* /atom/proc/see() args

#define ATOM_SEE_ARG_RAW_MESSAGE 1
#define ATOM_SEE_ARG_MESSAGE 2
#define ATOM_SEE_ARG_NAME 3
#define ATOM_SEE_ARG_VOICE 4
#define ATOM_SEE_ARG_ACTOR 5
#define ATOM_SEE_ARG_REMOTE 6

//* /atom/proc/hear() args

#define ATOM_HEAR_ARG_RAW_MESSAGE 1
#define ATOM_HEAR_ARG_MESSAGE 2

#warn reconcile

//* /atom/proc/narrate() args

#define ATOM_NARRATE_ARG_RAW_MESSAGE 1

/// works as long as can see
#define SAYCODE_TYPE_VISIBLE 1
/// works as long as can hear
#define SAYCODE_TYPE_AUDIBLE 2
/// works as long as conscious
#define SAYCODE_TYPE_CONSCIOUS 3
/// works as long as alive
#define SAYCODE_TYPE_LIVING 4
/// it just works
#define SAYCODE_TYPE_ALWAYS 5
