GLOBAL_LIST_EMPTY(clients) //all clients
GLOBAL_LIST_EMPTY(admins) //all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins) //all ckeys who have used the de-admin verb.

GLOBAL_LIST_EMPTY(directory) //all ckeys with associated client
GLOBAL_LIST_EMPTY(stealthminID) //reference list with IDs that store ckeys, for stealthmins

/// List of types of abstract mob which shouldn't usually exist in the world on its own if we're spawning random mobs
GLOBAL_LIST_INIT(abstract_mob_types, list(
	/mob/living/carbon/human/dummy,
	))


GLOBAL_LIST_EMPTY(player_list) //all mobs **with clients attached**.
GLOBAL_LIST_EMPTY(mob_list) //all mobs, including clientless
GLOBAL_LIST_EMPTY(alive_mob_list) //all alive mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(suicided_mob_list) //contains a list of all mobs that suicided, including their associated ghosts.
GLOBAL_LIST_EMPTY(dead_mob_list) //all dead mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(joined_player_list) //all ckeys that have joined the game at round-start or as a latejoin.
GLOBAL_LIST_EMPTY(new_player_list) //all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.
GLOBAL_LIST_EMPTY(silicon_mobs) //all silicon mobs
GLOBAL_LIST_EMPTY(mob_living_list) //all instances of /mob/living and subtypes
GLOBAL_LIST_EMPTY(carbon_list) //all instances of /mob/living/carbon and subtypes, notably does not contain brains or simple animals
GLOBAL_LIST_EMPTY(human_list) //all instances of /mob/living/carbon/human and subtypes
GLOBAL_LIST_EMPTY(ai_list)

/// All alive mobs with clients.
GLOBAL_LIST_EMPTY(alive_player_list)

/// All dead mobs with clients. Does not include observers.
GLOBAL_LIST_EMPTY(dead_player_list)

/// All observers with clients that joined as observers.
GLOBAL_LIST_EMPTY(current_observers_list)
