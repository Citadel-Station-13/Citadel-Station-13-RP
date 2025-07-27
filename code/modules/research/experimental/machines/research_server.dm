//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Linked to one research network at a time.
 */
/obj/machinery/research_server
	/// linked network
	/// * later on we'll use network system if we come up with one that doesn't suck;
	///   for now it can link to any mainframe in the same /map
	var/datum/research_network/network

#warn impl

/obj/machinery/research_server/Initialize(mapload)
	. = ..()

/obj/machinery/research_server/Destroy()
	. = ..()

/obj/machinery/research_server/proc/link_network(datum/research_network/network)
	if(src.network)
		if(src.network == network)
			return
		unlink_network()

/obj/machinery/research_server/proc/unlink_network()
	if(!network)
		return

/obj/machinery/research_server/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
