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
	/// can be selected
	var/selectable = TRUE

	//* coloration *//
	/// coloration mode
	//  todo: rigsuit update first, this is a placeholder
	var/coloration_mode
	/// color amount when in overlays mode; other colors will be rendered in _2, _3, etc;
	/// _add will go ontop.
	//  todo: rigsuit update first, this is a placeholder
	var/coloration_amount = 1

	//* icon location & base state *//
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// default variation is called 'Normal'
	/// assoc list; name to state.
	var/list/variations
	/// time required for one 'cycle' of a variation animation by variation
	var/list/variation_animation_times
	/// time required for one 'cycle' of a variation animation, defaulting
	var/variation_animation_time = 2 SECONDS
	/// sidedness; how many more states we need to inject for it to work
	var/icon_sidedness = SPRITE_ACCESSORY_SIDEDNESS_NONE

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

	/// use additive color matrix on the main overlay, rather than multiply
	/// this is slow, please stop using it and do proper greyscales.
	var/legacy_use_additive_color_matrix = FALSE
	#warn impl

	/// use front/behind, citadel snowflake for now; only usable on wings/tails
	var/front_behind_system_legacy = FALSE

	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	// these two are moved up for now
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay // Icon state of an additional overlay to blend in.
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay2
	var/can_be_hidden = TRUE

/**
 * todo: with_base_state completely tramples extra_overlay, extra_overlay2
 * we need to redo this at some point.
 */
/datum/sprite_accessory/proc/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation)
	if(variations?[with_variation])
		with_base_state = with_variation
	var/list/layers = list()
	if(front_behind_system_legacy)
		var/image/rendering
		rendering = image(icon, "[with_base_state]_FRONT", layer_front)
		if(do_colouration)
			if(length(colors) >= 1)
				rendering.color = colors[1]
		layers += rendering
		rendering = image(icon, "[with_base_state]_BEHIND", layer_behind)
		if(do_colouration)
			if(length(colors) >= 1)
				rendering.color = colors[1]
		layers += rendering
		if(extra_overlay)
			rendering = image(icon, "[extra_overlay]_FRONT", layer_front)
			if(length(colors) >= 2)
				rendering.color = colors[2]
			layers += rendering
			rendering = image(icon, "[extra_overlay]_BEHIND", layer_behind)
			if(length(colors) >= 2)
				rendering.color = colors[2]
			layers += rendering
		if(extra_overlay2)
			rendering = image(icon, "[extra_overlay2]_FRONT", layer_front)
			if(length(colors) >= 3)
				rendering.color = colors[3]
			layers += rendering
			rendering = image(icon, "[extra_overlay2]_BEHIND", layer_behind)
			if(length(colors) >= 3)
				rendering.color = colors[3]
			layers += rendering
	else
		switch(icon_sidedness)
			if(SPRITE_ACCESSORY_SIDEDNESS_NONE)
				var/image/rendering
				rendering = image(icon, with_base_state, layer_front)
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
					adding = image(icon, "[with_base_state]-add", layer_front)
					layers += adding
			if(SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND)
				var/image/rendering
				rendering = image(icon, "[with_base_state]-front", layer_front)
				if(do_colouration)
					if(length(colors) >= 1)
						rendering.color = colors[1]
				layers += rendering
				rendering = image(icon, "[with_base_state]-behind", layer_behind)
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
					adding = image(icon, "[with_base_state]-add-front", layer_front)
					layers += adding
					adding = image(icon, "[with_base_state]-add-behind", layer_behind)
					layers += adding

	// emit single
	var/image/single = new /image
	single.overlays = layers

	return single

//* Resolution *//

/**
 * turns a list of SPRITE_ACCESSORY_SLOT_X = accessory into the cached global accessory instances.
 *
 * accessory may be an accessory, path, or id string.
 */
/proc/resolve_sprite_accessory_key_list_inplace(list/accessories)
	for(var/key in accessories)
		var/value = accessories[key]
		if(ispath(value))
			var/datum/sprite_accessory/casted = value
			value = initial(casted.id)
		if(istext(value))
			switch(key)
				if(SPRITE_ACCESSORY_SLOT_EARS)
					value = GLOB.sprite_accessory_ears[value]
				if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
					value = GLOB.sprite_accessory_facial_hair[value]
				if(SPRITE_ACCESSORY_SLOT_HAIR)
					value = GLOB.sprite_accessory_hair[value]
				if(SPRITE_ACCESSORY_SLOT_HORNS)
					value = GLOB.sprite_accessory_ears[value]
				if(SPRITE_ACCESSORY_SLOT_TAIL)
					value = GLOB.sprite_accessory_tails[value]
				if(SPRITE_ACCESSORY_SLOT_WINGS)
					value = GLOB.sprite_accessory_wings[value]

/// by id
GLOBAL_LIST_INIT(sprite_accessory_hair, all_hair_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_ears, all_ear_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_tails, all_tail_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_wings, all_wing_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_facial_hair, all_facial_hair_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_markings, all_marking_styles())

// todo: most uses of these should either be a direct ref under new marking system or
// todo: an id to ref.
// todo: however, there are some legitimate cases of needing fast name lookup,
// todo: like non-tgui interfaces that let you choose markings
// todo: do not blindly kill these lists, we'll deal with everything as we go.

// by name
GLOBAL_LIST(legacy_hair_lookup)
// by id
GLOBAL_LIST(legacy_ears_lookup)
// by id
GLOBAL_LIST(legacy_wing_lookup)
// by id
GLOBAL_LIST(legacy_tail_lookup)
// by name
GLOBAL_LIST(legacy_facial_hair_lookup)
// by name
GLOBAL_LIST(legacy_marking_lookup)

/proc/all_hair_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/hair))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_hair_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_ear_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/ears))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_ears_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_wing_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/wing))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_wing_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_tail_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/tail))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_tail_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_facial_hair_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/facial_hair))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_facial_hair_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_marking_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/marking))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_marking_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
