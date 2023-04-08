/**
 *! ## Atom Movement Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From base of atom/Entered(): (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
/// If you hook this and need to intercept movement, always check if the atom is still in us. If something else is intercepting movement, bad things will happen as the component signal will not stop propagating.
#define COMSIG_ATOM_ENTERED "atom_entered"
/// From base of atom/Exited(): (atom/movable/gone, atom/new_loc)
/// If you hook this and need to intercept movement, always check if the atom is still in us. If something else is intercepting movement, bad things will happen as the component signal will not stop propagating.
#define COMSIG_ATOM_EXITED "atom_exited"
/// From base of atom/Bumped(): (/atom/movable)
#define COMSIG_ATOM_BUMPED "atom_bumped"
/// From base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
/// From /atom/movable/Moved: (/atom/movable/entering, old_loc, old_locs)
#define COMSIG_ATOM_ABSTRACT_ENTERED "atom_abstract_enter"
/// From /atom/movable/Moved: (/atom/movable/exiting)
#define COMSIG_ATOM_ABSTRACT_EXITED "atom_abstract_exit"

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
