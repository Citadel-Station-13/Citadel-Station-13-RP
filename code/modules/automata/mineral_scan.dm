/datum/automata/scan/mineral
	/// who do we show to
	var/mob/user
#warn impl

/datum/automata/scan/mineral/New(on_finish, mob/user)
	..()
	src.user = user

/datum/automata/scan/mineral/act(turf/T, dist)
	#warn impl

