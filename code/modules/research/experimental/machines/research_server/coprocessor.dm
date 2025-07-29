//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/research_server/coprocessor
	name = "research coprocessing server"
	desc = "A coprocessing unit that can be connected to a research network to provide available compute."

	/// available compute
	var/compute_capacity = 20
	/// batch jobs on this associated to compute usage
	/// * lazy list
	var/list/compute_jobs

#warn impl

/obj/machinery/research_server/coprocessor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/research_server/coprocessor/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/coprocessor/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/coprocessor/ui_act(action, list/params, datum/tgui/ui)
	. = ..()wz

/obj/machinery/research_server/coprocessor/on_join_network(datum/research_network/network)
	. = ..()

/obj/machinery/research_server/coprocessor/on_leave_network(datum/research_network/network)
	. = ..()

/obj/machinery/research_server/coprocessor/proc/set_compute_capacity(capacity)
	src.compute_capacity = capacity
	#warn inform network
