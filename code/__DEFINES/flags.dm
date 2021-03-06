/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag) (variable |= (flag))
#define DISABLE_BITFIELD(variable, flag) (variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag) (variable & (flag))
#define TOGGLE_BITFIELD(variable, flag) (variable ^= (flag))
#define COPY_SPECIFIC_BITFIELDS(a,b,flags)\
	do{\
		var/_old = a & ~(flags);\
		var/_cleaned = b & (flags);\
		a = _old | _cleaned;\
	} while(0);
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) (((flagvar) & (flags)) == (flags))

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// datum_flags
#define DF_VAR_EDITED			(1<<0)
#define DF_ISPROCESSING			(1<<1)
#define DF_USE_TAG				(1<<2)

// Flags bitmasks. - Used in /atom/var/flags
#define NOBLUDGEON				(1<<0)	// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define NOCONDUCT					(1<<1)	// Conducts electricity. (metal etc.)
#define ON_BORDER				(1<<2)	// Item has priority to check when entering or leaving.
#define NOBLOODY				(1<<3)	// Used for items if they don't want to get a blood overlay.
#define OPENCONTAINER			(1<<4)	// Is an open container for chemistry purposes.
#define PHORONGUARD				(1<<5)	// Does not get contaminated by phoron.
#define NOREACT					(1<<6)	// Reagents don't react inside this container.
#define PROXMOVE				(1<<7)// Does this object require proximity checking in Enter()?
#define OVERLAY_QUEUED			(1<<8)// Atom queued to SSoverlay for COMPILE_OVERLAYS
/// Atom is initialized
#define INITIALIZED				(1<<9)
/// Atom is admin spawned
#define ADMIN_SPAWNED			(1<<10)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define HEAR					(1<<11)


//Flags for items (equipment) - Used in /obj/item/var/item_flags
#define THICKMATERIAL			(1<<0)	// Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define AIRTIGHT				(1<<1)	// Functions with internals.
#define NOSLIP					(1<<2)	// Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<3)	// Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL		(1<<4)	// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ALLOW_SURVIVALFOOD		(1<<5)	// Allows special survival food items to be eaten through it

// Flags for pass_flags. - Used in /atom/var/pass_flags
#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)

// Flags for the clothing_flags var on /obj/item/clothing
//flags for clothing_flags. only 1 exists at the moment because this is an examine refactor not aclothing refactor
#define SCAN_REAGENTS			(1<<10)	// Allows helmets and glasses to scan reagents.

//silicon_privileges flags on /mob
#define PRIVILEGES_SILICON	(1<<0)
#define PRIVILEGES_PAI		(1<<1)
#define PRIVILEGES_BOT		(1<<2)
#define PRIVILEGES_DRONE	(1<<3)

#define KEEP_TOGETHER_ORIGINAL "keep_together_original"

//setter for KEEP_TOGETHER to allow for multiple sources to set and unset it
#define ADD_KEEP_TOGETHER(x, source)\
	if ((x.appearance_flags & KEEP_TOGETHER) && !HAS_TRAIT(x, TRAIT_KEEP_TOGETHER)) ADD_TRAIT(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL); \
	ADD_TRAIT(x, TRAIT_KEEP_TOGETHER, source);\
	x.appearance_flags |= KEEP_TOGETHER

#define REMOVE_KEEP_TOGETHER(x, source)\
	REMOVE_TRAIT(x, TRAIT_KEEP_TOGETHER, source);\
	if(HAS_TRAIT_FROM_ONLY(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL))\
		REMOVE_TRAIT(x, TRAIT_KEEP_TOGETHER, KEEP_TOGETHER_ORIGINAL);\
	else if(!HAS_TRAIT(x, TRAIT_KEEP_TOGETHER))\
	 	x.appearance_flags &= ~KEEP_TOGETHER

//dir macros
///Returns true if the dir is diagonal, false otherwise
#define ISDIAGONALDIR(d) (d&(d-1))
///True if the dir is north or south, false therwise
#define NSCOMPONENT(d)   (d&(NORTH|SOUTH))
///True if the dir is east/west, false otherwise
#define EWCOMPONENT(d)   (d&(EAST|WEST))
///Flips the dir for north/south directions
#define NSDIRFLIP(d)     (d^(NORTH|SOUTH))
///Flips the dir for east/west directions
#define EWDIRFLIP(d)     (d^(EAST|WEST))
///Turns the dir by 180 degrees
#define DIRFLIP(d)       turn(d, 180)

/// 33554431 (2^24 - 1) is the maximum value our bitflags can reach.
#define MAX_BITFLAG_DIGITS 8
