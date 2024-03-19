/**
 *
 * Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
 * facial hair, and possibly tattoos and stuff somewhere along the line. This file is
 * intended to be friendly for people with little to no actual coding experience.
 * The process of adding in new hairstyles has been made pain-free and easy to do.
 * Enjoy! - Doohl
 *
 *
 * Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
 * have to define any UI values for sprite accessories manually for hair and facial
 * hair. Just add in new hair types and the game will naturally adapt.
 *
 * !!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
 * to the point where you may completely corrupt a server's savefiles. Please refrain
 * from doing this unless you absolutely know what you are doing, and have defined a
 * conversion in savefile.dm
 */

// TODO: actual better way to do these
// TODO: actual better way to do "can we use this" checks because one whitelist list and a var is fucking horrible to maintain what the fuck

/datum/sprite_accessory
	abstract_type = /datum/sprite_accessory
	
	//* basics *//
	/// The preview name of the accessory.
	var/name
	/// id; must be unique globally amongst /datum/sprite_accessory's!
	var/id

	//* character setup *//
	/// Determines if the accessory will be skipped or included in random hair generations.
	/// if set, someone must be this gender to receive it
	var/random_generation_gender

	//* icon location & base state *//
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// sidedness; how many more states we need to inject for it to work
	var/icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_NONE
	#warn impl

	//* icon dimensions & alignment *//
	var/icon_dimension_x = 32
	var/icon_dimension_y = 32
	/// alignment; how we should align the sprite to the mob
	/// we will always be able to be re-aligned by the mob for obvious reasons, especially if their
	/// bodyparts are misaligned when the bodyparts in question are considered our anchors.
	var/icon_alignment = SPRITE_ACCESSORY_ALIGNMENT_IGNORE
	#warn impl

	//* rendering *//
	/// overlay/blend this in with ADD mode, rather than overlay mode.
	/// used for making stuff not look flat and other effects.
	/// a state with [icon_state]-add will be added.
	/// -front, -back, -side will be specified as needed too if this is the case.
	var/has_add_state = FALSE

	//* legacy below



	/// Restrict some styles to specific species.
	var/list/species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN)

	/// Whether or not the accessory can be affected by colouration.
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.

	/// use front/behind, citadel snowflake for now; only usable on wings/tails
	var/front_behind_system_legacy = FALSE

	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	// these two are moved up for now
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay // Icon state of an additional overlay to blend in.
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay2
	var/can_be_hidden = TRUE

/datum/sprite_accessory/proc/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side)
	var/list/layers = list()
	switch(icon_sidedness)
		if(SPRITE_ACCESSORY_SIDEDNESS_NONE)
			var/image/rendering
			rendering = image(icon, icon_state, layer_front)
			if(do_colouration)
				if(length(colors) >= 1)
					rendering.color = colors[1]
			layers += rendering
			if(extra_overlay)
				rendering = image(icon, extra_overlay, layer_front)
				if(length(colors) >= 2)
					rendering.color = colors[2]
				layers += rendering
			if(extra_overlay2)
				rendering = image(icon, extra_overlay2, layer_front)
				if(length(colors) >= 3)
					rendering.color = colors[3]
				layers += rendering
			if(has_add_state)
				var/image/adding
				adding = image(icon, "[icon_state]-add", layer_front)
				layers += adding
		if(SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND)
			var/image/rendering
			rendering = image(icon, "[icon_state]-front", layer_front)
			if(do_colouration)
				if(length(colors) >= 1)
					rendering.color = colors[1]
			layers += rendering
			rendering = image(icon, "[icon_state]-behind", layer_behind)
			if(do_colouration)
				if(length(colors) >= 1)
					rendering.color = colors[1]
			layers += rendering
			if(extra_overlay)
				rendering = image(icon, "[extra_overlay]-front", layer_front)
				if(length(colors) >= 2)
					rendering.color = colors[2]
				layers += rendering
				rendering = image(icon, "[extra_overlay]-behind", layer_behind)
				if(length(colors) >= 2)
					rendering.color = colors[2]
				layers += rendering
			if(extra_overlay2)
				rendering = image(icon, "[extra_overlay2]-front", layer_front)
				if(length(colors) >= 3)
					rendering.color = colors[3]
				layers += rendering
				rendering = image(icon, "[extra_overlay2]-behind", layer_behind)
				if(length(colors) >= 3)
					rendering.color = colors[3]
				layers += rendering
			if(has_add_state)
				var/image/adding
				adding = image(icon, "[icon_state]-add-front", layer_front)
				layers += adding
				adding = image(icon, "[icon_state]-add-behind", layer_behind)
				layers += adding

	// emit single
	var/image/single = layers[1]
	single.overlays = layers.Copy(2)

	return single
