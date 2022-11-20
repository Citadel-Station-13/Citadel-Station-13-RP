GLOBAL_LIST_INIT(sprite_accessories, init_sprite_accessories())
/proc/init_sprite_accessories()
	. = list()
	for(var/path in subtypesof(/datum/sprite_accessory_meta))
		var/datum/sprite_accessory_meta/sprite = path
		if(initial(sprite.abstract_type) == path)
			continue
		sprite = new path
		if(!sprite.id)
			stack_trace("no id on accessory [path]")
			continue
		if(.[sprite.id])
			stack_trace("collision on accessory [path], id [id] with [.[sprite.id]].")
			continue
		.[sprite.id] = sprite

/proc/resolve_sprite_accessory(datum/sprite_accessory_meta/id_path_datum)
	if(istype(id_path_datum))
		return id_path_datum
	if(istext(id_path_datum))
		return GLOB.sprite_accessories[id_path_datum]
	if(ispath(id_path_datum))
		var/datum/sprite_accessory_meta/M = id_path_datum
		return GLOB.sprite_accessories[initial(M.id)]
	CRASH("what?")

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

	//! Species/Bodytype Locking
	/// allowed bodytype - flags; overrides everything
	var/allow_bodytypes = ~(BODYTYPES_NONHUMAN)
	/// allowed character species - ids; null to allow all; overrides forbid
	var/list/allow_species
	/// forbid character species - ids; null to allow all
	var/list/forbid_species

	//! Randomgen hints
	/// suggested gender for randomgen
	var/randomgen_hint_gender = NEUTER

	//! rendering
	/// blocked by these flags
	var/hidden_inv_flags
	/// rendering layer - primary
	var/render_layer
	/// rendering layer - alt
	var/render_layer_alt

	//! addons
	/// allowed addon types
	var/sprite_addon_type = NONE

	#warn rendering details
	/**
	 * ! Sprite Accessory Icon Rendering !
	 *
	 *
	 *
	 */

	//! legacy support
	/// center? always center new accessories but legacy ones can't center yet
	var/center = FALSE

/**
 * renders mob appearance
 * returns mutable appearance or list of mutable appearances
 */
/datum/sprite_accessory_meta/proc/render_mob_appearance(mob/M, datum/sprite_accessory_data/data)

/**
 * renders emissive overlay to be put onto a mob's renderer
 * returns mutable appearance or list of mutable appearances
 */
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
