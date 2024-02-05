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
		'crayon_paint_32x32.dmi' = "Paint",
		'crayon_numbers_32x32.dmi' = "Numbers",
		'crayon_letters_32x32.dmi' = "Letters",
		'crayon_punctuation_32x32.dmi' = "Punctuation",
		'crayon_symbols_32x32.dmi' = "Symbols",
		'crayon_gangs_32x32.dmi' = "Gangs",
		'crayon_items_32x32.dmi' = "Items",
		'crayon_living_32x32.dmi' = "Living",
		'crayon_runes_32x32.dmi' = "Runes",
		'crayon_signs_32x32.dmi' = "Signs",
		'crayon_misc_32x32.dmi' = "Misc (32x32)",
		'crayon_misc_96x32.dmi' = "Misc (96x32)",
	)

	for(var/icon_path in crayon_files)
		var/name = crayon_files[icon_path]
		var/icon/icon = icon(icon_path)
		var/width = icon.Width()
		var/height = icon.Height()
		// pass path in directly
		var/list/states = rustg_dmi_icon_states(icon_path)

		var/datum/crayon_decal_meta/data_holder = new
		data_holder.states = states
		data_holder.width = width
		data_holder.height = height
		data_holder.icon_ref = icon
		data_holder.name = name

		created += data_holder
		lookup["[icon_path]"] = data_holder

	GLOB.crayon_data = created
	GLOB.crayon_data_lookup_by_string_icon_path = lookup

/datum/crayon_decal_meta
	/// name
	var/name
	/// valid states
	var/list/states
	/// our width
	var/width
	/// our height
	var/height
	/// our icon ref
	var/icon/icon_ref

/datum/crayon_decal_meta/proc/tgui_crayon_data()
	#warn impl

