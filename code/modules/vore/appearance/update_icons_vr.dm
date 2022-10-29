var/global/list/wing_icon_cache = list()

/mob/living/carbon/human/proc/get_ears_overlay()
	if(ear_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/ears_s = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.icon_state)
		if(ear_style.do_colouration)
			ears_s.Blend(rgb(src.r_ears, src.g_ears, src.b_ears), ear_style.color_blend_mode)

		if(ear_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay)
			overlay.Blend(rgb(src.r_ears2, src.g_ears2, src.b_ears2), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(ear_style.extra_overlay2) //MORE COLOURS IS BETTERER
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay2)
			overlay.Blend(rgb(src.r_ears3, src.g_ears3, src.b_ears3), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		return ears_s
	return null

/mob/living/carbon/human/proc/get_horns_overlay()
	if(horn_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/horn_s = new/icon("icon" = horn_style.icon, "icon_state" = horn_style.icon_state)
		if(horn_style.do_colouration)
			horn_s.Blend(rgb(src.r_horn, src.g_horn, src.b_horn), horn_style.color_blend_mode)

		if(horn_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = horn_style.icon, "icon_state" = horn_style.extra_overlay)
			overlay.Blend(rgb(src.r_horn2, src.g_horn2, src.b_horn2), horn_style.color_blend_mode)
			horn_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(horn_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = horn_style.icon, "icon_state" = horn_style.extra_overlay2)
			overlay.Blend(rgb(src.r_horn3, src.g_horn3, src.b_horn3), horn_style.color_blend_mode)
			horn_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		return horn_s
	return null

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
