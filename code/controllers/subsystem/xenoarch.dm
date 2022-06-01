#define XENOARCH_SPAWN_CHANCE 0.5
#define DIGSITESIZE_LOWER 4
#define DIGSITESIZE_UPPER 12
#define ARTIFACTSPAWNNUM_LOWER 24
#define ARTIFACTSPAWNNUM_UPPER 36

//
// Xenoarch subsystem handles initialization of Xenoarcheaology artifacts and digsites.
//
SUBSYSTEM_DEF(xenoarch)
	name = "Xenoarch"
	init_order = INIT_ORDER_XENOARCH
	subsystem_flags = SS_NO_FIRE
	var/list/artifact_spawning_turfs = list()
	var/list/digsite_spawning_turfs = list()

/datum/controller/subsystem/xenoarch/Initialize(timeofday)
	SetupXenoarch()
	..()

/datum/controller/subsystem/xenoarch/Recover()
	if (istype(SSxenoarch.artifact_spawning_turfs))
		artifact_spawning_turfs = SSxenoarch.artifact_spawning_turfs
	if (istype(SSxenoarch.digsite_spawning_turfs))
		digsite_spawning_turfs = SSxenoarch.digsite_spawning_turfs

/datum/controller/subsystem/xenoarch/stat_entry(msg)
	if (!GLOB.Debug2)
		return // Only show up in stat panel if debugging is enabled.
	. = ..()

/datum/controller/subsystem/xenoarch/proc/SetupXenoarch()
	var/list/faster = list()
	var/start
	for(var/i in 1 to world.maxz)
		faster += (i in GLOB.using_map.xenoarch_exempt_levels)

	var/list/digsites_to_make = list()
	start = world.timeofday
	for(var/turf/simulated/mineral/M in world)
		if(!M.density || faster[M.z])
			continue

		if(isnull(M.geologic_data))
			M.geologic_data = new /datum/geosample(M)

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		digsites_to_make += M
		CHECK_TICK

	subsystem_log("gathered [digsites_to_make.len] turfs in [round((world.timeofday - start) / 10, 0.01)] seconds")

	start = world.timeofday
	var/made = 0
	for(var/turf/simulated/mineral/T as anything in digsites_to_make)
		++made

		digsites_to_make -= RANGE_TURFS(5, T)

		digsite_spawning_turfs.Add(T)

		var/digsite = get_random_digsite_type()
		var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER)

		var/list/turfs = list()
		for(var/turf/simulated/mineral/M in RANGE_TURFS(2, T))
			if(!M.density || M.finds)
				continue
			turfs += M

		for(var/i in 1 to target_digsite_size)
			var/turf/simulated/mineral/archeo_turf = pick_n_take(turfs)
			if(!archeo_turf)
				break

			if(isnull(archeo_turf.finds))
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 190)))
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 90)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(110, 190)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 50)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(60, 140)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(150, 190)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range)
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					archeo_turf.update_icon()

			//have a chance for an artifact to spawn here, but not in animal or plant digsites
			if(isnull(T.artifact_find) && digsite != DIGSITE_GARDEN && digsite != DIGSITE_ANIMAL)
				artifact_spawning_turfs.Add(archeo_turf)

	subsystem_log("spawned [made] digsites in [round((world.timeofday - start) / 10, 0.01)] seconds")

	start = world.timeofday

	var/artifacts = 0
	//create artifact machinery
	var/num_artifacts_spawn = rand(ARTIFACTSPAWNNUM_LOWER, ARTIFACTSPAWNNUM_UPPER)
	var/list/to_make = list()
	while((to_make.len < num_artifacts_spawn) && artifact_spawning_turfs.len)
		to_make += pick_n_take(artifact_spawning_turfs)

	var/list/artifacts_spawnturf_temp = to_make.Copy()
	while(artifacts_spawnturf_temp.len)
		var/turf/simulated/mineral/artifact_turf = artifacts_spawnturf_temp[artifacts_spawnturf_temp.len]
		--artifacts_spawnturf_temp.len
		artifact_turf.artifact_find = new
		++artifacts

	subsystem_log("created [artifacts] artifact machinery in [round((world.timeofday - start) / 10, 0.01)] seconds")

#undef XENOARCH_SPAWN_CHANCE
#undef DIGSITESIZE_LOWER
#undef DIGSITESIZE_UPPER
#undef ARTIFACTSPAWNNUM_LOWER
#undef ARTIFACTSPAWNNUM_UPPER
