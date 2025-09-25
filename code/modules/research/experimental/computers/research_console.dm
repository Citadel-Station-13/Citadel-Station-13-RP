//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: finish this file!

/obj/item/circuitboard/computer/research_console
	/// our unique id - must be persistence stable
	var/c_id
	/// network connections by id; this allows for automatically rejoining after disconnect.
	var/list/c_connections

// TODO: unified modcomp-console implementation

/obj/machinery/computer/research_console
	name = "research console"
	desc = "A console able to be connected to a remote research network."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/computer/research_console

	#warn circuit & persist connection so screwdriver doesn't break it

	/// our unique id
	var/id
	/// connections by id
	var/list/connectionss
	/// outgoing requests; network id associated to /datum/research_network_connection_request
	var/list/connection_requests

	/// active connection
	#warn how do we do active networks vs inactive? selecting specific network? for config? what about peripherals that need to access network?
	var/datum/research_network_connection/selected_network_connection

	/// linked lathes
	var/list/obj/machinery/lathe/linked_lathes
	/// linked r&d machinery
	var/list/obj/machinery/research_peripheral/linked_peripherals

	/// always join this network, without map mangling
	var/conf_network_autojoin_static_id
	/// use design tag whitelist
	var/list/conf_network_autojoin_design_whitelist
	/// use design tag blacklist
	var/list/conf_network_autojoin_design_blacklist
	/// use capabilities
	var/conf_network_autojoin_capabilities = RESEARCH_NETWORK_CAPABILITY_PULL_KNOWLEDGE | RESEARCH_NETWORK_CAPABILITY_PULL_DESIGN
	/// use oplvl
	var/conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DEFAULT

#warn impl all
/obj/machinery/computer/research_console/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/computer/research_console/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/research_console/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/research_console/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/research_console/proc/on_connection_add(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/on_connection_remove(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/on_connection_active(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/on_connection_inactive(datum/research_network_connection/conn)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/obj/machinery/computer/research_console/proc/check_network_connectivity(datum/research_network/network)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

/datum/research_network_connection/research_console

/datum/research_network_connection/research_console/on_connection_active(datum/research_network/network, datum/peer)

/datum/research_network_connection/research_console/on_connection_inactive(datum/research_network/network, datum/peer)

/datum/research_network_connection/research_console/check_connectivity(datum/research_network/network)
	var/obj/machinery/computer/research_console/maybe_console = s_peer
	if(!istype(maybe_console))
		return FALSE
	return maybe_console.check_network_connectivity(network)

//* Presets *//

/obj/machinery/computer/research_console/preset

/obj/machinery/computer/research_console/preset/main_map
	conf_network_autojoin_static_id = /obj/machinery/research_mainframe/preset/main_map::conf_network_create_static_id

/obj/machinery/computer/research_console/preset/main_map/engineering
	conf_network_autojoin_design_whitelist = null
	conf_network_autojoin_design_blacklist = list(
		DESIGN_TAG_S_EXPERIMENTAL,
		DESIGN_TAG_C_AI,
		DESIGN_TAG_C_WEAPON,
		DESIGN_TAG_C_VEHICLE,
	)
	conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DEPARTMENT

/obj/machinery/computer/research_console/preset/main_map/medical
	conf_network_autojoin_design_whitelist = list(
		DESIGN_TAG_C_STOCK_PART,
	)
	conf_network_autojoin_design_blacklist = list(
		DESIGN_TAG_S_EXPERIMENTAL,
	)
	conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DEPARTMENT

/obj/machinery/computer/research_console/preset/main_map/science
	conf_network_autojoin_design_blacklist = null
	conf_network_autojoin_design_whitelist = null
	conf_network_autojoin_capabilities = RESEARCH_NETWORK_CAPABILITY_ADMIN | RESEARCH_NETWORK_CAPABILITY_PULL_KNOWLEDGE | RESEARCH_NETWORK_CAPABILITY_PULL_DESIGN
	conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DEPARTMENT

/obj/machinery/computer/research_console/preset/main_map/bridge
	conf_network_autojoin_capabilities = RESEARCH_NETWORK_CAPABILITY_ADMIN | RESEARCH_NETWORK_CAPABILITY_PULL_KNOWLEDGE | RESEARCH_NETWORK_CAPABILITY_PULL_DESIGN
	conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DEPARTMENT

/obj/machinery/computer/research_console/preset/main_map/rd_office
	conf_network_autojoin_capabilities = RESEARCH_NETWORK_CAPABILITY_ADMIN | RESEARCH_NETWORK_CAPABILITY_PULL_KNOWLEDGE | RESEARCH_NETWORK_CAPABILITY_PULL_DESIGN
	conf_network_autojoin_oplvl = RESEARCH_NETWORK_OPLVL_DIRECTOR
