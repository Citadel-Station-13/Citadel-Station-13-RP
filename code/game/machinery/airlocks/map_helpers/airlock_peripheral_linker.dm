//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/map_helper/airlock_peripheral_linker
	#warn sprite
	late = TRUE

	/// airlock ID to link to; will be automatically mangled
	var/airlock_id

/obj/map_helper/airlock_peripheral_linker/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/map_helper/airlock_peripheral_linker/Initialize(mapload)
	for(var/obj/machinery/airlock_peripheral/peripheral in loc)
		peripheral.airlock_id = airlock_id
	return ..()
