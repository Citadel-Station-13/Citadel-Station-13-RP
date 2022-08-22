///FLAG BITMASKS - Used in /atom/var/flags
/// The atom is initialized
#define INITIALIZED					(1<<0)
/// Item has priority to check when entering or leaving.
#define ON_BORDER					(1<<1)
/// Atom is admin spawned
#define ADMIN_SPAWNED				(1<<2)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define HEAR						(1<<3)
/// Atom queued to SSoverlay for COMPILE_OVERLAYS
#define OVERLAY_QUEUED				(1<<4)
/// atom is absolute-abstract - should not be interactable or movable in any way shape or form
#define ATOM_ABSTRACT				(1<<5)
/// we are an holographic atom from a holodeck/AR system
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
/// Does this object require proximity checking in Enter()?
// TODO: kill with fire
#define PROXMOVE					(1<<14)
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

DEFINE_BITFIELD(flags, list(
	BITFIELD(INITIALIZED),
	BITFIELD(ON_BORDER),
	BITFIELD(ADMIN_SPAWNED),
	BITFIELD(HEAR),
	BITFIELD(OVERLAY_QUEUED),
	BITFIELD(ATOM_ABSTRACT),
	BITFIELD(HOLOGRAM),
	BITFIELD(NOBLOODY),
	BITFIELD(NOREACT),
	BITFIELD(NOCONDUCT),
	BITFIELD(OPENCONTAINER),
	BITFIELD(PHORONGUARD),
	BITFIELD(PROXMOVE),
	BITFIELD(NOPRINT),
))

// Flags for pass_flags. - Used in /atom/var/pass_flags
#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)

DEFINE_BITFIELD(pass_flags, list(
	BITFIELD(PASSTABLE),
	BITFIELD(PASSGLASS),
	BITFIELD(PASSGRILLE),
	BITFIELD(PASSBLOB),
	BITFIELD(PASSMOB),
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
