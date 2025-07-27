//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Research mainframe. Stores resaerch data, ideally for an entire map / station / whatever.
 * * Realistically is actually an abstract coordination mainframe. We can add lots of functions to this
 *   once we figure out what we're doing for computers / networks. As an example, we can add
 *   tachyon-doppler array uplinks and have the research system literally be a ship-wide resource
 *   for command consoles to pull from.
 * * As per new paradigm on map control, while research administration consoles presumably exist
 *   and are presumably locked, the mainframe can access anything in it and never requires access
 *   to tamper. Protect your servers, people.
 */
/obj/machinery/research_mainframe
	name = "research mainframe"
	desc = "A self-contained mainframe holding data needed to run research and inference systems."
	/// our created network
	/// * we own this if we have it, generally
	var/datum/research_network/network

/obj/machinery/research_mainframe/Initialize(mapload)
	. = ..()

/obj/machinery/research_mainframe/Destroy()
	. = ..()




#warn impl

/obj/machinery/research_mainframe/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/research_mainframe/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_mainframe/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_mainframe/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/**
 * The almighty source of truth for the main map.
 * * Persists across rounds.
 *
 * TODO: implement persistence to work; we can't use static-atom persistence driver
 *       as this is cross-map.
 */
/obj/machinery/research_mainframe/main_map
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

	/// only one can exist at the same time
	VAR_PRIVATE/static/obj/machinery/research_mainframe/main_map/__highlander_mutex

/obj/machinery/research_mainframe/main_map/Initialize(mapload)
	. = ..()
	if(__highlander_mutex)
		QDEL_NULL(__highlander_mutex)
	__highlander_mutex = src

/obj/machinery/research_mainframe/main_map/Destroy()
	if(__highlander_mutex == src)
		__highlander_mutex = null
	return ..()

/**
 * Check before ser/de!
 */
/obj/machinery/research_mainframe/main_map/proc/has_persistence_mutex()
	return __highlander_mutex == src
