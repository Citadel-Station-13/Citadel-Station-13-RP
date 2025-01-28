//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Crayon system file
 */

/// initialized by early_init
GLOBAL_LIST_EMPTY(crayon_data)
/// initialized by early_init
GLOBAL_LIST_EMPTY(crayon_data_lookup_by_string_icon_path)

/proc/init_crayon_decal_meta()
	var/list/datum/crayon_decal_meta/created = list()
	var/list/lookup = list()

	var/list/crayon_files = list(
		'icons/modules/artwork/debris/crayon_paint_32x32.dmi' = "Paint",
		'icons/modules/artwork/debris/crayon_numbers_32x32.dmi' = "Numbers",
		'icons/modules/artwork/debris/crayon_letters_32x32.dmi' = "Letters",
		'icons/modules/artwork/debris/crayon_punctuation_32x32.dmi' = "Punctuation",
		'icons/modules/artwork/debris/crayon_symbols_32x32.dmi' = "Symbols",
		'icons/modules/artwork/debris/crayon_gangs_32x32.dmi' = "Gangs",
		'icons/modules/artwork/debris/crayon_items_32x32.dmi' = "Items",
		'icons/modules/artwork/debris/crayon_living_32x32.dmi' = "Living",
		'icons/modules/artwork/debris/crayon_runes_32x32.dmi' = "Runes",
		'icons/modules/artwork/debris/crayon_signs_32x32.dmi' = "Signs",
		'icons/modules/artwork/debris/crayon_misc_32x32.dmi' = "Misc-32x32",
		'icons/modules/artwork/debris/crayon_misc_96x32.dmi' = "Misc-96x32",
	)

	for(var/icon_path in crayon_files)
		var/name = crayon_files[icon_path]
		var/icon/icon = icon(icon_path)
		var/width = icon.Width()
		var/height = icon.Height()
		// pass path in directly
		var/list/states = icon_states(icon_path)
		if(!islist(states))
			stack_trace("failed to parse states for crayon pack [icon_path]")

		var/datum/crayon_decal_meta/data_holder = new
		data_holder.states = states
		data_holder.width = width
		data_holder.height = height
		data_holder.centering_pixel_x = -((width - WORLD_ICON_SIZE) * 0.5)
		data_holder.centering_pixel_y = -((height - WORLD_ICON_SIZE) * 0.5)
		data_holder.icon_ref = icon
		data_holder.name = name
		data_holder.id = "[icon_path]"

		created += data_holder
		lookup["[icon_path]"] = data_holder

	GLOB.crayon_data = created
	GLOB.crayon_data_lookup_by_string_icon_path = lookup

/datum/crayon_decal_meta
	/// name
	var/name
	/// id
	var/id
	/// valid states
	var/list/states
	/// our width
	var/width
	/// our height
	var/height
	/// our icon ref
	var/icon/icon_ref
	/// shift by this to center
	var/centering_pixel_x
	/// shift by this to center
	var/centering_pixel_y

/datum/crayon_decal_meta/proc/tgui_crayon_data()
	//!                                  uh oh! byond alert!                                !//
	//! associative lists are contagious and we really need a flat list or tgui crashes!    !//
	//!                                 manually flatten it.                                !//
	var/list/i_really_dislike_byond = list()
	for(var/key in states)
		i_really_dislike_byond += key

	return list(
		"name" = name,
		"states" = i_really_dislike_byond,
		"width" = width,
		"height" = height,
		"id" = id,
	)
