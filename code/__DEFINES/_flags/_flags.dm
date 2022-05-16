///MARK ALL FLAG CHANGES IN _globals/bitfields.dm!
///All flags should go in here if possible.
/// For convenience.
#define ALL (~0)
#define NONE 0

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)

// For convenience
#define ENABLE_BITFIELD(variable, flag)				(variable |= (flag))
#define DISABLE_BITFIELD(variable, flag)			(variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag)				(variable & (flag))
#define TOGGLE_BITFIELD(variable, flag) (variable ^= (flag))
#define COPY_SPECIFIC_BITFIELDS(a,b,flags)\
	do{\
		var/_old = a & ~(flags);\
		var/_cleaned = b & (flags);\
		a = _old | _cleaned;\
	} while(0);
// Check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags)	((flagvar & (flags)) == flags)

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield,index)  ((bitfield)  &   (1 << (index)))
#define BITSET(bitfield,index)   (bitfield)  |=  (1 << (index))
#define BITRESET(bitfield,index) (bitfield)  &= ~(1 << (index))
#define BITFLIP(bitfield,index)  (bitfield)  ^=  (1 << (index))

GLOBAL_LIST_INIT(bitflags, list(
	1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
	1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
	1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23
))

// for /datum/var/datum_flags
#define DF_USE_TAG		(1<<0)
#define DF_VAR_EDITED	(1<<1)
#define DF_ISPROCESSING (1<<2)

///FLAG BITMASKS - Used in /atom/var/flags
/// Atom is admin spawned
#define ADMIN_SPAWNED				(1<<3)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define HEAR						(1<<4)
/// The atom is initialized
#define INITIALIZED					(1<<5)
/// Used for items if they don't want to get a blood overlay.
#define NOBLOODY					(1<<6)
/// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define NOBLUDGEON					(1<<7)
/// Reagents don't react inside this container.
#define NOREACT						(1<<8)
/// Doesn't Conduct electricity. (metal etc.)
#define NOCONDUCT					(1<<9)
/// Item has priority to check when entering or leaving.
#define ON_BORDER					(1<<10)
/// Is an open container for chemistry purposes.
#define OPENCONTAINER				(1<<11)
/// Atom queued to SSoverlay for COMPILE_OVERLAYS
#define OVERLAY_QUEUED				(1<<12)
/// Does not get contaminated by phoron.
#define PHORONGUARD					(1<<13)
/// Does this object require proximity checking in Enter()?
#define PROXMOVE					(1<<14)
/// Does not leave user's fingerprints/fibers when used on things?
#define NOPRINT						(1<<15)
///CITMAIN FLAG BITMASKS - Completely unused
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
#define HTML_USE_INITAL_ICON		(1<<23)

///TURF FLAGS
/// This is used in literally one place, turf.dm, to block ethereal jaunt.
#define NO_JAUNT					(1<<0)
/// Distance from edge to move to another z-level.
#define TRANSITIONEDGE				(1<<1)
/// Unused reservation turf
#define UNUSED_RESERVATION_TURF		(1<<2)
///CITMAIN TURF FLAGS - Completely unused
/// If a turf can be made dirty at roundstart. This is also used in areas.
#define CAN_BE_DIRTY				(1<<3)
/// Should this tile be cleaned up and reinserted into an excited group?
#define EXCITED_CLEANUP				(1<<4)
/// Blocks lava rivers being generated on the turf
#define NO_LAVA_GEN					(1<<5)
/// Blocks ruins spawning on the turf
#define NO_RUINS					(1<<6)
// Update flags for [/atom/proc/update_appearance]
/// Update the atom's name
#define UPDATE_NAME (1<<0)
/// Update the atom's desc
#define UPDATE_DESC (1<<1)
/// Update the atom's icon state
#define UPDATE_ICON_STATE (1<<2)
/// Update the atom's overlays
#define UPDATE_OVERLAYS (1<<3)
/// Update the atom's greyscaling
#define UPDATE_GREYSCALE (1<<4)
/// Update the atom's smoothing. (More accurately, queue it for an update)
#define UPDATE_SMOOTHING (1<<5)
/// Update the atom's icon
#define UPDATE_ICON (UPDATE_ICON_STATE|UPDATE_OVERLAYS)

// Flags for pass_flags. - Used in /atom/var/pass_flags
#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)

//silicon_privileges flags on /mob
#define PRIVILEGES_SILICON	(1<<0)
#define PRIVILEGES_PAI		(1<<1)
#define PRIVILEGES_BOT		(1<<2)
#define PRIVILEGES_DRONE	(1<<3)

//Mob mobility var flags
/// any flag
#define CHECK_MOBILITY(target, flags) (target.mobility_flags & flags)
#define CHECK_ALL_MOBILITY(target, flags) CHECK_MULTIPLE_BITFIELDS(target.mobility_flags, flags)

/// can move
#define MOBILITY_MOVE			(1<<0)
/// can, and is, standing up.
#define MOBILITY_STAND			(1<<1)
/// can pickup items
#define MOBILITY_PICKUP			(1<<2)
/// can use items and interact with world objects like opening closets/etc
#define MOBILITY_USE			(1<<3)
/// can use interfaces like consoles
#define MOBILITY_UI				(1<<4)
/// can use storage item
#define MOBILITY_STORAGE		(1<<5)
/// can pull things
#define MOBILITY_PULL			(1<<6)
/// can hold non-nodropped items voluntarily
#define MOBILITY_HOLD			(1<<7)
/// Can resist out of buckling, grabs, cuffs, etc, in the usual order (buckle --> cuffs --> grab)
#define MOBILITY_RESIST			(1<<8)

#define MOBILITY_FLAGS_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL | MOBILITY_RESIST)
#define MOBILITY_FLAGS_ANY_INTERACTION (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_UI | MOBILITY_STORAGE)
