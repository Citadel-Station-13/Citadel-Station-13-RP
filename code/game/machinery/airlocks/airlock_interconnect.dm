//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/item/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	#warn sprite

#warn impl

/obj/structure/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled set of conduits used to connect the parts of an airlock together."
	#warn sprite

	/// our pipenet
	var/datum/airlock_gasnet/network
	/// connected machinery
	var/list/obj/machinery/airlock_component/peripherals
	/// connected interconnects
	var/list/obj/structure/airlock_interconnect/interconnects
	/// rebuild queued
	var/rebuild_queued = FALSE



#warn impl

/obj/structure/airlock_interconnect/proc/rebuild()
	rebuild_queued = FALSE
	if(network)
		return
	new /datum/airlock_gasnet(src)

/obj/structure/airlock_interconnect/proc/queue_rebuild()
	#warn impl
