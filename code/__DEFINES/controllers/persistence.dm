//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Common *//

/// default string for null groups
#define PERSISTENCE_DEFAULT_NULL_GROUP ""
/// check if an /obj has some form of persistence
#define OBJ_HAS_PERSISTENCE_ENABLED(OBJ) (OBJ.persist_static_id || OBJ.persist_dynamic_id)
/// check if an /obj is eligible at all for mass persistence
#define OBJ_MASS_PERSIST_SANITY_CHECK(OBJ) (OBJ_HAS_PERSIST_ENABLED(OBJ) && !(OBJ.obj_persist_status & (OBJ_PERSIST_STATUS_NO_THANK_YOU)))

//* /obj - obj_persist_status *//

/// we loaded in already
#define OBJ_PERSIST_STATUS_LOADED (1<<0)
/// we saved atleast once
#define OBJ_PERSIST_STATUS_SAVED (1<<1)
/// this is the first round we're persisting from
/// for dynamic, this is the round we were made
/// for static, this is the round that we were restored after a deletion
#define OBJ_PERSIST_STATUS_FIRST_GENERATION (1<<2)
/// do not persist
#define OBJ_PERSIST_STATUS_NO_THANK_YOU (1<<3)

//* /obj - obj_persist_dynamic_status *//

/// requires us to be considered alive
#define OBJ_PERSIST_DYNAMIC_STATUS_REQUIRE_SEMANTIC_SURVIVAL (1<<0)
/// requires us to be considered alive and well functioning
#define OBJ_PERSIST_DYNAMIC_STATUS_REQUIRE_HEALTHY_SURVIVAL (1<<1)

//* /obj - obj_persist_static_mode *//

/// bound by level id
#define OBJ_PERSIST_STATIC_MODE_LEVEL "level"
/// bound by map id; if no map, this doesn't persist
#define OBJ_PERSIST_STATIC_MODE_MAP "map"
/// not bound by any id, global
#define OBJ_PERSIST_STATIC_MODE_GLOBAL "global"

//! Misc/Legacy/Unrelated/Don't care/Didn't ask/Ratio'd

// Direct filename paths

#define PERSISTENCE_FILE_BUNKER_PASSTHROUGH				"data/persistence/bunker_passthrough.json"

// Directories

#define PERSISTENCE_MAP_ROOT_DIRECTORY					"data/persistence/maps"
