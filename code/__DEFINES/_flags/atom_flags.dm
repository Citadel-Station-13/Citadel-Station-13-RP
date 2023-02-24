//! FLAG BITMASKS - Used in /atom/var/flags
/// The atom is initialized
#define ATOM_INITIALIZED    (1<<0)
/// Item has priority to check when entering or leaving.
#define ATOM_BORDER         (1<<1)
/// Atom is admin spawned
#define ATOM_ADMINSPAWNED   (1<<2)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define ATOM_HEAR           (1<<3)
/// Atom queued to SSoverlay for compile_overlays
#define ATOM_OVERLAY_QUEUED (1<<4)
/// Atom is absolute-abstract - should not be interactable or movable in any way shape or form
#define ATOM_ABSTRACT       (1<<5)
/// We are an holographic atom from a holodeck/AR system
#define HOLOGRAM            (1<<6) // TODO: should this be an atom flag?
/// Used for items if they don't want to get a blood overlay.
#define NOBLOODY            (1<<7) // TODO: item flag
/// Reagents don't react inside this container.
#define NOREACT             (1<<8) // TODO: reagent holder flag
/// Doesn't Conduct electricity. (metal etc.)
#define NOCONDUCT           (1<<9) // TODO: item flag
/// Is an open container for chemistry purposes.
#define OPENCONTAINER       (1<<10) // TODO: reagent holder flags
/// Does not get contaminated by phoron.
#define PHORONGUARD         (1<<11) // TODO: item flag
/// Does not leave user's fingerprints/fibers when used on things?
#define NOPRINT             (1<<12) // TODO: item flag
///CITMAIN FLAG BITMASKS - Completely unused.
/*
/// Early returns mob.face_atom()
#define BLOCK_FACE_ATOM				(1<<16)
/// Prevents mobs from getting chainshocked by teslas and the supermatter.
#define SHOCKED						(1<<17)
/// Projectiles will use default chance-based ricochet handling on things with this.
#define DEFAULT_RICOCHET			(1<<18)
/// For machines and structures that should not break into parts, eg, holodeck stuff.
#define NODECONSTRUCT				(1<<19)
/// Prevent clicking things below it on the same turf eg. doors/ fulltile windows.
#define PREVENT_CLICK_UNDER			(1<<20)
/// should not get harmed if this gets caught by an explosion?
#define PREVENT_CONTENTS_EXPLOSION	(1<<22)
*/
#define HTML_USE_INITAL_ICON		(1<<23)

DEFINE_BITFIELD(atom_flags, list(
	BITFIELD(ATOM_INITIALIZED),
	BITFIELD(ATOM_BORDER),
	BITFIELD(ATOM_ADMINSPAWNED),
	BITFIELD(ATOM_HEAR),
	BITFIELD(ATOM_OVERLAY_QUEUED),
	BITFIELD(ATOM_ABSTRACT),
	BITFIELD(HOLOGRAM),
	BITFIELD(NOBLOODY),
	BITFIELD(NOREACT),
	BITFIELD(NOCONDUCT),
	BITFIELD(OPENCONTAINER),
	BITFIELD(PHORONGUARD),
	BITFIELD(NOPRINT),
))

//! /atom/movable/var/movable_flags
/// Throwing does not scale damage at all regardless of force.
#define MOVABLE_NO_THROW_SPEED_SCALING  (1<<0)
/// Throwing should ignore move force scaling entirely.
#define MOVABLE_NO_THROW_DAMAGE_SCALING (1<<1)
/// Do not spin when thrown.
#define MOVABLE_NO_THROW_SPIN           (1<<2)

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
/// let buckled mobs pass always
#define ATOM_PASS_BUCKLED			(1<<8)

DEFINE_BITFIELD(pass_flags, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
	BITFIELD(ATOM_PASS_OVERHEAD_THROW),
	BITFIELD(ATOM_PASS_BUCKLED),
))

DEFINE_BITFIELD(pass_flags_self, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
	BITFIELD(ATOM_PASS_OVERHEAD_THROW),
	BITFIELD(ATOM_PASS_BUCKLED),
))

//! /atom/movable movement_type
/// Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.
#define UNSTOPPABLE  (1<<0)
/// Ground movement.
#define GROUND       (1<<1)
/// Flying movement.
#define FLYING       (1<<2)
/// Phasing movement (phazons, shadekins, etc).
#define PHASING      (1<<3)
/// Floating movement like no gravity etc etc.
#define FLOATING     (1<<4)
/// Ventcrawling.
#define VENTCRAWLING (1<<5)

DEFINE_BITFIELD(movement_type, list(
	BITFIELD(UNSTOPPABLE),
	BITFIELD(GROUND),
	BITFIELD(FLYING),
	BITFIELD(PHASING),
	BITFIELD(FLOATING),
	BITFIELD(VENTCRAWLING),
))

//! /atom/movable buckle_flags
/// Requires restrained() (usually handcuffs) to work.
#define BUCKLING_REQUIRES_RESTRAINTS          (1<<0)
/// Buckling doesn't allow you to pull the person to try to move the object (assuming the object otherwise can be pulled). This does NOT stop them from pulling the buckled object!
#define BUCKLING_PREVENTS_PULLING             (1<<1)
/// Automatically pass projectiles hitting us up.
#define BUCKLING_PASS_PROJECTILES_UPWARDS     (1<<2) // todo: implement
/// Do not allow players to do drag/drop buckling.
#define BUCKLING_NO_DEFAULT_BUCKLE            (1<<3)
/// Do not allow players to perform default click interaction unbuckling.
#define BUCKLING_NO_DEFAULT_UNBUCKLE          (1<<4)
/// Do not allow players to resist out of buckling by default.
#define BUCKLING_NO_DEFAULT_RESIST            (1<<5)
/// Don't let us buckle people to ourselves.
#define BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF (1<<6)
/// Lets the user avoid step checks.
#define BUCKLING_GROUND_HOIST				  (1<<7)

DEFINE_BITFIELD(buckle_flags, list(
	BITFIELD(BUCKLING_REQUIRES_RESTRAINTS),
	BITFIELD(BUCKLING_PREVENTS_PULLING),
	BITFIELD(BUCKLING_PASS_PROJECTILES_UPWARDS),
	BITFIELD(BUCKLING_NO_DEFAULT_BUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_UNBUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_RESIST),
	BITFIELD(BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF),
	BITFIELD(BUCKLING_GROUND_HOIST),
))
