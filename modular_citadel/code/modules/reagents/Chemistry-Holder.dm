/datum/reagents/proc/get_reagent(var/id) // Returns reference to reagent matching passed ID
	for(var/datum/reagent/A in reagent_list)
		if (A.id == id)
			return A

	return null

//Spreads the contents of this reagent holder all over the vicinity of the target turf.
/datum/reagents/proc/splash_area(var/turf/epicentre, var/range = 3, var/portion = 1.0, var/multiplier = 1, var/copy = 0)
	var/list/things = dview(range, epicentre, INVISIBILITY_LIGHTING)

	var/list/turfs = list()
	for (var/turf/T in things)
		turfs += T

	if (!turfs.len)
		return//Nowhere to splash to, somehow

	//Create a temporary holder to hold all the amount that will be spread
	var/datum/reagents/R = new /datum/reagents(total_volume * portion * multiplier)
	trans_to_holder(R, total_volume * portion, multiplier, copy)

	//The exact amount that will be given to each turf
	var/turfportion = R.total_volume / turfs.len
	for (var/turf/T in turfs)
		var/datum/reagents/TR = new /datum/reagents(turfportion)
		R.trans_to_holder(TR, turfportion, 1, 0)
		TR.splash_turf(T)

	qdel(R)


//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever is left on the turf itself
/datum/reagents/proc/splash_turf(var/turf/T, var/amount = null, var/multiplier = 1, var/copy = 0)
	if (isnull(amount))
		amount = total_volume
	else
		amount = min(amount, total_volume)
	if (amount <= 0)
		return

	var/list/mobs = list()
	for (var/mob/M in T)
		mobs += M

	var/list/objs = list()
	for (var/obj/O in T)
		//Todo: Add some check here to not hit wires/pipes that are hidden under floor tiles.
		//Maybe also not hit things under tables.
		objs += O



	if (objs.len)
		var/objportion = (amount * 0.2) / objs.len
		for (var/o in objs)
			var/obj/O = o

			trans_to(O, objportion, multiplier, copy)

	amount = min(amount, total_volume)

	if (mobs.len)
		var/mobportion = (amount * 0.5) / mobs.len
		for (var/m in mobs)
			var/mob/M = m
			trans_to(M, mobportion, multiplier, copy)

	trans_to(T, total_volume, multiplier, copy)

	if (total_volume <= 0)
		qdel(src)