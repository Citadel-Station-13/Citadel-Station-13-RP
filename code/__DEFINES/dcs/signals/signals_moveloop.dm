/**
 *! ## Moveloop Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From [/datum/move_loop/start_loop] ():
////#define COMSIG_MOVELOOP_START "moveloop_start"
/// From [/datum/move_loop/stop_loop] ():
////#define COMSIG_MOVELOOP_STOP "moveloop_stop"
/// From [/datum/move_loop/process] ():
////#define COMSIG_MOVELOOP_PREPROCESS_CHECK "moveloop_preprocess_check"
	////#define MOVELOOP_SKIP_STEP (1<<0)
/// From [/datum/move_loop/process] (succeeded, visual_delay):
////#define COMSIG_MOVELOOP_POSTPROCESS "moveloop_postprocess"
/// From [/datum/move_loop/has_target/jps/recalculate_path] ():
////#define COMSIG_MOVELOOP_JPS_REPATH "moveloop_jps_repath"
