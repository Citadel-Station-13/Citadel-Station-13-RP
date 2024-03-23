
/**
 *! ## Conflict Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! Conflict Checking Elements
/// (id) - returns flags - Registered on something by conflict checking elements.
#define COMSIG_CONFLICT_ELEMENT_CHECK "conflict_element_check"
	///? A conflict was found
	#define ELEMENT_CONFLICT_FOUND	(1<<0)
