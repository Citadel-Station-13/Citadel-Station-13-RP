//* Values for the `atom_init_status` variable on SSatoms. *//

/// New should not call Initialize.
#define ATOM_INIT_IN_SUBSYSTEM 0
/// New should call Initialize(FALSE) - not mapload
#define ATOM_INIT_IN_NEW_REGULAR 1
/// New should call Initialize(TRUE) - is in a mapload
#define ATOM_INIT_IN_NEW_MAPLOAD 2

//! ### Initialization hints

/// Nothing happens
#define INITIALIZE_HINT_NORMAL 0

/**
 * call LateInitialize at the end of all atom Initalization.
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

/// Call qdel on the atom after intialization.
#define INITIALIZE_HINT_QDEL 2

/// type and all subtypes should always immediately call Initialize in New().
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(atom_flags & ATOM_INITIALIZED)) {\
		var/previous_initialized_value = SSatoms.initialized;\
		SSatoms.initialized = ATOM_INIT_IN_NEW_MAPLOAD;\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, FALSE, args);\
		SSatoms.initialized = previous_initialized_value;\
	}\
}
