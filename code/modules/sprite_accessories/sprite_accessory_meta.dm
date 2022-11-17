/datum/sprite_accessory_meta
	//! intrinsics
	/// abstract type
	var/abstract_type = /datum/sprite_accessory_meta
	/// id - must be unique
	var/id

	//! identity
	/// name
	var/name = "Sprite Accessory"
	/// description
	var/desc = "A thing to render on a character's body."
	/// category
	var/category = SPRITE_ACCESSORY_CATEGORY_UNKNOWN

	//! visuals
	/// icon file
	var/icon
	/// base icon state
	var/icon_state
	/// size x
	var/dimension_x = 32
	/// size y
	var/dimension_y = 32
	/// coloration mode
	var/coloration_mode = COLORATION_MODE_SIMPLE
	/// number of overlays for overlays mode
	var/coloration_overlays = 0
	/// supports emissives
	var/emissives_allowed = TRUE
	/// emissives - use _e append at end (coloration is NOT applied to emissives, even in overlays mode!)
	var/emissives_custom = FALSE
	/// use front/behind system - will append _front and _behind after state but before coloration and emissives
	var/front_behind_system = FALSE		// todo: maybe add _adj? do we even need that??

	#warn how to layer?

	//! addons
	#warn addons

	#warn rendering details below

	/**
	 * ! Sprite Accessory Icon Rendering !
	 *
	 *
	 *
	 */

	//! legacy support
	/// center? always center new accessories but legacy ones can't center yet
	var/center = FALSE

/datum/sprite_accessory_meta/proc/render_mob_appearance(mob/M, datum/sprite_accessory_data/data)

/datum/sprite_accessory_meta/proc/render_mob_emissives(mob/M, datum/sprite_accessory_data/data)

/datum/sprite_accessory_meta/proc/color_amount()
	//* abuses the fact coloration_mode is a continuous numbered enum
	var/static/list/fast = list(
		0,
		1,
		3,
		2,
		2,
		2,
		"OVERLAYS",
		"GAGS",
	)
	var/lookup = fast[coloration_mode]
	switch(lookup)
		if("OVERLAYS")
			return coloration_overlays
		if("GAGS")
			CRASH("GAGS is not supported yet??")

/datum/sprite_accessory_data/proc/allow_color_matrix()
	//* abuses the fact coloration_mode is a continuous numbered enum
	var/static/list/fast = list(
		FALSE,
		TRUE,
		FALSE,
		FALSE,
		FALSE,
		FALSE,
		TRUE,
		FALSE,
	)
	return fast[coloration_mode]
