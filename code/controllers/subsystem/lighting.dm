GLOBAL_LIST_EMPTY(lighting_update_lights)  // List of lighting sources queued for update.
GLOBAL_LIST_EMPTY(lighting_update_corners) // List of lighting corners queued for update.
GLOBAL_LIST_EMPTY(lighting_update_objects) // List of lighting objects queued for update.

#ifdef VISUALIZE_LIGHT_UPDATES
GLOBAL_VAR_INIT(allow_duped_values,  FALSE)
GLOBAL_VAR_INIT(allow_duped_corners, FALSE)
#endif

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 2
	init_order = INIT_ORDER_LIGHTING
	subsystem_flags = SS_TICKER

/datum/controller/subsystem/lighting/stat_entry(msg)
	msg = "L:[length(GLOB.lighting_update_lights)]|C:[length(GLOB.lighting_update_corners)]|O:[length(GLOB.lighting_update_objects)]"
	return ..()

/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if (CONFIG_GET(number/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	fire(FALSE, TRUE)

	return ..()

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	var/i = 0

	// why do we split logic?
	// because here on citrp, code standards like "don't delete shit during init" is often not enforced
	// meaning the subsystem will crash out of this loop if something is deleted mid-process, which can happen if CHECK_TICK is running in init
	if(init_tick_checks)
		while(GLOB.lighting_update_lights.len)
			var/datum/light_source/L = GLOB.lighting_update_lights[GLOB.lighting_update_lights.len]
			--GLOB.lighting_update_lights.len
			L.update_corners()
			L.needs_update = LIGHTING_NO_UPDATE
			CHECK_TICK
	else
		MC_SPLIT_TICK
		i = 0
		for (i in 1 to GLOB.lighting_update_lights.len)
			var/datum/light_source/L = GLOB.lighting_update_lights[i]

			L.update_corners()

			L.needs_update = LIGHTING_NO_UPDATE

			if(init_tick_checks)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
		if (i)
			GLOB.lighting_update_lights.Cut(1, i+1)
			i = 0

	if(!init_tick_checks)
		MC_SPLIT_TICK

	// however the safety checks are not done for corners/objects
	// if anyone is deleting THESE during init, we've got bigger problems than ones we can brush under the rug by changing a for loop.

	for (i in 1 to GLOB.lighting_update_corners.len)
		var/datum/lighting_corner/C = GLOB.lighting_update_corners[i]

		C.update_objects()
		C.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.lighting_update_corners.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for (i in 1 to GLOB.lighting_update_objects.len)
		var/atom/movable/lighting_object/O = GLOB.lighting_update_objects[i]

		if (QDELETED(O))
			continue

		O.update()
		O.needs_update = FALSE
		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.lighting_update_objects.Cut(1, i+1)


/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
