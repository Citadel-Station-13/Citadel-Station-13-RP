//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/map_helper/airlock_linker
	name = "airlock linker"
	desc = "Sets airlock ID on airlock controllers and peripherals"
	icon = 'icons/machinery/airlocks/map_helpers.dmi'
	icon_state = "linker-purple"
	maptext = MAPTEXT_CENTER_CONST("Airlock Linker")
	maptext_y = 32

	/// airlock ID to link to; will be automatically mangled
	var/set_id

	var/set_controllers = TRUE
	var/set_peripherals = TRUE

/obj/map_helper/airlock_linker/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	if(set_id)
		set_id = SSmapping.mangled_round_local_id(set_id, context.mangling_id)

/obj/map_helper/airlock_linker/Initialize(mapload)
	if(set_controllers)
		for(var/obj/machinery/airlock_component/controller/controller in loc)
			controller.set_controller_id(set_id)
	if(set_peripherals)
		for(var/obj/machinery/airlock_component/peripheral/peripheral in loc)
			peripheral.controller_autolink_id = set_id
	return ..()

/obj/map_helper/airlock_linker/preset/shuttle_main
	set_id = "shuttle_main"

/obj/map_helper/airlock_linker/proximity
	var/const/link_range = 15
	var/link_key

/obj/map_helper/airlock_linker/proximity/red
	icon_state = "linker-red"
	link_key = "red"

/obj/map_helper/airlock_linker/proximity/green
	icon_state = "linker-green"
	link_key = "green"

/obj/map_helper/airlock_linker/proximity/blue
	icon_state = "linker-blue"
	link_key = "blue"


#warn impl
