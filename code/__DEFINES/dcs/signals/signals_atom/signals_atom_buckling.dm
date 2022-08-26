#warn impl below
//! buckling. flags are always buckling opflags, see __DEFINES/procs/buckling.dm
/// called on mob buclked: (mob, flags, user)
#define COMSIG_MOVABLE_MOB_BUCKLED			"mob_buckled"
/// called on mob unbuckled: (mob, flags, user)
#define COMSIG_MOVABLE_MOB_UNBUCKLED		"mob_unbuckled"
/// called on the mob that just got buckled: (mob, flags, user)
#define COMSIG_MOB_BUCKLED					"buckled"
/// called on the mob that just got unbuckled: (mob, flags, user)
#define COMSIG_MOB_UNBUCKLED				"unbuckled"

/// called during can buckle mob: (mob, flags, user)
#define COMSIG_MOVABLE_CAN_BUCKLE_MOB		"can_buckle_mob"
/// called during can unbuckle mob: (mob, flags, user)
#define COMSIG_MOVABLE_CAN_UNBUCKLE_MOB		"can_unbuckle_mob"
/// called during user buckle mob: (mob, flags, user)
#define COMSIG_MOVABLE_USER_BUCKLE_MOB		"user_buckle_mob"
/// called during user unbuckle mob: (mob, flags, user)
#define COMSIG_MOVABLE_USER_UNBUCKLE_MOB	"user_unbuckle_mob"
/// called during can buckle
	/// block mob buckle/unbuckle **silently**
	#define COMPONENT_BLOCK_BUCKLE_OPERATION		(1<<0)
