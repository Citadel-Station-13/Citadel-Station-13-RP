// Re-aliased tg defines
#define ADMIN_VERB(verb_path_name, verb_permissions, verb_name, verb_desc, verb_category, verb_args...) \
_ADMIN_VERB_DEF_INTERNAL(verb_path_name, verb_permissions, verb_name, verb_desc, verb_category, FALSE, ##verb_args)

#define ADMIN_VERB_ONLY_CONTEXT_MENU(verb_path_name, verb_permissions, verb_name, verb_args...) \
_ADMIN_VERB_DEF_INTERNAL(verb_path_name, verb_permissions, verb_name, ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, TRUE, ##verb_args)

#define ADMIN_VERB_AND_CONTEXT_MENU(verb_path_name, verb_permissions, verb_name, verb_desc, verb_category, verb_args...) \
_ADMIN_VERB_DEF_INTERNAL(verb_path_name, verb_permissions, verb_name, verb_desc, verb_category, TRUE, ##verb_args)

/*
 * This is an example of how to use the above macro:
 * ```
 * ADMIN_VERB(name_of_verb, R_ADMIN, "Verb Name", "Verb Desc", "Verb Category", mob/target in world)
 *     to_chat(user, "Hello!")
 * ```
 * Note the implied `client/user` argument that is injected into the verb.
 * Also note that byond is shit and you cannot multi-line the macro call.
 */

/// Use this to mark your verb as not having a description. Should ONLY be used if you are also hiding the verb!
#define ADMIN_VERB_NO_DESCRIPTION ""
/// Used to verbs you do not want to show up in the master verb panel.
#define ADMIN_CATEGORY_HIDDEN null

// Admin verb categories
#define ADMIN_CATEGORY_MAIN "Admin"
#define ADMIN_CATEGORY_EVENTS "Events"
#define ADMIN_CATEGORY_FUN "Fun"
#define ADMIN_CATEGORY_GAME "Game"
#define ADMIN_CATEGORY_SHUTTLE "Shuttle"

// Special categories that are separated
#define ADMIN_CATEGORY_DEBUG "Debug"
#define ADMIN_CATEGORY_SERVER "Server"
#define ADMIN_CATEGORY_OBJECT "Object"
#define ADMIN_CATEGORY_MAPPING "Mapping"
#define ADMIN_CATEGORY_PROFILE "Profile"
#define ADMIN_CATEGORY_IPINTEL "IPIntel"

