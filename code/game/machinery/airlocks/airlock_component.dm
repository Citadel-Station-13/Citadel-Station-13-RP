//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * gasnet connected machinery
 */
/obj/machinery/airlock_comopnent
	/// conencted gasnet
	var/datum/airlock_gasnet/network
	/// connected interconnect: something to note here is that
	/// unlike pipenets, airlock machinery are **not** able to
	/// connect to each other directly.
	var/obj/structure/airlock_interconnect/interconnect

/obj/machinery/airlock_comopnent/proc/on_connect(datum/airlock_gasnet/network)
	return

/obj/machinery/airlock_comopnent/proc/on_disconnect(datum/airlock_gasnet/network)
	return
