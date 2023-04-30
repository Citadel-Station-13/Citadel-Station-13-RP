//! ## Timing subsystem
/**
 * Don't run if there is an identical unique timer active
 *
 * if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
 * and returns the id of the existing timer
 */
#define TIMER_UNIQUE			(1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)

/**
 * Timing should be based on how timing progresses on clients, not the server.
 *
 * Tracking this is more expensive,
 * should only be used in conjuction with things that have to progress client side, such as
 * animate() or sound()
 */
#define TIMER_CLIENT_TIME		(1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE			(1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT		(1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP				(1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME			(1<<6)

DEFINE_BITFIELD(timer_flags, list(
	BITFIELD(TIMER_UNIQUE),
	BITFIELD(TIMER_OVERRIDE),
	BITFIELD(TIMER_CLIENT_TIME),
	BITFIELD(TIMER_STOPPABLE),
	BITFIELD(TIMER_NO_HASH_WAIT),
	BITFIELD(TIMER_LOOP),
	BITFIELD(TIMER_DELETE_ME),
))

///Empty ID define
#define TIMER_ID_NULL -1
