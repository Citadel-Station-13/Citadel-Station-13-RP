// Tram arrival point landmarks and datum
var/global/list/latejoin_tram   = list()

/obj/effect/landmark/tram
	name = "JoinLateTram"
	delete_me = 1

/obj/effect/landmark/tram/New()
	latejoin_tram += loc // Register this turf as tram latejoin.
	latejoin += loc // Also register this turf as fallback latejoin, since we won't have any arrivals shuttle landmarks.
	..()

/datum/spawnpoint/tram
	display_name = "Tram Station"
	msg = "has arrived on the tram"

/datum/spawnpoint/tram/New()
	..()
	turfs = latejoin_tram