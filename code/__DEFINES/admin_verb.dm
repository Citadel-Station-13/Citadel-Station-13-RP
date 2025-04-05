// This port is currently half-assed, we do not include the entire avd stuff

/// Use this to mark your verb as not having a description. Should ONLY be used if you are also hiding the verb!
#define ADMIN_VERB_NO_DESCRIPTION ""
/// Used to verbs you do not want to show up in the master verb panel.
#define ADMIN_CATEGORY_HIDDEN null

// Admin verb categories
#define ADMIN_CATEGORY_MAIN "Admin"
#define ADMIN_CATEGORY_EVENTS "Admin.Events"
#define ADMIN_CATEGORY_FUN "Admin.Fun"
#define ADMIN_CATEGORY_GAME "Admin.Game"
#define ADMIN_CATEGORY_SHUTTLE "Admin.Shuttle"

// Special categories that are separated
#define ADMIN_CATEGORY_DEBUG "Debug"
#define ADMIN_CATEGORY_SERVER "Server"
#define ADMIN_CATEGORY_OBJECT "Object"
#define ADMIN_CATEGORY_MAPPING "Mapping"
#define ADMIN_CATEGORY_PROFILE "Profile"
#define ADMIN_CATEGORY_IPINTEL "Admin.IPIntel"

// Visibility flags
#define ADMIN_VERB_VISIBLITY_FLAG_MAPPING_DEBUG "Map-Debug"
