/**
 *! Defines for subsystems
 *
 *? Lots of important stuff in here, make sure you have your brain switched on when editing this file!
 */

//*                             Subsystem Definition Macros                  *//

/**
 * Macro to fire off all logic when a subsystem is created - this is done immediately on New().
 */
#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){PreInit(TRUE);Preload(TRUE);Recover();qdel(varname);}varname = src;}

/**
 * Defines a normal subsystem.
 */
#define SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/##X);\
/datum/controller/subsystem/##X/New(){\
    NEW_SS_GLOBAL(SS##X);\
}\
/datum/controller/subsystem/##X

/**
 * Defines a processing subsystem.
 */
#define PROCESSING_SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/processing/##X);\
/datum/controller/subsystem/processing/##X/New(){\
    NEW_SS_GLOBAL(SS##X);\
}\
/datum/controller/subsystem/processing/##X

//*                                        Subsystem flags                                             *//
//* Please design any new flags so that the default is off, to make adding flags to subsystems easier. *//

/**
 * Subsystem does not need Initialize() called.
 *
 * * The subsystem will still fire when its init stage is completed, unless it is
 *   marked with [SS_NO_FIRE] or its `can_fire` is set to FALSE.
 * * The subsystem will still have its `initialized` variable set to TRUE.
 */
#define SS_NO_INIT (1<<0)

/**
 * Subsystem does not need fire() called / does not require scheduling and ticking.
 *
 * * This is exactly like setting `can_fire` to FALSE, but is permanent without a MC restart.
 * * Use for subsystems that will never require processing, rather than one that needs it turned off and on now and then.
 */
#define SS_NO_FIRE (1<<1)

/**
 * Subsystem will try its best to only run on spare CPU, after all non-background subsystems have ran.
 *
 * * This pushes a subsystem into the background fire_priority bracket.
 */
#define SS_BACKGROUND (1<<2)

/// subsystem does not tick check, and should not run unless there is enough time (or its running behind (unless background))
//  todo: this should be deprecated; please do not use this on new subsystems without good reason.
#define SS_NO_TICK_CHECK (1<<3)

/** Treat wait as a tick count, not DS, run every wait ticks. */
/// (also forces it to run first in the tick, above even SS_NO_TICK_CHECK subsystems)
/// (implies all runlevels because of how it works)
/// (overrides SS_BACKGROUND)
/// This is designed for basically anything that works as a mini-mc (like SStimer)
///
/// * Ticker is its own priority bucket. The highest one. Be careful.
/// * Ticker disables tick overrun punishment.
#define SS_TICKER (1<<4)

/** keep the subsystem's timing on point by firing early if it fired late last fire because of lag */
/// ie: if a 20ds subsystem fires say 5 ds late due to lag or what not, its next fire would be in 15ds, not 20ds.
///
/// * This will only keep timing past the last 10 seconds, it will not attempt to catch the subsystem up without bounds.
/// * This disables tick overrun punishment.
#define SS_KEEP_TIMING (1<<5)

/** Calculate its next fire after its fired. */
/// (IE: if a 5ds wait SS takes 2ds to run, its next fire should be 5ds away, not 3ds like it normally would be)
/// This flag overrides SS_KEEP_TIMING
#define SS_POST_FIRE_TIMING (1<<6)

/// If this subsystem doesn't initialize, it should not report as a hard error in CI.
/// This should be used for subsystems that are flaky for complicated reasons, such as
/// the Lua subsystem, which relies on auxtools, which is unstable. //! We don't have the Lua system, but this is a good example.
/// It should not be used simply to silence CI.
#define SS_OK_TO_FAIL_INIT (1<<7)

DEFINE_BITFIELD(subsystem_flags, list(
	BITFIELD(SS_NO_INIT),
	BITFIELD(SS_BACKGROUND),
	BITFIELD(SS_NO_TICK_CHECK),
	BITFIELD(SS_TICKER),
	BITFIELD(SS_KEEP_TIMING),
	BITFIELD(SS_POST_FIRE_TIMING),
	BITFIELD(SS_OK_TO_FAIL_INIT),
))

//*                     Subsystem `Initialize()` returns                          *//
/**
 * Negative values incidate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guarenteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2
/// The default return value which must be overriden. Will succeed with a warning.
#define SS_INIT_NONE -1
/// Subsystem initialized sucessfully.
#define SS_INIT_SUCCESS 2
/// If your system doesn't need to be initialized (by being disabled or something)
#define SS_INIT_NO_NEED 3
/// Succesfully initialized, BUT do not announce it to players (generally to hide game mechanics it would otherwise spoil)
#define SS_INIT_NO_MESSAGE 4

//*                          Subsystem 'state' variable                     *//

/**
 * Not doing anything right now.
 */
#define SS_IDLE 0
/**
 * In the MC's run-queue
 */
#define SS_QUEUED 1
/**
 * Set before the MC ignites a subsystem. This is the state while it's currently running.
 */
#define SS_RUNNING 2
/**
 * We are requesting a pause.
 *
 * * Set by the pause() proc if we did not sleep yet during our fire().
 */
#define SS_PAUSED 3
/**
 * fire() is currently sleeping.
 */
#define SS_SLEEPING 4
/**
 * We slept, and now we are requesting a pause.
 *
 * * Set by the pause() proc if we have slept since fire() was invoked.
 * * Converted to SS_PAUSED by ignite() once we finally return from fire(), as we cannot immediately pause if
 *   we are sleeping.
 */
#define SS_PAUSING 5

//* Misc *//

/// Boilerplate code for multi-step processors. See machines.dm for example use.
#define INTERNAL_SUBSYSTEM_PROCESS_STEP(this_step, initial_step, proc_to_call, cost_var, next_step)\
if(current_step == this_step || (initial_step && !resumed)) /* So we start at step 1 if not resumed.*/ {\
	timer = TICK_USAGE;\
	proc_to_call(resumed);\
	cost_var = MC_AVERAGE(cost_var, TICK_DELTA_TO_MS(TICK_USAGE - timer));\
	if(state != SS_RUNNING){\
		return;\
	}\
	resumed = 0;\
	current_step = next_step;\
}
