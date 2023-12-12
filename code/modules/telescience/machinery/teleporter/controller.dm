//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * controller
 *
 * things coordinate via this
 *
 * machinery, controllers, and remotes should be bound to this
 */
/obj/machinery/teleporter_controller
	name = "teleporter mainframe"
	desc = "A powerful mainframe controlling teleporters. This thing performs the necessary numbers-crunching to shunt things through bluespace tunnels, as well as coordinate all the machinery required to do so."
	#warn sprite

	/// autolink receive id
	/// normal link checks are still done
	var/autolink_id

	/// linked pads
	var/list/obj/machinery/teleporter/bluespace_pad/pads
	/// linked capacitors
	/// capacitor linking is optional
	var/list/obj/machinery/teleporter/bluespace_capacitor/capacitors
	/// linked projectors
	var/list/obj/machinery/teleporter/bluespace_projector/projectors
	/// linked scanners
	var/list/obj/machinery/teleporter/bluespace_scanner/scanners

	/// linked consoles
	var/list/obj/machinery/computer/consoles

	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

	/// our UI module
	var/datum/tgui_module/teleporter_control/ui_controller

	/// active teleporter locks by signal
	var/list/locks_by_signal

	/// our context
	var/datum/teleporter_context/context

/obj/machinery/teleporter_controller/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/teleporter_controller/LateInitialize()
	. = ..()
	if(autolink_id)
		if(!islist(GLOB.telescience_linkage_buffers[autolink_id]))
			if(!isnull(GLOB.telescience_linkage_buffers[autolink_id]))
				stack_trace("collision on autolink id")
		else
			for(var/obj/machinery/teleporter/machine in GLOB.telescience_linkage_buffers[autolink_id])
				auto_link_machine(machine)
		GLOB.telescience_linkage_buffers[autolink_id] = src
	create_context()

/obj/machinery/teleporter_controller/Destroy()
	if(GLOB.telescience_linkage_buffers[autolink_id] == src)
		GLOB.telescience_linkage_buffers -= autolink_id
	unlink_everything()
	QDEL_NULL(ui_controller)
	QDEL_NULL(context)
	return ..()

//? Linkage

/obj/machinery/teleporter_controller/proc/unlink_everything()
	for(var/obj/machinery/teleporter/machine in list(pads + capacitors + projectors + scanners))
		unlink_machine(machine)
	for(var/obj/machinery/computer/teleporter/console in consoles)
		unlink_console(console)
	for(var/obj/item/bluespace_remote/remote in remotes)
		unlink_remote(remote)

/obj/machinery/teleporter_controller/proc/unlink_machine(obj/machinery/teleporter/machine)
	// todo: ui static data

	if(istype(machine, /obj/machinery/teleporter/bluespace_capacitor))
		LAZYREMOVE(capacitors, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_pad))
		LAZYREMOVE(pads, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_projector))
		LAZYREMOVE(projectors, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_scanner))
		LAZYREMOVE(scanners, machine)
	machine.controller_unlinked(src)

/obj/machinery/teleporter_controller/proc/link_machine(obj/machinery/teleporter/machine)
	// todo: ui static data

	if(istype(machine, /obj/machinery/teleporter/bluespace_capacitor))
		LAZYADD(capacitors, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_pad))
		LAZYADD(pads, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_projector))
		LAZYADD(projectors, machine)
	if(istype(machine, /obj/machinery/teleporter/bluespace_scanner))
		LAZYADD(scanners, machine)
	machine.controller_linked(src)

/obj/machinery/teleporter_controller/proc/unlink_console(obj/machinery/computer/teleporter/console)
	// todo: ui static data

	LAZYREMOVE(consoles, console)
	console.controller_unlinked(src)

/obj/machinery/teleporter_controller/proc/link_console(obj/machinery/computer/teleporter/console)
	// todo: ui static data

	LAZYADD(consoles, console)
	console.controller_linked(src)

/obj/machinery/teleporter_controller/proc/auto_link_console(obj/machinery/computer/teleporter/console)
	var/obj/overmap/entity/their_entity = get_overmap_sector(console)
	var/obj/overmap/entity/our_entity = get_overmap_sector(src)
	if(their_entity != our_entity)
		CRASH("wrong sector, [their_entity] vs [our_entity]")
	return link_console(console)

/obj/machinery/teleporter_controller/proc/unlink_remote(obj/item/bluespace_remote/remote)
	#warn impl

/obj/machinery/teleporter_controller/proc/link_remote(obj/item/bluespace_remote/remote)
	#warn impl

/obj/machinery/teleporter_controller/proc/auto_link_remote(obj/item/bluespace_remote/remote)
	var/obj/overmap/entity/their_entity = get_overmap_sector(remote)
	var/obj/overmap/entity/our_entity = get_overmap_sector(src)
	if(their_entity != our_entity)
		CRASH("wrong sector, [their_entity] vs [our_entity]")
	return link_remote(remote)

/obj/machinery/teleporter_controller/proc/auto_link_machine(obj/machinery/teleporter/machine)
	var/obj/overmap/entity/their_entity = get_overmap_sector(machine)
	var/obj/overmap/entity/our_entity = get_overmap_sector(src)
	if(their_entity != our_entity)
		CRASH("wrong sector, [their_entity] vs [our_entity]")
	return link_machine(machine)

//? UI

/obj/machinery/teleporter_controller/proc/request_ui_controller()
	if(isnull(ui_controller))
		ui_controller = new(src)
	return ui_controller
