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
#define AF_ABSTRACT					(1<<5)
/// we are an holographic atom from a holodeck/AR system
#define HOLOGRAM					(1<<6)

/// Used for items if they don't want to get a blood overlay.
#define NOBLOODY					(1<<7)
/// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define NOBLUDGEON					(1<<8)
/// Reagents don't react inside this container.
#define NOREACT						(1<<7)
/// Doesn't Conduct electricity. (metal etc.)
#define NOCONDUCT					(1<<10)
/// Is an open container for chemistry purposes.
#define OPENCONTAINER				(1<<11)
/// Does not get contaminated by phoron.
#define PHORONGUARD					(1<<13)
/// Does this object require proximity checking in Enter()?
#define PROXMOVE					(1<<14)
/// Does not leave user's fingerprints/fibers when used on things?
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
#define HOLOGRAM					(1<<21)
/// should not get harmed if this gets caught by an explosion?
#define PREVENT_CONTENTS_EXPLOSION	(1<<22)
*/
#define HTML_USE_INITAL_ICON		(1<<23)

// Flags for pass_flags. - Used in /atom/var/pass_flags
#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)

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
