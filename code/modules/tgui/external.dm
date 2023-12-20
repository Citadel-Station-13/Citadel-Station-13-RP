/**
 * External tgui definitions, such as src_object APIs.
 *
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * public
 *
 * Used to open and update UIs.
 * If this proc is not implemented properly, the UI will not update correctly.
 *
 * required user mob The mob who opened/is using the UI.
 * optional ui datum/tgui The UI to be updated, if it exists.
 *
 *! ## To-Be-Deprecated.
 * optional parent_ui datum/tgui A parent UI that, when closed, closes this UI as well.
 */
/datum/proc/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	return FALSE // Not implemented.

/**
 * public
 *
 * Called on an object when a tgui object is being created, allowing you to
 * push various assets to tgui, for examples spritesheets.
 *
 * return list List of asset datums or file paths.
 */
/datum/proc/ui_assets(mob/user)
	return list()

/**
 * private
 *
 * The UI's host object (usually src_object).
 * This allows modules/datums to have the UI attached to them,
 * and be a part of another object.
 */
/datum/proc/ui_host(mob/user, datum/tgui_module/module)
	return src // Default src.

/**
 * private
 *
 * The UI's state controller to be used for created uis
 * This is a proc over a var for memory reasons
 */
/datum/proc/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.default_state

