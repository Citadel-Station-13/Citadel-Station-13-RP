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
	/// icon file - must be centered
	var/icon
	/// icon state
	var/icon_state
	/// icon file x
	var/dimension_x
	/// icon file y
	var/dimension_y

/datum/sprite_accessory_addon/proc/render_onto(datum/sprite_accessory_data/D, mutable_appearance/MA)


