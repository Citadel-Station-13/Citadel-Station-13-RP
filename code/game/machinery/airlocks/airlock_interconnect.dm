//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/item/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled and pressurized set of air conduits used to connect \
	an airlock's air systems."
	#warn sprite

#warn impl

/obj/structure/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled and pressurized set of air conduits used to connect \
	an airlock's air systems."
	#warn sprite

	/// our pipenet
	var/datum/airlock_pipenet/network
	/// connected machinery
	var/list/obj/machinery/airlock_peripheral/gasnet/peripherals
	/// connected interconnects
	var/list/obj/structure/airlock_interconnect/interconnects
	/// rebuild queued
	var/rebuild_queued = FALSE



#warn impl

/obj/structure/airlock_interconnect/proc/rebuild()
	rebuild_queued = FALSE
	if(network)
		return
	new /datum/airlock_pipenet(src)

/obj/structure/airlock_interconnect/proc/queue_rebuild()
	#warn impl
