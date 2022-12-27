
//! /atom/movable/var/movable_flags
/// throwing does not scale damage at all regardless of force
#define MOVABLE_NO_THROW_SPEED_SCALING			(1<<0)
/// throwing should ignore move force scaling entirely
#define MOVABLE_NO_THROW_DAMAGE_SCALING			(1<<1)
/// do not spin when thrown
#define MOVABLE_NO_THROW_SPIN					(1<<2)

DEFINE_BITFIELD(movable_flags, list(
	BITFIELD(MOVABLE_NO_THROW_SPEED_SCALING),
	BITFIELD(MOVABLE_NO_THROW_DAMAGE_SCALING),
	BITFIELD(MOVABLE_NO_THROW_SPIN),
))

// Flags for pass_flags. - Used in /atom/movable/var/pass_flags, and /atom/var/pass_flags_self
#define ATOM_PASS_TABLE				(1<<0)
#define ATOM_PASS_GLASS				(1<<1)
#define ATOM_PASS_GRILLE			(1<<2)
#define ATOM_PASS_BLOB				(1<<3)
#define ATOM_PASS_MOB				(1<<4)
/// let thrown objects pass; only makes sense on pass_flags_self
#define ATOM_PASS_THROWN			(1<<5)
/// Let clicks pass through even if dense
#define ATOM_PASS_CLICK				(1<<6)
/// let overhand thrown objects pass, unless it's directly targeting us
#define ATOM_PASS_OVERHEAD_THROW	(1<<7)

DEFINE_BITFIELD(pass_flags, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
	BITFIELD(ATOM_PASS_OVERHEAD_THROW),
))

DEFINE_BITFIELD(pass_flags_self, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
))

// /atom/movable movement_type
/// Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.
#define UNSTOPPABLE				(1<<0)
/// Ground movement
#define GROUND					(1<<1)
/// Flying movement
#define FLYING					(1<<2)
/// Phasing movement (phazons, shadekins, etc)
#define PHASING					(1<<3)
/// Floating movement like no gravity etc etc
#define FLOATING				(1<<4)
/// Ventcrawling
#define VENTCRAWLING			(1<<5)

DEFINE_BITFIELD(movement_type, list(
	BITFIELD(UNSTOPPABLE),
	BITFIELD(GROUND),
	BITFIELD(FLYING),
	BITFIELD(PHASING),
	BITFIELD(FLOATING),
	BITFIELD(VENTCRAWLING),
))

//! /atom/movable buckle_flags
/// requires restrained() (usually handcuffs) to work
#define BUCKLING_REQUIRES_RESTRAINTS					(1<<0)
/// buckling doesn't allow you to pull the person to try to move the object (assuming the object otherwise can be pulled). This does NOT stop them from pulling the buckled object!
#define BUCKLING_PREVENTS_PULLING						(1<<1)
/// automatically pass projectiles hitting us up
// todo: implement
#define BUCKLING_PASS_PROJECTILES_UPWARDS				(1<<2)
/// do not allow players to do drag/drop buckling
#define BUCKLING_NO_DEFAULT_BUCKLE							(1<<3)
/// do not allow players to perform default click interaction unbuckling
#define BUCKLING_NO_DEFAULT_UNBUCKLE						(1<<4)
/// do not allow players to resist out of buckling by default
#define BUCKLING_NO_DEFAULT_RESIST							(1<<5)
/// don't let us buckle people to ourselves
#define BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF			(1<<6)

DEFINE_BITFIELD(buckle_flags, list(
	BITFIELD(BUCKLING_REQUIRES_RESTRAINTS),
	BITFIELD(BUCKLING_PREVENTS_PULLING),
	BITFIELD(BUCKLING_PASS_PROJECTILES_UPWARDS),
	BITFIELD(BUCKLING_NO_DEFAULT_BUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_UNBUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_RESIST),
	BITFIELD(BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF),
))
