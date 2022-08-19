//! Wanna add hitpush signals? TOO BAD, DON'T. Modify the thrownthing datum these pass in!

/// from base of /atom/proc/throw_impacted: (AM, thrownthing)
#define COMSIG_ATOM_THROW_IMPACTED				"throw_impacted"
/// from base of /atom/movable/proc/throw_impact: (AM, thrownthing)
#define COMSIG_MOVABLE_THROW_IMPACT				"throw_impact"
// This set of returns can be for both of the above!
	/// cancel further actions in this hit
	#define COMPONENT_THROW_HIT_NEVERMIND				(1<<0)
	/// pierce through.
	#define COMPONENT_THROW_HIT_PIERCE					(1<<1)
	/// completely terminate throw silently immediately. Use if you're deleting the atom.
	#define COMPONENT_THROW_HIT_TERMINATE				(1<<2)

/// called on throws landing on something: (landed_on, thrownthing)
#define COMSIG_MOVABLE_THROW_LAND				"throw_land"
/// called on something landing on us from a throw
#define COMSIG_ATOM_THROW_LANDED				"throw_landed"
// This set of returns can be for both of the above!
	/// cancel further actions
	#define COMPONENT_THROW_LANDING_NEVERMIND			(1<<0)
	/// completely terminate throw silently immediately. Use if you're deleting the atom.
	#define COMPONENT_THROW_LANDING_TERMINATE			(1<<2)

#warn needs more synchronization
/// called in subsystem_throw and emulated_throw before the datum is created
#define COMSIG_MOVABLE_PRE_THROW				"pre_throw"
	/// cancel the throw
	#define COMPONENT_CANCEL_PRE_THROW					(1<<0)
/// called in subsystem_throw and emulated_throw after the datum is created with (target, range, speed, flags); it is now too late to cancel the throw.
#define COMSIG_MOVABLE_POST_THROW				"post_throw"
