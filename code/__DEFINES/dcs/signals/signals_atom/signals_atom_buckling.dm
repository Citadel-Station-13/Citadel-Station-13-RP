#warn impl below
//! buckling. flags are always buckling opflags, see __DEFINES/procs/buckling.dm
/// called on mob buclked: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_MOB_BUCKLED			"mob_buckled"
/// called on mob unbuckled: (mob, flags, user, semantic)
#define COMSIG_MOVABLE_MOB_UNBUCKLED		"mob_unbuckled"
//! weird names to be more distinct from movable signals
/// called on the mob that just got buckled: (mob, flags, user, semantic)
#define COMSIG_MOB_BUCKLED					"buckled"
/// called on the mob that just got unbuckled: (mob, flags, user, semantic)
#define COMSIG_MOB_UNBUCKLED				"unbuckled"

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
#define COMSIG_MOB_CAN_BUCKLE				"mob_can_buckle"
/// called during can unbuckle on mob: (AM, flags, user, semantic, movable_opinion)
#define COMSIG_MOB_CAN_UNBUCKLE				"mob_can_unbuckle"
	/// block mob buckle/unbuckle **silently**
	#define COMPONENT_BLOCK_BUCKLE_OPERATION		(1<<0)
	/// force allow buckle/unbuckled **silently**
	#define COMPONENT_FORCE_BUCKLE_OPERATION		(1<<1)
