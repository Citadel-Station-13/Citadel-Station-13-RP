//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_INIT(hud_styles, init_hud_styles())

/proc/init_hud_styles()
	. = list()
	for(var/datum/hud_style/path as anything in subtypesof(/datum/hud_style))
		if(initial(path.abstract_type) == path)
			continue
		.[initial(path.id)] = new path

/proc/legacy_find_hud_style_by_name(name)
	for(var/id in GLOB.hud_styles)
		var/datum/hud_style/style = GLOB.hud_styles[id]
		if(lowertext(style.name) == lowertext(name) || lowertext(style.id) == lowertext(name))
			return style

/**
 * # HUD Style
 *
 * Holds data on HUD styles
 *
 * * default values are on /datum/hud_style
 *
 * ## Icons
 *
 * ### inventory.dmi
 *
 * Mandatory:
 *
 * * button-equip: used as equip button
 *
 * * hand-left: self explanatory
 * * hand-left-active: self explanatory
 * * hand-right: self explanatory
 * * hand-right-active: self explanatory
 *
 * * drawer: inactive inventory drawer
 * * drawer-active: active inventory drawer
 *
 * ### inventory-slot.dmi
 *
 * Mandatory:
 *
 * * <empty string>: used as default slot render
 *
 * Optional:
 *
 * * <inventory_hud_icon_state>: states are matched to inventory slot by BYOND to render.
 *
 * ### inventory-wide.dmi
 *
 * * hand-swap: swap hands button
 */
/datum/hud_style
	abstract_type = /datum/hud_style
	/// style name
	var/name = "Unknown"
	/// style uid
	var/id

	/// inventory icons
	var/inventory_icons = 'icons/screen/hud/styles/midnight/inventory.dmi'
	/// inventory icons: slots
	var/inventory_icons_slot = 'icons/screen/hud/styles/midnight/inventory-slot.dmi'
	/// inventory icons: big
	var/inventory_icons_wide = 'icons/screen/hud/styles/midnight/inventory-wide.dmi'
	/// robot icons
	var/robot_icons = 'icons/screen/hud/robot/default.dmi'

/**
 * midnight style just inherits defaults
 */
/datum/hud_style/midnight
	name = "Midnight"
	id = "midnight"

/datum/hud_style/orange
	name = "Orange"
	id = "orange"
	inventory_icons = 'icons/screen/hud/styles/orange/inventory.dmi'
	inventory_icons_slot = 'icons/screen/hud/styles/orange/inventory-slot.dmi'
	inventory_icons_wide = 'icons/screen/hud/styles/orange/inventory-wide.dmi'

/datum/hud_style/old
	name = "Retro"
	id = "old"
	inventory_icons = 'icons/screen/hud/styles/old/inventory.dmi'
	inventory_icons_slot = 'icons/screen/hud/styles/old/inventory-slot.dmi'
	inventory_icons_wide = 'icons/screen/hud/styles/old/inventory-wide.dmi'

/datum/hud_style/white
	name = "White"
	id = "white"
	inventory_icons = 'icons/screen/hud/styles/white/inventory.dmi'
	inventory_icons_slot = 'icons/screen/hud/styles/white/inventory-slot.dmi'
	inventory_icons_wide = 'icons/screen/hud/styles/white/inventory-wide.dmi'

/datum/hud_style/minimalist
	name = "Minimalist"
	id = "minimalist"
	inventory_icons = 'icons/screen/hud/styles/minimalist/inventory.dmi'
	inventory_icons_slot = 'icons/screen/hud/styles/minimalist/inventory-slot.dmi'
	inventory_icons_wide = 'icons/screen/hud/styles/minimalist/inventory-wide.dmi'
	robot_icons = 'icons/screen/hud/robot/minimalist.dmi'

/datum/hud_style/hologram
	name = "Holographic"
	id = "hologram"
	inventory_icons = 'icons/screen/hud/styles/hologram/inventory.dmi'
	inventory_icons_slot = 'icons/screen/hud/styles/hologram/inventory-slot.dmi'
	inventory_icons_wide = 'icons/screen/hud/styles/hologram/inventory-wide.dmi'
