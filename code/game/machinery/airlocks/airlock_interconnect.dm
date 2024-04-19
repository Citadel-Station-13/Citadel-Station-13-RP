//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/item/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled and pressurized set of air conduits used to connect \
	an airlock's air handler to the chamber's cyclers."
	#warn sprite

#warn impl

/obj/structure/airlock_interconnect
	name = "airlock interconnect"
	desc = "A tightly bundled and pressurized set of air conduits used to connect \
	an airlock's air handler to the chamber's cyclers."
	#warn sprite

	/// our pipenet
	var/datum/airlock_pipenet/network
	/// connected interconnects
	var/list/obj/structure/airlock_interconnect/connected

#warn impl
