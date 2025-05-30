//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// from /atom/movable/proc/_throw_do_hit: (impactor, thrownthing)
#define COMSIG_ATOM_THROW_IMPACTED				"throw_impacted"
/// from /atom/movable/proc/_throw_do_hit: (blocker, thrownthing)
#define COMSIG_MOVABLE_THROW_IMPACT				"throw_impact"
// This set of returns can be for both of the above!
	/// cancel further actions in this hit
	#define COMPONENT_THROW_HIT_NEVERMIND				(1<<0)
	/// pierce through.
	#define COMPONENT_THROW_HIT_PIERCE					(1<<1)
	/// completely terminate throw immediately and silently. Use if you're deleting the atom.
	#define COMPONENT_THROW_HIT_TERMINATE				(1<<2)

/// from /atom/movable/proc/_throw_finalize: (landed_on, thrownthing)
#define COMSIG_MOVABLE_THROW_LAND				"throw_land"
/// from /atom/movable/proc/_throw_finalize: (landing_movable, thrownthing)
#define COMSIG_ATOM_THROW_LANDED				"throw_landed"
// This set of returns can be for both of the above!
	/// cancel further actions
	#define COMPONENT_THROW_LANDING_NEVERMIND			(1<<0)
	/// completely terminate throw immediately and silently. Use if you're deleting the atom.
	#define COMPONENT_THROW_LANDING_TERMINATE			(1<<2)

/// called in subsystem_throw and emulated_throw before the datum is created with (target, range, speed, flags, thrower, cb_on_hit, cb_on_land, emulated); you can stop the throw at this point.
#define COMSIG_MOVABLE_PRE_THROW				"pre_throw"
	/// cancel the throw
	#define COMPONENT_CANCEL_PRE_THROW					(1<<0)
/// called in subsystem_throw and emulated_throw after the datum is created with (target, range, speed, flags, thrower, cb_on_hit, cb_on_land, emulated); it is now too late to cancel the throw.
#define COMSIG_MOVABLE_POST_THROW				"post_throw"
/// called in _init_throw_datum  during both subsystem and emulated throw with (target, range, speed, flags, thrower, cb_on_hit, cb_on_land, emulated)
#define COMSIG_MOVABLE_INIT_THROW				"init_throw"

