GLOBAL_LIST_EMPTY(hair_gradient_icon_cache)

// todo: should we really be doing this?
/proc/hair_gradient_icon(id, list/image/layers_or_singular, gradient, width = WORLD_ICON_SIZE)
	var/image/casted_single = layers_or_singular
	var/cache_key = "[gradient]-[width]-[id]-[islist(layers_or_singular)? "combined" : casted_single.icon_state]"
	if(isnull(GLOB.hair_gradient_icon_cache[cache_key]))
		var/icon/combined
		if(islist(layers_or_singular))
			combined = icon('icons/system/blank_32x32.dmi', "4-dir")
			// gather all layers
			for(var/image/layer as anything in layers_or_singular)
				combined.Blend(icon(layer.icon, layer.icon_state, frame = 1), ICON_OVERLAY)
		else
			combined = icon(casted_single.icon, casted_single.icon_state)
		// gather gradient
		var/icon/cutting = icon('icons/mob/hair_gradients.dmi', GLOB.hair_gradients[gradient])
		// we can't make it any taller but we can make it wider..
		cutting.Scale(width, cutting.Height())
		// and them together
		cutting.Blend(combined, ICON_AND)
		// set; gradient should just be a grayscale (or otherwise) part of the hair where the gradient covers now.
		GLOB.hair_gradient_icon_cache[cache_key] = cutting
	return GLOB.hair_gradient_icon_cache[cache_key]

/datum/sprite_accessory/hair
	abstract_type = /datum/sprite_accessory/hair
	icon = 'icons/mob/human_face_m.dmi'	  // default icon for all hairs
	//Enhanced colours and hair for all
	legacy_use_additive_color_matrix = FALSE
	apply_restrictions = FALSE

	/// ignored if new has_add_state is specified
	var/icon_add_legacy = 'icons/mob/human_face.dmi'
	var/hair_flags
	/// without this, we don't put the _s at the end of the state
	/// added to allow legacy hairs to work.
	var/append_s_at_end = FALSE

/datum/sprite_accessory/hair/New()
	..()
	if(append_s_at_end)
		icon_state = "[icon_state]_s"

/datum/sprite_accessory/hair/render(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state, with_variation, flattened)
	var/list/image/layers = ..()

	if(flattened)
		return layers

	for(var/image/rendered as anything in layers)
		// first add the add state
		if(has_add_state)
			// if we have that don't do legacy behavior
		else if(icon_add_legacy)
			var/image/adding = image(icon_add_legacy, icon_state = icon_state)
			adding.blend_mode = BLEND_ADD
			rendered.overlays += adding

		// then deal with gradient if we have to
		if(do_colouration && ishuman(for_whom))
			var/mob/living/carbon/human/casted_human = for_whom
			if(casted_human.grad_style && casted_human.grad_style != "None")
				var/image/gradient_icon = image(hair_gradient_icon(id, rendered, casted_human.grad_style, icon_dimension_x))
				gradient_icon.color = rgb(
					casted_human.r_grad,
					casted_human.g_grad,
					casted_human.b_grad,
				)
				gradient_icon.blend_mode = BLEND_OVERLAY
				rendered.overlays += gradient_icon

	return layers

/datum/sprite_accessory/hair/flatten(list/colors, base_state, mob/for_whom)
	var/list/layers = ..()
	if(!ishuman(for_whom))
		return layers
	// is human, see if we need to do gradient
	var/mob/living/carbon/human/casted_human = for_whom
	var/effective_gradient = casted_human.grad_style
	if(!effective_gradient || effective_gradient == "None")
		return layers
	var/effective_gradient_color = rgb(casted_human.r_grad, casted_human.g_grad, casted_human.b_grad)
	var/cache_key = "[id]-[jointext(colors, ":")]-gradlist-[effective_gradient]-[effective_gradient_color]"
	if(isnull(GLOB.sprite_accessory_icon_cache[cache_key]))
		// now to deal with gradients
		// we do a secondary caching
		// kinda inefficient but at the same time we get to change gradient colors without having to re-blend everything else
		// good if we ever get a proper IC hair highlight modification system.
		var/list/image/original_layers = list(image(icon, base_state))
		if(extra_overlay)
			original_layers += image(icon, extra_overlay)
		if(extra_overlay2)
			original_layers += image(icon, extra_overlay2)
		// get combined icon
		var/icon/processed_gradient = hair_gradient_icon(id, original_layers, effective_gradient, icon_dimension_x)
		var/icon/colored_gradient = icon(processed_gradient)
		// blend in color
		colored_gradient.Blend(effective_gradient_color, ICON_MULTIPLY)
		var/list/new_layers = list()
		for(var/icon/patching as anything in layers)
			var/icon/original = patching
			patching = icon(patching)
			patching.Blend(colored_gradient, ICON_AND)
			// todo: this is slow but i can't be assed to further refactor
			// this is because ICON_AND obliterates the rest of the icon
			// so we re-blend it onto the original.
			patching.Blend(original, ICON_UNDERLAY)
			new_layers += patching
		GLOB.sprite_accessory_icon_cache[cache_key] = new_layers
	return GLOB.sprite_accessory_icon_cache[cache_key]

/datum/sprite_accessory/hair/do_special_snowflake_legacy_shit_to(icon/I, sidedness_index)
	. = ..()
	// assure that:
	// 1. we are on legacy mode
	// 2. we only have one layer
	if(icon_add_legacy && !has_add_state && icon_sidedness == SPRITE_ACCESSORY_SIDEDNESS_NONE)
		// operate on the only layer
		var/icon/adding = icon(icon_add_legacy, icon_state = icon_state)
		I.Blend(adding, ICON_ADD)

/datum/sprite_accessory/hair/legacy
	abstract_type = /datum/sprite_accessory/hair/legacy
	append_s_at_end = TRUE
