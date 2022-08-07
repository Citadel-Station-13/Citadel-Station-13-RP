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

//! Object Storage System - atom persistence_flags
/// we loaded already
#define ATOM_PERSIST_LOADED							(1<<0)
/// we saved already
#define ATOM_PERSIST_SAVED							(1<<1)
/// this is the first round we're persisting from
#define ATOM_PERSIST_FIRST_GENERATION				(1<<2)

//! Misc/Legacy/Unrelated/Don't care/Didn't ask/Ratio'd

// Direct filename paths

#define PERSISTENCE_FILE_BUNKER_PASSTHROUGH				"data/persistence/bunker_passthrough.json"

// Directories

#define PERSISTENCE_MAP_ROOT_DIRECTORY					"data/persistence/maps"
