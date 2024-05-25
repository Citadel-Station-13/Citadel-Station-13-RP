//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(hud_styles, init_hud_styles())

/proc/init_hud_styles()
	. = list()
	for(var/datum/hud_style/path as anything in subtypesof(/datum/hud_style))
		if(initial(path.abstract_type) == path)
			continue
		.[initial(path.id)] = new path

/**
 * default values are on /datum/hud_style
 */
/datum/hud_style
	abstract_type = /datum/hud_style
	/// style name
	var/name = "Unknown"
	/// style uid
	var/id

	/// inventory icons
	var/inventory_icons = 'icons/screen/hud/midnight/inventory.dmi'
	/// inventory icons: big
	var/inventory_icons_wide = 'icons/screen/hud/midnight/inventory_wide.dmi'

/**
 * midnight style just inherits defaults
 */
/datum/hud_style/midnight
	id = "midnight"

/datum/hud_style/orange
	id = "orange"
	inventory_icons = 'icons/screen/hud/orange/inventory.dmi'
	inventory_icons_wide = 'icons/screen/hud/orange/inventory_wide.dmi'

/datum/hud_style/old
	id = "old"
	inventory_icons = 'icons/screen/hud/old/inventory.dmi'
	inventory_icons_wide = 'icons/screen/hud/old/inventory_wide.dmi'

/datum/hud_style/white
	id = "white"
	inventory_icons = 'icons/screen/hud/white/inventory.dmi'
	inventory_icons_wide = 'icons/screen/hud/white/inventory_wide.dmi'

/datum/hud_style/minimalist
	id = "minimalist"
	inventory_icons = 'icons/screen/hud/minimalist/inventory.dmi'
	inventory_icons_wide = 'icons/screen/hud/minimalist/inventory_wide.dmi'

/datum/hud_style/hologram
	id = "hologram"
	inventory_icons = 'icons/screen/hud/hologram/inventory.dmi'
	inventory_icons_wide = 'icons/screen/hud/hologram/inventory_wide.dmi'
