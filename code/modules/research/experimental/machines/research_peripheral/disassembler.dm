//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Breaks things down, forming a full internal map of said 'thing' in the process.
 */
/obj/machinery/research_peripheral/disassembler
	// TODO: NEW SPRITE PLEASE
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	/// max inserted entities + emit output entities
	var/capacity = 1
	/// inserted entities
	/// * lazy, unordered list
	var/list/atom/movable/inserted

	/// stored materials
	var/datum/material_container/emit_material_store
	/// inserted beakers
	var/list/obj/item/emit_reagent_store
	/// output that needs to be extracted
	var/list/atom/movable/emit_entity_store

// TODO: dump materials into matter bins
// TODO: implement
// TODO: warn user if inserted 'beakers' aren't stasis.

/obj/machinery/research_peripheral/disassembler/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_peripheral/disassembler/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_peripheral/disassembler/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/research_peripheral/disassembler/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
