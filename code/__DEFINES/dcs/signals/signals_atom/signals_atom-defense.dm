//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: integrity signals? probably not?

/// called from bullet_act(): (args)
#define COMSIG_ATOM_BULLET_ACT "bullet_act"
	#define BULLET_ACT_ARG_PROJECTILE 1
	/// index of arg for PROJECTILE_IMPACT_* flags
	#define BULLET_ACT_ARG_FLAGS 2
	#define BULLET_ACT_ARG_ZONE 3
	#define BULLET_ACT_ARG_EFFICIENCY 4

/// called from run_armorcalls(): (list/shieldcall_args, fake_attack)
///
/// * This is an extremely low-level signal. Handle with care.
#define COMSIG_ATOM_ARMORCALL "atom-armorcalls"
/// called from run_shieldcalls(): (list/shieldcall_args, fake_attack)
///
/// * This is an extremely low-level signal. Handle with care.
#define COMSIG_ATOM_SHIELDCALL "atom-shieldcalls"

/// called from atom_shieldcall_handle_*l: (ATOM_SHIELDCALL_ITERATING_*)
///
/// * use this for stuff that should spin up a full shield when attacked but is usually inactive.
/// * this is not used for base of /atom_shieldcall(), as it already has a signal!
#define COMSIG_ATOM_SHIELDCALL_ITERATION "atom-shieldcall-iteration"
	/// atom_shieldcall_handle_melee()
	#define ATOM_SHIELDCALL_ITERATING_MELEE (1<<2)
	/// atom_shieldcall_handle_bullet_act()
	#define ATOM_SHIELDCALL_ITERATING_BULLET_ACT (1<<3)
	/// atom_shieldcall_handle_touch()
	#define ATOM_SHIELDCALL_ITERATING_TOUCH (1<<4)
	/// atom_shieldcall_handle_throw_impact()
	#define ATOM_SHIELDCALL_ITERATING_THROW_IMPACT (1<<5)
