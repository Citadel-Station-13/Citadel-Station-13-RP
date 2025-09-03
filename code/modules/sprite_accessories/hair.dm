GLOBAL_LIST_INIT(hair_gradients, list(
	"None"				= "none",
	"Fade (Up)"			= "fadeup",
	"Fade Low (Up)"		= "fadeup_low",
	"Fade (Down)"		= "fadedown",
	"Fade Low (Down)"	= "fadedown_low",
	"Fade High (Down)"	= "fadedown_high",
	"Reflected (Center)"= "reflected",
	"Reflected Inverse (Center)"= "reflected_inverse",
	"Vertical Split (Back)"= "vsplit_back",
	"Vertical Split"	= "vsplit",
	"Vertical Split (Back, Front Effect)"= "vsplit_dual",
	"Bottom (Flat)"		= "bottomflat",
	"Shoulders (Flat)"	= "shouldersflat",
	"Wavy"				= "wavy",
	"Wavy Sharp Spikes"		= "wavy_spiked",
	"Wavy Smooth Spikes"		= "wavy_smooth",
	"Wavy Smoothish Spikes"		= "wavy_smooth2",
	"Striped"			= "striped",
	"Striped (Vertical)"= "striped_vertical"
	))

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
			adding.appearance_flags = RESET_COLOR
			adding.dir = NONE
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
				gradient_icon.appearance_flags = RESET_COLOR
				gradient_icon.dir = NONE
				rendered.overlays += gradient_icon

	return layers

/datum/sprite_accessory/hair/flat_cache_keys(mob/for_whom, list/colors, layer_front, layer_behind, layer_side, with_base_state = icon_state, with_variation, flattened)
	. = ..()
	if(!ishuman(for_whom))
		return
	var/mob/living/carbon/human/casted_human = for_whom
	. += casted_human.grad_style
	. += rgb(casted_human.r_grad, casted_human.g_grad, casted_human.b_grad)

/datum/sprite_accessory/hair/legacy
	abstract_type = /datum/sprite_accessory/hair/legacy
	append_s_at_end = TRUE
