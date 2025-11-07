/turf/unsimulated
	name = "command"
	turf_spawn_flags = TURF_SPAWN_FLAGS_ALLOW_ALL

	//air_status = AIR_STATUS_IMMUTABLE

	initial_gas_mix = GAS_STRING_STP

/turf/unsimulated/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)

	atom_flags |= ATOM_INITIALIZED

	SETUP_SMOOTHING()

	// todo: refactor this, planets are awful code
	SSplanets.addWall(src)

	return INITIALIZE_HINT_NORMAL

/turf/unsimulated/Destroy()
	// todo: refactor this, planets are awful code
	SSplanets.removeWall(src)
	return ..()

/turf/unsimulated/fake_space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = FALSE

/turf/unsimulated/fake_space/Initialize(mapload)
	icon_state = SPACE_ICON_STATE(x, y, z) // So realistic!
	. = ..()

/turf/unsimulated/get_lumcount(minlum = 0,maxlum = 1)
	return 0.8

// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

//? Sector API

/turf/unsimulated/sector_set_temperature(temperature)
	if(temperature == src.temperature)
		return
	src.temperature = temperature
	// Force ZAS to reconsider our connections because our temperature has changed
	if(connections)
		connections.erase_all()
	queue_zone_update()
