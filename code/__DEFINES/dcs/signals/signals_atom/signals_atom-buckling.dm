//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* --           Buckling          -- *//
//* flags are always buckling opflags *//
//*  see __DEFINES/procs/buckling.dm  *//

//* These are called when the buckle/unbuckle op have already happened *//

/// called on the atom the mob buckled to: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_MOB_BUCKLED			"mob_buckled"
/// called on the atom the mob unbuckled from: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_MOB_UNBUCKLED		"mob_unbuckled"
/// called on the mob that just got buckled: (mob, flags, user, semantic)
#define COMSIG_MOB_BUCKLED_TO					"buckled"
/// called on the mob that just got unbuckled: (mob, flags, user, semantic)
#define COMSIG_MOB_UNBUCKLED_FROM				"unbuckled"

//* For the below, SIGNAL_RETURN_(BLOCK|FORCE)_BUCKLE_OPERATION works to varying degrees on varying procs. *//

/// called during mob buckling: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_PRE_BUCKLE_MOB		"pre_buckle_mob"
/// called during can buckle mob: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_CAN_BUCKLE_MOB		"can_buckle_mob"
/// called during can unbuckle mob: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_CAN_UNBUCKLE_MOB		"can_unbuckle_mob"
/// called during user buckle mob: (mob, flags, user, semantic). only "block" is allowed.
#define COMSIG_MOVABLE_USER_BUCKLE_MOB		"user_buckle_mob"
/// called during user unbuckle mob: (mob, flags, user, semantic). only "block" is allowed.
#define COMSIG_MOVABLE_USER_UNBUCKLE_MOB	"user_unbuckle_mob"
/// called on mob resist buckle: (mob, semantic). Can't force, can only block.
#define COMSIG_MOVABLE_MOB_RESIST_BUCKLE	"mob_resist_buckle"
/// called during can buckle on mob: (AM, flags, user, semantic, movable_opinion)
#define COMSIG_MOB_CAN_BUCKLE_TO				"mob_can_buckle"
/// called during can unbuckle on mob: (AM, flags, user, semantic, movable_opinion)
#define COMSIG_MOB_CAN_UNBUCKLE_FROM				"mob_can_unbuckle"
	/// block mob buckle/unbuckle **silently**
	#define SIGNAL_RETURN_BLOCK_BUCKLE_OPERATION		(1<<0)
	///
	/// * has priority over [SIGNAL_RETURN_FORCE_BUCKLE_OPERATION] where applicable
	/// force allow buckle/unbuckled **silently**
	#define SIGNAL_RETURN_FORCE_BUCKLE_OPERATION		(1<<1)

//* Interactions; only blocking default interactions work. *//

/// called from drag_drop_buckle_interaction: (A, user)
#define COMSIG_MOVABLE_DRAG_DROP_BUCKLE_INTERACTION "drag_drop_buckle"
/// called from click_unbuckle_interaction: (user)
#define COMSIG_MOVABLE_CLICK_UNBUCKLE_INTERACTION "click_unbuckle"
/// called from resist_unbuckle_interaction(M)
#define COMSIG_MOVABLE_RESIST_UNBUCKLE_INTERACTION "resist_unbuckle"
	/// cancel rest of procs
	#define SIGNAL_RETURN_BUCKLE_INTERACTION_HANDLED	(1<<0)
