GLOBAL_LIST_INIT(carp_count,list())// a list of Z levels (string), associated with a list of all the carp spawned by carp events

/datum/event/carp_migration
	var/no_show = FALSE // Carp are laggy, so if there is too much stuff going on we're going to dial it down.
	var/spawned_carp	//for debugging purposes only?
	var/carp_per_z = 8
	var/carp_per_event = 5
	has_skybox_image = FALSE
	var/list/players = list()

/datum/event/carp_migration/setup()
	announceWhen = rand(5, 10)
	endWhen += severity*25

/datum/event/carp_migration/proc/count_carps()
	var/total_carps
	var/local_carps
	for(var/Z in GLOB.carp_count)
		var/list/L = GLOB.carp_count[Z]
		total_carps += L.len
		if(text2num(Z) in affecting_z)
			local_carps += L.len

	if(total_carps >= 65)
		no_show = TRUE
	else
		no_show = FALSE

/datum/event/carp_migration/start()
	count_carps()
	if(no_show && prob(95))
		return
	else
		spawn_carp()


/datum/event/carp_migration/announce()
	if(severity > EVENT_LEVEL_MODERATE)
		command_announcement.Announce("A massive migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Exercise external operations with caution.")
	else
		command_announcement.Announce("A large migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Caution is advised.")


/datum/event/carp_migration/proc/spawn_carp(var/num_groups, var/group_size_min, var/group_size_max, var/dir, var/speed)
	var/Z = pick(affecting_z)

	if(!dir)
		dir = pick(GLOB.cardinal)
	if(!speed)
		speed = rand(1,3)

	var/n = rand(severity, severity*2)
	var/I = 0
	while(I < n)
		var/turf/T = get_random_edge_turf(dir,TRANSITIONEDGE + 2, Z)
		if(istype(T,/turf/space))
			var/mob/living/simple_mob/animal/space/M
			if(prob(96))
				M = new /mob/living/simple_mob/animal/space/carp(T)
				I++
			else
				M = new /mob/living/simple_mob/animal/space/carp/large(T)
				I += 3
			LAZYADD(GLOB.carp_count["[Z]"], M)
			spawned_carp ++
			M.throw_at(get_random_edge_turf(GLOB.reverse_dir[dir],TRANSITIONEDGE + 2, Z), 5, speed, callback = CALLBACK(src,/datum/event/carp_migration/proc/check_gib,M))
		if(no_show)
			break

/proc/get_random_edge_turf(var/dir, var/clearance = TRANSITIONEDGE + 1, var/Z)
	if(!dir)
		return

	switch(dir)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/datum/event/carp_migration/proc/check_gib(var/mob/living/simple_mob/hostile/carp/M)	//awesome road kills
	if(M.health <= 0 && prob(60))
		M.gib()

/datum/event/carp_migration/proc/reduce_carp_count(var/mob/M)
	for(var/Z in affecting_z)
		var/list/L = GLOB.carp_count["[Z]"]
		if(M in L)
			LAZYREMOVE(L,M)
			break

/datum/event/carp_migration/end()
	message_admins("Carp migration event spawned [spawned_carp] carp.")


// Overmap version
/datum/event/carp_migration/overmap/announce()
	return