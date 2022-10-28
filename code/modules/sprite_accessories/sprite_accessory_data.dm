/**
 * struct holding onmob rendering data and acts as middleware between
 * the sprite accessory + rendering data on it, and the
 * mob holding it.
 */
// todo: rename to sprite_accessory, rename sprite_accessorry to sprite_accessory_meta
/datum/sprite_accessory_data
	/// reference to accessory
	var/datum/sprite_accessory/accessory
	/// emissives enabled?
	var/emissives_enabled = FALSE
	//! at the moment we don't need full GAGS so we "abstract" around the fact we don't actually use packed color string or colors list
	/// color 1
	var/color1 = "#ffffff"
	/// color 2
	var/color2 = "#ffffff"
	/// color 3
	var/color3 = "#ffffff"

	#warn layers?
	/// addons
	var/list/datum/sprite_accessory_addon/addons

/**
 * returns either one mutable_appearance, or a list of them to apply, with layers
 * already set.
 */
/datum/sprite_accessory_data/proc/render_mob_appearance(mob/M)
	return accessory?.render_mob_appearance(M, src)

/datum/sprite_accessory_data/proc/get_color_index(i)

/datum/sprite_accessory_data/proc/set_color_index(i, color)

/**
 * sets colors with a packed coloration string
 */
/datum/sprite_accessory_data/proc/set_colors(coloration_string)

/**
 * returns a packed coloration string
 */
/datum/sprite_accessory_data/proc/get_colors()
