//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Represents data of what's being exported.
 *
 * * This is not responsible (nor are supply export handlers) for deleting entities.
 *   You should clean up the shuttle after export handling runs.
 * * Export handling is under no circumstances allowed to actually modify
 *   the contents of the export.
 */
/datum/supply_export
	/// raw entity set to process
	/// * This is cleared when we finalize.
	var/list/atom/movable/entities

	//*              enumeration           *//
	//* these are cleared when we finalize *//

	/// generic flatlist of unhandled entities
	var/list/atom/movable/entities_leftover = list()
	/// /obj/item/stack/material
	var/list/obj/item/stack/material/entities_material_stack = list()
	/// /obj/item/stack
	var/list/obj/item/stack/entities_stack = list()

	//* output *//

	/// total money out
	var/earned = 0
	/// "i'm too lazy to be a responsible coder";
	/// this lets you dump earned money without needing to explain why
	var/earned_unexplained = 0
	/// direct cash shipments
	var/earned_direct_cash = 0
	/// * material id to /datum/supply_export_output/material
	/// * this is only for raw materials, not any potential recycling / dismantling of entities.
	var/list/earned_from_materials = list()
	/// * stack typepath to /datum/supply_export_output/stack
	/// * this is only for raw materials, not any potential recycling / dismantling of entities.
	var/list/earned_from_stacks = list()

/datum/supply_export/New(list/atom/movable/entities)
	src.entities = entities

/datum/supply_export/Destroy()
	clear_references()
	return ..()

/datum/supply_export/proc/clear_references()
	entities = null
	entities_leftover = null
	entities_material_stack = null
	entities_stack = null

/**
 * Runs us against a list of handlers for export to a specific faction.
 */
/datum/supply_export/proc/run(list/datum/supply_export_handler/handlers, datum/supply_faction/faction)

/**
 * enumerates entities, throwing them into enumeration lists
 */
/datum/supply_export/proc/run_enumeration()

/**
 * runs handlers in sequence; handlers will remove things from enumeration lists as they process them
 */
/datum/supply_export/proc/run_handlers(list/datum/supply_export_handler/handlers, datum/supply_faction/faction)
	for(var/datum/supply_export_handler/handler as anything in handlers)
		handler.run_against(src, faction)

/**
 * finalizes, clears run variables, finishes outputs, etc
 */
/datum/supply_export/proc/run_finalization()
	clear_references()

/**
 * generate a /datum/legacy_export_crate
 */
/datum/supply_export/proc/generate_legacy_exported_crate()
	RETURN_TYPE(/datum/legacy_exported_crate)
	var/datum/legacy_exported_crate/report = new
	report.value = earned

	if(earned_unexplained)
		report.contents += list(list(
			"object" = "miscellaneous things",
			"quantity" = 1,
			"value" = earned_unexplained,
		))
	if(earned_direct_cash)
		report.contents += list(list(
			"object" = CURRENCY_NAME_SINGULAR,
			"quantity" = earned_direct_cash,
			"value" = earned_direct_cash,
		))
	for(var/material_id in earned_from_materials)
		var/datum/supply_export_output/material/output_datum = earned_from_materials[material_id]

	for(var/stack_typepath in earned_from_stacks)
		var/datum/supply_export_output/stack/output_datum = earned_from_stacks[stack_typepath]

	#warn impl

	return report

#warn impl
