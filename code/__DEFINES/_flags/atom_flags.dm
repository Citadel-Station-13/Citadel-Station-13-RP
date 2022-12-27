///FLAG BITMASKS - Used in /atom/var/flags
/// The atom is initialized
#define ATOM_INITIALIZED					(1<<0)
/// Item has priority to check when entering or leaving.
#define ATOM_BORDER					(1<<1)
/// Atom is admin spawned
#define ATOM_ADMINSPAWNED				(1<<2)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define ATOM_HEAR						(1<<3)
/// Atom queued to SSoverlay for COMPILE_OVERLAYS
#define ATOM_OVERLAY_QUEUED				(1<<4)
/// atom is absolute-abstract - should not be interactable or movable in any way shape or form
#define ATOM_ABSTRACT				(1<<5)
/// we are an holographic atom from a holodeck/AR system
// todo: should this be an atom flag?
#define HOLOGRAM					(1<<6)
/// Used for items if they don't want to get a blood overlay.
// TODO: item flag
#define NOBLOODY					(1<<7)
/// Reagents don't react inside this container.
// TODO: reagent holder flag
#define NOREACT						(1<<7)
/// Doesn't Conduct electricity. (metal etc.)
// TODO: item flag
#define NOCONDUCT					(1<<10)
/// Is an open container for chemistry purposes.
// TODO: reagent holder flags
#define OPENCONTAINER				(1<<11)
/// Does not get contaminated by phoron.
// TODO: item flag
#define PHORONGUARD					(1<<13)
/// Does not leave user's fingerprints/fibers when used on things?
// TODO: item flag
#define NOPRINT						(1<<15)
///CITMAIN FLAG BITMASKS - Completely unused
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

//! /atom/var/resistance_flags
/// 100% immune to effects of lava (minus fire)
#define RESIST_LAVA_PROOF (1<<0)
/// 100% immune to effects of fire (minus the act of being on fire)
#define RESIST_FIRE_PROOF (1<<1)
/// can be set on fire - cannot be set on fire without this (but might still manual fire damage)
#define RESIST_IS_FLAMMABLE (1<<2)
/// we are on fire
#define RESIST_ON_FIRE (1<<3)
/// acid cannot cling to us
#define RESIST_UNACIDABLE (1<<4)
/// acid cannot damage us
#define RESIST_ACID_PROOF (1<<5)
/// cannot be flash-frozen
#define RESIST_FREEZE_PROOF (1<<6)
/// doesn't take damage, do not pass go
#define RESIST_INDESTRUCTIBLE (1<<7)

DEFINE_BITFIELD(resistance_flags, list(
	BITFIELD(RESIST_LAVA_PROOF),
	BITFIELD(RESIST_FIRE_PROOF),
	BITFIELD(RESIST_IS_FLAMMABLE),
	BITFIELD(RESIST_ON_FIRE),
	BITFIELD(RESIST_UNACIDABLE),
	BITFIELD(RESIST_ACID_PROOF),
	BITFIELD(RESIST_FREEZE_PROOF),
	BITFIELD(RESIST_INDESTRUCTIBLE),
))
