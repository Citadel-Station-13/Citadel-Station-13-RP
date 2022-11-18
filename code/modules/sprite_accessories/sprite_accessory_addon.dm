GLOBAL_LIST_INIT(sprite_addons, init_sprite_addons())
/proc/init_sprite_addons()
	. = list()
	for(var/path in subtypesof(/datum/sprite_accessory_addon))
		var/datum/sprite_accessory_addon/addon = path
		if(initial(addon.abstract_type) == path)
			continue
		addon = new path
		.[addon.id] = addon

/**
 * markings for markings, basically
 *
 * usually rendered INSET_OVERLAY or blended directly
 */
/datum/sprite_accessory_addon
	/// abstract type
	var/abstract_type = /datum/sprite_accessory_addon
	/// name
	var/name = "Sprite Addon"
	/// description
	var/desc = "An addon."
	/// category
	var/category = SPRITE_ADDON_CATEGORY_UNKNOWN
	/// type - must match for something to let us be used
	var/sprite_addon_type = NONE
	/// can't be put on if there's already another addon of this type
	var/sprite_addon_unique = TRUE
	/// icon file - must be centered
	var/icon
	/// icon state
	var/icon_state
	/// icon file x
	var/dimension_x
	/// icon file y
	var/dimension_y

/datum/sprite_accessory_addon/proc/render_onto(datum/sprite_accessory_data/D, mutable_appearance/MA)


