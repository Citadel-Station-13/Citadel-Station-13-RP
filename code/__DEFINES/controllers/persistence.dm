//! Object Storage System - General

// persistence type enum
#define OBJECT_PERSISTENCE_LOCATION_MAPPED			1
#define OBJECT_PERSISTENCE_UNIQUE_MAPLOAD			2
#define OBJECT_PERSISTENCE_UNIQUE_GENERIC			3
#define OBJECT_PERSISTENCE_UNIQUE_STRING			4

//! Object Storage System - atom proc opflags
/// when deciding whether or not to persist things, don't persist if they are fully broken/dead
#define PERSIST_OP_CHECK_SEMANTIC_SURVIVAL			(1<<0)
/// when deciding whether or not to persist things, don't persist if they're considered irreversibly damaged/dying. undefined behvaior if SEMANTIC_SURVIVAL is not check
#define PERSIST_OP_AGGRESSIVE_SURVIVAL_CHECK		(1<<1)
/// saving/loading from static onmap
#define PERSIST_OP_STATIC_OBJECT					(1<<2)
/// saving/loading from dynamic onmap
#define PERSIST_OP_DYNAIMC_OBJECT					(1<<3)
/// saving/loading from/into another object's persistence procs
#define PERSIST_OP_NESTED							(1<<4)
/// saving/loading from/to some kind of inventory
#define PERSIST_OP_INVENTORY_OBJECT					(1<<5)

//! Object Storage System - atom persist_flags
/// we loaded already
#define ATOM_PERSIST_LOADED							(1<<0)
/// we saved already
#define ATOM_PERSIST_SAVED							(1<<1)
/// this is the first round we're persisting from
#define ATOM_PERSIST_FIRST_GENERATION				(1<<2)
/// we're active - enables save/load hooks
#define ATOM_PERSIST_ACTIVE							(1<<3)
/// for static persisting objects, data survives qdeletion
#define ATOM_PERSIST_SURVIVE_STATIC_QDELETION		(1<<4)
/// for static persisting objects, data survives being moved off the designated map id. you probably want this by default.
#define ATOM_PERSIST_SURVIVE_STATIC_OFFMAP			(1<<5)
/// for all persisting objects, get_turf(src) for z detection. can get really weird, use sparingly.
#define ATOM_PERSIST_UNWRAPS_ONTO_TURF				(1<<6)


#warn define bitfields

//! Object Storage Sysstem - atom persist_flags_dynamic
/// dynamic persistence: we care about survival
#define ATOM_PERSIST_DYNAMIC_REQUIRE_SEMANTIC_SURVIVAL			(1<<0)
/// dynamic persistence: we REALLY care about survival
#define ATOM_PERSIST_DYNAMIC_SURVIVAL_OF_THE_FITTEST			(1<<1)

//! Object Storage System - Location Mapped - SQL flags
/// we deleted this level, pretend it's gone
#define MASS_PERSISTENCE_LEVEL_IS_DELETED										(1<<0)

//! Misc/Legacy/Unrelated/Don't care/Didn't ask/Ratio'd

// Direct filename paths

#define PERSISTENCE_FILE_BUNKER_PASSTHROUGH				"data/persistence/bunker_passthrough.json"

// Directories

#define PERSISTENCE_MAP_ROOT_DIRECTORY					"data/persistence/maps"
