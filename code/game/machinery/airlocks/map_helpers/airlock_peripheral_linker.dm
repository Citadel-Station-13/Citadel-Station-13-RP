//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/map_helper/airlock_peripheral_linker
	name = "airlock peripheral linker"
	desc = "Sets airlock ID on airlock peripherals"
	#warn sprite
	late = TRUE

	/// airlock ID to link to; will be automatically mangled
	var/set_controller_id

/obj/map_helper/airlock_peripheral_linker/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	if(set_controller_id)
		set_controller_id = SSmapping.mangled_round_local_id(set_controller_id, context.mangling_id)

/obj/map_helper/airlock_peripheral_linker/Initialize(mapload)
	for(var/obj/machinery/airlock_peripheral/peripheral in loc)
		peripheral.controller_autolink_id = set_controller_id
	return ..()
