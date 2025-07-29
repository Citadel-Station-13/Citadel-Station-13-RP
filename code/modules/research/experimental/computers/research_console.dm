//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: unified modcomp-console implementation

/obj/machinery/computer/research_console
	name = "research console"
	desc = "A console able to be connected to a remote research network."

	#warn circuit & persist connection so screwdriver doesn't break it

	/// active connections
	var/list/datum/research_network_connection/connections
	/// outgoing requests
	var/list/datum/research_network_join_request/connection_requests

	/// active connection
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

/datum/research_network_connection/research_console
	/// connected console
	var/obj/machinery/computer/research_console/connected_console

/datum/research_network_connection/research_console/New(datum/research_network/network, obj/machinery/computer/research_console/console)
	..(network)

/datum/research_network_connection/research_console/Destroy()

//* Presets *//

/obj/machinery/computer/research_console/preset

/obj/machinery/computer/research_console/preset/main_map
	conf_network_autojoin_id = /obj/machinery/research_mainframe/preset/main_map::conf_network_create_static_id

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
