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
	/// rendering layer preference
	var/request_alt_layer = FALSE
	/// rendering - should we be wagging/animated?
	var/request_animated_state = FALSE
	/// addons associated to their colors
	var/list/datum/sprite_accessory_addon/addons
	//! tracking - are we shared? some things like DNA copy references to us, they need to know if it's safe to modify
	var/is_shared_datum = FALSE
	//! strength to use for highlights
	var/highlight_strength = 1

#warn null color is DEFAULT

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
	cloned.request_alt_layer = request_alt_layer
	cloned.addons = addons.Copy()
	cloned.is_shared_datum = FALSE
	cloned.highlight_strength = highlight_strength
	cloned.request_animated_state = request_animated_state

/**
 * returns if we're equivalent to another
 */
/datum/sprite_accessory_data/proc/equivalent(datum/sprite_accessory_data/other)
	if(!other)
		return FALSE
	if(src == other)	// caching results in this often for vore transformations
		// fuck vore transformations
		return FALSE
	if(accessory.id != other.accessory.id)
		return FALSE
	if(emissives_enabled)
		if(!other.emissives_enabled || emissives_strength != other.emissives_strength)
			return FALSE
	else
		if(other.emissives_enabled)
			return FALSE
	for(var/i in 1 to color_amount())
		if(get_color_index(i) != other.get_color_index(i))
			return FALSE
	if(LAZYLEN(addons))
		var/list/ids = list()
		for(var/datum/sprite_accessory_addon/addon as anything in addons)
			ids += addon.id
		var/list/other_ids = list()
		for(var/datum/sprite_accessory_addon/addon as anything in other.addons)
			other_ids += addon.id
		if(length(ids ^ other_ids))
			return FALSE

/**
 * returns either one mutable_appearance, or a list of them to apply, with layers
 * already set.
 */
/datum/sprite_accessory_data/proc/render_mob_appearance(mob/M)
	return accessory.render_mob_appearance(M, src)

/*

/mob/living/carbon/human/proc/get_tail_image(front)
	//If you are FBP with tail style and didn't set a custom one
	var/datum/robolimb/model = isSynthetic()
	if(istype(model) && model.includes_tail && !tail_style)
		var/icon/tail_s = new/icon("icon" = synthetic.icon, "icon_state" = "tail")
		if(species.color_force_greyscale)
			tail_s.MapColors(arglist(color_matrix_greyscale()))
		tail_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		return image(tail_s)

	//If you have a custom tail selected
	if(tail_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL && !isTaurTail(tail_style)))
		var/base_state = wagging && tail_style.ani_state ? tail_style.ani_state : tail_style.icon_state
		if(tail_style.front_behind_system)
			base_state += front? "_FRONT" : "_BEHIND"
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = base_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.color_blend_mode)
		if(tail_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay_w)
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(tail_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(isTaurTail(tail_style))
			return image(tail_s, "pixel_x" = -16)
		else
			return image(tail_s)
	return null
*/

/*


/mob/living/carbon/human/proc/get_wing_image(front) //redbull gives you wings
	var/icon/grad_swing
	if(QDESTROYING(src))
		return

	//If you are FBP with wing style and didn't set a custom one
	if(synthetic && synthetic.includes_wing && !wing_style)
		var/icon/wing_s = new/icon("icon" = synthetic.icon, "icon_state" = "wing") //I dunno. If synths have some custom wing?
		wing_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		return image(wing_s)

	//If you have custom wings selected
	if(wing_style && (!(wear_suit && wear_suit.flags_inv & HIDETAIL) || !wing_style.clothing_can_hide))
		var/icon/wing_s = new/icon("icon" = wing_style.icon, "icon_state" = flapping && wing_style.ani_state ? wing_style.ani_state : (wing_style.front_behind_system? (wing_style.icon_state + (front? "_FRONT" : "_BEHIND")) : wing_style.icon_state))
		if(wing_style.do_colouration)
			if(grad_wingstyle)
				grad_swing = new/icon("icon" = 'icons/mob/wing_gradients.dmi', "icon_state" = GLOB.hair_gradients[grad_wingstyle])
				grad_swing.Blend(wing_s, ICON_AND)
				grad_swing.Blend(rgb(r_gradwing, g_gradwing, b_gradwing), ICON_MULTIPLY)
			wing_s.Blend(rgb(src.r_wing, src.g_wing, src.b_wing), wing_style.color_blend_mode)
		if(grad_swing)
			wing_s.Blend(grad_swing, ICON_OVERLAY)
		if(wing_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay)
			overlay.Blend(rgb(src.r_wing2, src.g_wing2, src.b_wing2), wing_style.color_blend_mode)
			wing_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(wing_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2)
			if(wing_style.ani_state)
				overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(wing_style.center)
			center_appearance(wing_s, wing_style.dimension_x, wing_style.dimension_y)
		return image(wing_s, "pixel_x" = -16)
*/

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


/**
 * standard ui data for sprite accessory data, useful
 * so we dont' have to redefine this a billion times
 * for different editors.
 */
/datum/sprite_accessory_data/ui_data()
	var/list/colors_built = list()
	for(var/i in 1 to color_amount())
		colors_built += get_color_index(i)
	var/list/addons_built = list()
	for(var/datum/sprite_accessory_addon/A as anything in addons)
		addons_built[A.id] = addons[A]
	return list(
		"id" = accessory.id,
		"color_mode" = accessory.coloration_mode,
		"light" = emissives_enabled,
		"light_strength" = emissives_strength,
		"colors" = colors_built,
		"alt_layer" = request_alt_layer,
		"addons" = addons_built,
		"shared" = is_shared_datum,
		"animated" = request_animated_state,
		"highlights" = highlight_strength,
	)
#warn ui struct
#warn ui struct for coloration
