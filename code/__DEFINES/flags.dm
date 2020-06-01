//MARK ALL FLAG CHANGES IN _globals/bitfields.dm!
//All flags should go in here if possible.
#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag) (variable |= (flag))
#define DISABLE_BITFIELD(variable, flag) (variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag) (variable & (flag))
#define TOGGLE_BITFIELD(variable, flag) (variable ^= (flag))

#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) (((flagvar) & (flags)) == (flags))

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// for /datum/var/datum_flags
#define DF_USE_TAG		(1<<0)
#define DF_VAR_EDITED	(1<<1)
#define DF_ISPROCESSING (1<<2)

// FLAGS BITMASK - Used in /atom/var/flags
// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define NOBLUDGEON				(1<<0)
// Conducts electricity. (metal etc.)
#define NOCONDUCT				(1<<1)
// Item has priority to check when entering or leaving.	
#define ON_BORDER				(1<<2)
// Used for items if they don't want to get a blood overlay.
#define NOBLOODY				(1<<3)
// Is an open container for chemistry purposes.
#define OPENCONTAINER			(1<<4)
// Does not get contaminated by phoron.	
#define PHORONGUARD				(1<<5)
// Reagents don't react inside this container.
#define NOREACT					(1<<6)
// Does this object require proximity checking in Enter()?
#define PROXMOVE				(1<<7)
// Atom queued to SSoverlay for COMPILE_OVERLAYS
#define OVERLAY_QUEUED			(1<<8) 
// Whether /atom/Initialize() has already run for the object.
#define INITIALIZED				(1<<9)
// Was this spawned by an admin? used for stat tracking stuff.
#define ADMIN_SPAWNED			(1<<10)
// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define HEAR					(1<<11)

//turf-only flags
#define NOJAUNT					(1<<0) //_1
// #define UNUSED_RESERVATION_TURF_1	(1<<1)
// If a turf can be made dirty at roundstart. This is also used in areas.
// #define CAN_BE_DIRTY_1				(1<<2)
// Blocks lava rivers being generated on the turf.
//#define NO_LAVA_GEN_1				(1<<6)
// Blocks ruins spawning on the turf.
//#define NO_RUINS_1					(1<<10)

/*
	These defines are used specifically with the atom/pass_flags bitmask
	the atom/checkpass() proc uses them (tables will call movable atom checkpass(PASSTABLE) for example)
*/
//flags for pass_flags
#define PASSTABLE		(1<<0)
#define PASSGLASS		(1<<1)
#define PASSGRILLE		(1<<2)
#define PASSBLOB		(1<<3)
#define PASSMOB			(1<<4)
/* Not yet included
#define PASSCLOSEDTURF	(1<<5)
#define LETPASSTHROW	(1<<6)
*/

//Flags for items (equipment) - Used in /obj/item/var/item_flags
#define THICKMATERIAL			(1<<0)	// Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define AIRTIGHT				(1<<1)	// Functions with internals.
#define NOSLIP					(1<<2)	// Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<3)	// Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL		(1<<4)	// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ALLOW_SURVIVALFOOD		(1<<5)	// Allows special survival food items to be eaten through it
