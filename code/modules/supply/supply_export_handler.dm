//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Sequentially executed supply export handlers
 *
 * Handles exports. Duh.
 */
/datum/supply_export_handler

/**
 * Runs on an export.
 *
 * * remove entities from 'entities_' lists, but not the main 'entities' list.
 *
 * @params
 * * export - the export
 * * faction - the supply faction being exported to
 */
/datum/supply_export_handler/proc/run_against(datum/supply_export/export, datum/supply_faction/faction)
	return

#warn impl
