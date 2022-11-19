/**
 * struct holding onmob rendering data and acts as middleware between
 * the sprite accessory + rendering data on it, and the
 * mob holding it.
 */
// todo: rename to sprite_accessory, rename sprite_accessorry to sprite_accessory_meta
/datum/sprite_accessory_data
	/// reference to accessory
	var/datum/sprite_accessory_meta/accessory
	/// emissives enabled?
	var/emissives_enabled = FALSE
	/// emissives strength, 0 to 100 percent
	var/emissives_strength = 100
	//! at the moment we don't need full GAGS so we "abstract" around the fact we don't actually use packed color string or colors list
	/// color 1
	var/color_1 = "#ffffff"
	/// color 2
	var/color_2 = "#ffffff"
	/// color 3
	var/color_3 = "#ffffff"
	/// addon color
	var/color_addon = "#ffffff"
	/// rendering layer preference
	var/request_alt_layer = FALSE
	/// addons
	var/list/datum/sprite_accessory_addon/addons
	//! tracking - are we shared? some things like DNA copy references to us, they need to know if it's safe to modify
	var/is_shared_datum = FALSE

/datum/sprite_accessory_data/New(datum/sprite_accessory_meta/accessory)
	src.accessory = accessory

/**
 * returns a new data of us
 */
/datum/sprite_accessory_data/proc/clone()
	var/datum/sprite_accessory_data/cloned = new(accessory)
	cloned.emissives_enabled = emissives_enabled
	cloned.emissives_strength = emissives_strength
	cloned.color_1 = color_1
	cloned.color_2 = color_2
	cloned.color_3 = color_3
	cloned.color_addon = color_addon
	cloned.request_alt_layer = request_alt_layer
	cloned.addons = addons.Copy()
	cloned.is_shared_datum = FALSE

/**
 * returns either one mutable_appearance, or a list of them to apply, with layers
 * already set.
 */
/datum/sprite_accessory_data/proc/render_mob_appearance(mob/M)
	return accessory.render_mob_appearance(M, src)

/**
 * returns either one mutable_appearance, or a list of them to apply, with layers
 * already set.
 */
/datum/sprite_accessory_data/proc/render_mob_emissives(mob/M)
	return accessory.render_mob_emissives(M, src)

/**
 * returns color as #abcdef
 */
/datum/sprite_accessory_data/proc/get_color_index(i)
	if(i > color_amount())
		return null
	switch(i)
		if(1)
			return color_1
		if(2)
			return color_2
		if(3)
			return color_3

/**
 * sets color to color as #abcdef
 */
/datum/sprite_accessory_data/proc/set_color_index(i, color)
	if(islist(color)? is_list_vaguely_color_matrix_length(color) :is_hexcolor(color))
		CRASH("invalid hexcolor")
	if(i > color_amount())
		return FALSE
	switch(i)
		if(1)
			color_1 = color
			return TRUE
		if(2)
			color_2 = color
			return TRUE
		if(3)
			color_3 = color
			return TRUE
	return FALSE

/**
 * gets addon color
 */
/datum/sprite_accessory_data/proc/get_addon_color(id)
	#warn impl

/**
 * sets addon color
 */
/datum/sprite_accessory_data/proc/set_addon_color(id, color)
	#warn impl

/**
 * gets our color amount
 */
/datum/sprite_accessory_data/proc/color_amount()
	return accessory.color_amount()

/**
 * sets colors with a packed coloration string
 */
/datum/sprite_accessory_data/proc/set_coloration(coloration_string)
	var/list/unpacked = unpack_coloration_string(coloration_string)
	for(var/i in 1 to length(unpacked))
		set_color_index(i, unpacked[i])

/**
 * returns a packed coloration string
 */
/datum/sprite_accessory_data/proc/get_coloration()
	var/list/packing = list()
	for(var/i in 1 to color_amount())
		packing += get_color_index(i)
	return pack_coloration_string(packing)

