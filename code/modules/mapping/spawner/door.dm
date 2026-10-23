/obj/spawner/door
	#warn impl / sprite

	//* Preload *//

	/**
	 * If set, erase us on mapload if an airlock is already there.
	 */
	var/tmp/map_impl_erase_if_another_door_exists = FALSE
	var/tmp/map_impl_erase_if_another_door_active = FALSE

/obj/spawner/door/New()
	if(map_impl_erase_if_another_door_exists)
		for(var/obj/machinery/door/other in locs)
			if(other != src)
				map_impl_erase_if_another_door_active = TRUE
				break
		for(var/obj/spawner/door/other in locs)
			if(other != src)
				map_impl_erase_if_another_door_active = TRUE
				break
	..()

/obj/spawner/door/Initialize(mapload, newdir)
	if(mapload && map_impl_erase_if_another_door_active)
		return INITIALIZE_HINT_QDEL
	return ..()

/obj/spawner/door/Spawn()

#warn impl all

/obj/spawner/door/proc/get_spawn_path()
	CRASH("not implemented")

/obj/spawner/door/specific
	//* Type *//

	/// Door type to spawn
	var/door_type = /obj/machinery/door/airlock

//* Auto Marker Based *//

/obj/spawner/door/auto

/obj/spawner/door/auto/secure

/obj/spawner/door/auto/external

/obj/spawner/door/auto/airlock

/obj/spawner/door/auto/airlock/secure

/obj/spawner/door/auto/airlock/external

#warn auto marker config
