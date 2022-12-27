/datum/controller/subsystem/mapping
	/// ore generators by level; used for lazy initing of resources
	var/static/list/datum/ore_generation/ore_data = list()

/world/max_z_changed()
	. = ..()
	SSmapping.refresh_ore_data_list()

/datum/controller/subsystem/mapping/proc/refresh_ore_data_list()
	ore_data.len = world.maxz

/datum/controller/subsystem/mapping/proc/get_ore_generation(z)
	RETURN_TYPE(/datum/ore_generation)
	return ore_data[T.z]

/datum/controller/subsystem/mapping/proc/get_initial_underground_ores(turf/T)
	var/datum/ore_generation/gen = ore_data[T.z]
	if(!gen)
		return list()
	return gen.ores_at_spot(T.x, T.y)

/datum/controller/subsystem/mapping/proc/seed_aboveground_ores(z)
	var/datum/ore_generation/oregen = get_ore_generation(z)
	if(!oregen)
		return
	oregen.seed(z)

/datum/controller/subsystem/mapping/proc/set_ore_generator(z, datum/ore_generation/oregen)
	ore_data[z] = oregen

/datum/controller/subsystem/mapping/proc/initialize_ores(z, datum/ore_generation/oregen)
	if(get_ore_generation(z))
		CRASH("already initialized")
	set_ore_generator(z, oregen)
	seed_aboveground_ores(z)

/datum/controller/subsystem/mapping/proc/lazy_default_initialize_ores(z)
	// -_-
	initialize_ores(z, new /datum/ore_generation/default/auto)
