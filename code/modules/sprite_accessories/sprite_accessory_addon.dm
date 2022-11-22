GLOBAL_LIST_INIT(sprite_addons, init_sprite_addons())
/proc/init_sprite_addons()
	. = list()
	for(var/path in subtypesof(/datum/sprite_accessory_addon))
		var/datum/sprite_accessory_addon/addon = path
		if(initial(addon.abstract_type) == path)
			continue
		addon = new path
		.[addon.id] = addon

/**
 * markings for markings, basically
 *
 * usually rendered INSET_OVERLAY or blended directly
 */
/datum/sprite_accessory_addon
	/// abstract type
	var/abstract_type = /datum/sprite_accessory_addon
	/// name
	var/name = "Sprite Addon"
	/// description
	var/desc = "An addon."
	/// category
	var/category = SPRITE_ADDON_CATEGORY_UNKNOWN
	/// type - must match for something to let us be used
	var/sprite_addon_type = NONE
	/// can't be put on if there's already another addon of this type
	var/sprite_addon_unique = TRUE
	/// icon file - must be centered
	var/icon
	/// icon state
	var/icon_state
	/// icon file x
	var/dimension_x
	/// icon file y
	var/dimension_y

/datum/sprite_accessory_addon/proc/render_onto(datum/sprite_accessory_data/D, mutable_appearance/MA)

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
