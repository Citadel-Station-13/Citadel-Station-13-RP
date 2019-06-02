GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins)							//all ckeys who have used the de-admin verb.

GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client
GLOBAL_LIST_EMPTY(stealthminID)						//reference list with IDs that store ckeys, for stealthmins

GLOBAL_LIST_EMPTY(bunker_passthrough)

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.
GLOBAL_LIST_EMPTY(mob_list)					//all mobs, including clientless
GLOBAL_LIST_EMPTY(mob_directory)			//mob_id -> mob




GLOBAL_LIST_EMPTY(players_by_zlevel)			//TODO: port to dead_players_by_zlevel and clients_by_zlevel like on /tg/station's SSmobs
