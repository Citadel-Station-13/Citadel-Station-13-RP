/mob/living/simple_mob/examine(mob/user, dist)
	. = ..()
	if(stat != DEAD && user && harvest_tool && (get_dist(user, src) <= 3))
		. += SPAN_NOTICE("\The [src] can be [harvest_verb] with a [initial(harvest_tool.name)] every [round(harvest_cooldown, 0.1)] minutes.")
		var/time_to_harvest = (harvest_recent + harvest_cooldown) - world.time
		if(time_to_harvest > 0)
			. += SPAN_NOTICE("It can be [harvest_verb] in [time_to_harvest / (1 MINUTE)] second(s).")
		else
			. += SPAN_NOTICE("It can be [harvest_verb] now.")

/mob/living/simple_mob/proc/livestock_harvest(var/obj/item/tool, var/mob/living/user)
	if(!LAZYLEN(harvest_results))	// Might be a unique interaction of an object using the proc to do something weird, or just someone's a donk.
		harvest_recent = world.time
		return

	if(istype(tool, harvest_tool))	// Sanity incase something incorrect is passed in.
		harvest_recent = world.time

		var/max_harvests = rand(1,harvest_per_hit)

		for(var/I = 1 to max_harvests)
			var/new_path = pickweight(harvest_results)
			new new_path(get_turf(user))

	return
