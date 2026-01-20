//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_component/vent
	name = "airlock vent"
	desc = "A large vent used in an airlock to dispel unwanted waste gases and use as a heat source/sink."

	#warn sprite

#warn impl link

/**
 * Gets gas mixture to use for handler / cycler procs.
 * * This should wake the zone as needed, because the mixture will probably be modified.
 */
/obj/machinery/airlock_component/vent/proc/get_mutable_gas_mixture_ref() as /datum/gas_mixture
	return loc.return_air_mutable()

/obj/machinery/airlock_component/vent/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
