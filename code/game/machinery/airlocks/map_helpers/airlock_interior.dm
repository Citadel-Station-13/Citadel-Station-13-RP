//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * marks the side of the airlock that should be the interior
 * put it on the interior set of doors!
 */
/obj/map_helper/airlock_interior
	late = TRUE

	/// airlock ID to link to; will be automatically mangled
	var/airlock_id

/obj/map_helper/airlock_interior/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/map_helper/airlock_interior/Initialize(mapload)
	#warn do things
	return ..()

#warn impl
