GLOBAL_LIST_EMPTY(admins) //all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins)							//all ckeys who have used the de-admin verb.
GLOBAL_PROTECT(deadmins)
GLOBAL_LIST_EMPTY(stealthminID)
GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client
GLOBAL_LIST_EMPTY(clients)
GLOBAL_LIST_EMPTY(players_by_zlevel)			//TODO: port to dead_players_by_zlevel and clients_by_zlevel like on /tg/station's SSmobs
GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.
