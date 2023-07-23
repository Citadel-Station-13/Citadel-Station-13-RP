//* /atom/movable/proc/see() args

#define MOVABLE_SEE_ARG_RAW_MESSAGE 1
#define MOVABLE_SEE_ARG_MESSAGE 2
#define MOVABLE_SEE_ARG_NAME 3
#define MOVABLE_SEE_ARG_VOICE 4
#define MOVABLE_SEE_ARG_ACTOR 5
#define MOVABLE_SEE_ARG_REMOTE 6

//* /atom/movable/proc/hear() args

#define MOVABLE_HEAR_ARG_RAW_MESSAGE 1
#define MOVABLE_HEAR_ARG_MESSAGE 2
#define MOVABLE_HEAR_ARG_NAME 3
#define MOVABLE_HEAR_ARG_VOICE 4
#define MOVABLE_HEAR_ARG_ACTOR 5
#define MOVABLE_HEAR_ARG_REMOTE 6
#define MOVABLE_HEAR_ARG_LANG 7
#define MOVABLE_HEAR_ARG_SPANS 8
/// Read only for now, we can re-evaluate once we get a param that is deemed necessary to change on receiving side.
#define MOVABLE_HEAR_ARG_PARAMS 9

//* /atom/movable/proc/hear() params

//! none yet

//* /atom/movable/proc/narrate() args

#define MOVABLE_NARRATE_ARG_RAW_MESSAGE 1

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
