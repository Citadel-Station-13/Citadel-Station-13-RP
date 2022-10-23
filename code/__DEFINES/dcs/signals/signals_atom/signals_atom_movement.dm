/**
 *! ## Atom Movement Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// Signal sent out by an atom when it checks if it can be pulled, for additional checks
////#define COMSIG_ATOM_CAN_BE_PULLED "movable_can_be_pulled"
	////#define COMSIG_ATOM_CANT_PULL (1<<0)
/// Signal sent out by an atom when it is no longer being pulled by something else
////#define COMSIG_ATOM_NO_LONGER_PULLED "movable_no_longer_pulled"
/// Called for each movable in a turf contents on /turf/zImpact(): (atom/movable/A, levels)
////#define COMSIG_ATOM_INTERCEPT_Z_FALL "movable_intercept_z_impact"
/// Called on a movable (NOT living) when it starts pulling (atom/movable/pulled, state, force)
////#define COMSIG_ATOM_START_PULL "movable_start_pull"
/// Called on /living when someone starts pulling (atom/movable/pulled, state, force)
////#define COMSIG_LIVING_START_PULL "living_start_pull"
/// Called on /living when someone is pulled (mob/living/puller)
////#define COMSIG_LIVING_GET_PULLED "living_start_pulled"
/// Called on /living, when pull is attempted, but before it completes, from base of [/mob/living/start_pulling]: (atom/movable/thing, force)
////#define COMSIG_LIVING_TRY_PULL "living_try_pull"
	////#define COMSIG_LIVING_CANCEL_PULL (1<<0)
/// Called from /mob/living/update_pull_movespeed
////#define COMSIG_LIVING_UPDATING_PULL_MOVESPEED "living_updating_pull_movespeed"
/// Called from /mob/living/PushAM -- Called when this mob is about to push a movable, but before it moves
/// (atom/movable/being_pushed)
////#define COMSIG_LIVING_PUSHING_MOVABLE "living_pushing_movable"
/// From base of [/atom/proc/interact]: (mob/user)
////#define COMSIG_ATOM_UI_INTERACT "atom_ui_interact"
/// From base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
/// From /datum/component/singularity/proc/can_move(), as well as /obj/energy_ball/proc/can_move()
/// If a callback returns `SINGULARITY_TRY_MOVE_BLOCK`, then the singularity will not move to that turf
////#define COMSIG_ATOM_SINGULARITY_TRY_MOVE "atom_singularity_try_move"
	//? When returned from `COMSIG_ATOM_SINGULARITY_TRY_MOVE`, the singularity will move to that turf
	////#define SINGULARITY_TRY_MOVE_BLOCK (1<<0)
/// From base of atom/experience_pressure_difference(): (pressure_difference, direction, pressure_resistance_prob_delta)
////#define COMSIG_ATOM_PRE_PRESSURE_PUSH "atom_pre_pressure_push"
	//? Prevents pressure movement
	////#define COMSIG_ATOM_BLOCKS_PRESSURE (1<<0)

//! ## Atom Area Signals.
/// From base of area/Entered(): (/area)
#define COMSIG_ATOM_ENTER_AREA "enter_area"
/// From base of area/Exited(): (/area)
#define COMSIG_ATOM_EXIT_AREA "exit_area"

//! Relaymoves
/// Called from relaymove from buckled: (mob/M, dir)
#define COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED		"relaymove_buckled"
	/// handled - skip other logic
	#define COMPONENT_RELAYMOVE_HANDLED			(1<<0)
