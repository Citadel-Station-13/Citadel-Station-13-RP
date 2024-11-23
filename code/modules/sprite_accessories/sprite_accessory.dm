// TODO: actual better way to do these
// TODO: actual better way to do "can we use this" checks because one whitelist list and a var is fucking horrible to maintain what the fuck

// todo: ouch at this list
GLOBAL_LIST_EMPTY(sprite_accessory_icon_cache)

/datum/prototype/sprite_accessory
	abstract_type = /datum/prototype/sprite_accessory

	//* basics *//
	/// The preview name of the accessory.
	var/name
	/// id; must be unique globally amongst /datum/prototype/sprite_accessory's!
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

	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	// these two are moved up for now
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay // Icon state of an additional overlay to blend in.
	// if this is set, we will also apply sidedness (front/behind/side enum) to it!
	var/extra_overlay2
	var/can_be_hidden = TRUE

#warn emissives support

/**
 * todo: with_base_state completely tramples extra_overlay, extra_overlay2
 * we need to redo this at some point.
 */
/datum/prototype/sprite_accessory/proc/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation, flattened)
	if(flattened)
		if(!length(GLOB.clients))
			// lol, lmao
			return
		var/list/image/layers_flat = flattened(arglist(args))
		return align_layers(layers_flat)
	if(variations?[with_variation])
		with_base_state = variations[with_variation]
	if(legacy_use_additive_color_matrix && colors)
		// clone list to not mutate original
		colors = colors.Copy()
		// transform colors into additive color matrices
		for(var/i in 1 to length(colors))
			if(islist(colors[i]))
				stack_trace("attempted to use a color matrix with legacy additive; this is not supported.")
				continue
			if(!istext(colors[i]))
				stack_trace("attempted to use non-text color string with legacy additive; this is not supported.")
			var/list/decoded = ReadRGB(colors[i])
			var/list/computed = list(
				1, 0, 0,
				0, 1, 0,
				0, 0, 1,
				decoded[1] / 255, decoded[2] / 255, decoded[3] / 255,
			)
			colors[i] = computed

	// todo: refactor so we don't need to manually build
	var/list/icon_states = list(with_base_state)
	if(extra_overlay)
		icon_states += extra_overlay
	if(extra_overlay2)
		icon_states += extra_overlay2

	var/list/layers = list()
	var/index = 0
	// process base layers
	for(var/state in icon_states)
		++index
		var/image/rendering
		// front
		rendering = image(icon, icon_sidedness > SPRITE_ACCESSORY_SIDEDNESS_NONE? "[state]-front" : "[state]", layer_front)
		if(do_colouration && length(colors) >= index)
			rendering.color = colors[index]
		// process add layer if needed
		if(has_add_state)
			var/image/adding
			adding = image(icon, icon_sidedness > SPRITE_ACCESSORY_SIDEDNESS_NONE? "[with_base_state]-add-front" : "[with_base_state]-add", layer_front)
			adding.blend_mode = BLEND_ADD
			rendering.overlays += adding
		// add
		layers += rendering

		if(icon_sidedness >= SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND)
			// behind
			rendering = image(icon, "[state]-behind", layer_behind)
			if(do_colouration && length(colors) >= index)
				rendering.color = colors[index]
			// process add layer if needed
			if(has_add_state)
				var/image/adding
				adding = image(icon, "[with_base_state]-add-behind", layer_behind)
				adding.blend_mode = BLEND_ADD
				rendering.overlays += adding
			// add
			layers += rendering

	return align_layers(layers)

/datum/prototype/sprite_accessory/proc/align_layers(list/image/layers)
	for(var/image/patching as anything in layers)
		// patching.appearance_flags = KEEP_TOGETHER
		switch(icon_alignment)
			if(SPRITE_ACCESSORY_ALIGNMENT_IGNORE)
			if(SPRITE_ACCESSORY_ALIGNMENT_BOTTOM)
				patching.pixel_x = round((WORLD_ICON_SIZE - icon_dimension_x) * 0.5)
			if(SPRITE_ACCESSORY_ALIGNMENT_CENTER)
				patching.pixel_x = round((WORLD_ICON_SIZE - icon_dimension_x) * 0.5)
				patching.pixel_y = round((WORLD_ICON_SIZE - icon_dimension_y) * 0.5)
	return layers

/**
 * order **must** be deterministic!
 */
/datum/prototype/sprite_accessory/proc/flat_cache_keys(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation, flattened)
	. = list(
		id,
		with_base_state,
	)
	. += jointext(colors, ":")

/datum/prototype/sprite_accessory/proc/flattened(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation, flattened)
	var/list/cache_keys = flat_cache_keys(arglist(args))
	var/cache_key = jointext(cache_keys, "-")
	// check the main cache key only, icon_sidedness shouldn't check at runtime
	if(isnull(GLOB.sprite_accessory_icon_cache[cache_key]))
		// for new coders: args is just a list like any other, and it's *sort of* mutable.
		// set args.flattened to FALSE
		flattened = FALSE
		// pass in args
		var/list/layers = render(arglist(args))
		// behavior past this point assumes layers cuont is always the same as sidedness.
		// as well as the sidedness being the same index as the layer
		// at time of writing,
		// 1 = front
		// 2 = behind
		// 3 = side (unimplemented)
		ASSERT(length(layers) == icon_sidedness)
		// so i yelled 'it's rendering time'
		var/client/designated_victim = pick(GLOB.clients)
		if(!designated_victim?.initialized)
			STACK_TRACE("somehow we got an uninitialized client. ouch!")
			return layers
		for(var/i in 1 to length(layers))
			var/image/casted = layers[i]
			var/icon/rendered = render_compound_icon_with_client(casted, designated_victim)
			if(!rendered)
				STACK_TRACE("something went horribly wrong ):")
				return layers
			layers[i] = rendered
		// cache things
		GLOB.sprite_accessory_icon_cache[cache_key] = layers[1]
		switch(icon_sidedness)
			if(SPRITE_ACCESSORY_SIDEDNESS_NONE)
				GLOB.sprite_accessory_icon_cache[cache_key] = layers[1]
			if(SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND)
				GLOB.sprite_accessory_icon_cache[cache_key] = layers[1]
				GLOB.sprite_accessory_icon_cache["[cache_key]-behind"] = layers[2]
	switch(icon_sidedness)
		if(SPRITE_ACCESSORY_SIDEDNESS_NONE)
			return list(
				image(
					GLOB.sprite_accessory_icon_cache[cache_key],
					layer = layer_front,
				),
			)
		if(SPRITE_ACCESSORY_SIDEDNESS_FRONT_BEHIND)
			return list(
				image(
					GLOB.sprite_accessory_icon_cache[cache_key],
					layer = layer_front,
				),
				image(
					GLOB.sprite_accessory_icon_cache["[cache_key]-behind"],
					layer = layer_behind,
				),
			)
