//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/machinery/orbital_deployment_controller

	/// search radius for orbital deployment markers (zones)
	///
	/// * we throw an error if multiple are found
	var/linkage_search_radius = 10

/obj/machinery/orbital_deployment_controller/Initialize(mapload)
	. = ..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/orbital_deployment_controller/LateInitialize()

#warn impl
