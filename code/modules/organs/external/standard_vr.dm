//! ## Leave everything here as it is for now since this is using unique behavior.

/// For custom heads with custom parts since the base code is restricted to a single icon file.
/obj/item/organ/external/head/vr/get_icon()
	..()
	cut_overlays()
	if(!owner || !owner.species)
		return

	var/list/overlays_to_add = list()

	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		var/icon/mark_s = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[organ_tag]")
		mark_s.Blend(markings[M]["color"], mark_style.color_blend_mode)
		overlays_to_add.Add(mark_s) //So when it's not on your body, it has icons
		mob_icon.Blend(mark_s, ICON_OVERLAY) //So when it's on your body, it has icons
		icon_cache_key += "[M][markings[M]["color"]]"

	if(owner.should_have_organ(O_EYES))//Moved on top of markings.
		var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[O_EYES]
		if(eye_icon)
			var/icon/eyes_icon = new/icon(eye_icons_vr, eye_icon_vr)
			if(eyes)
				if(owner.species.species_appearance_flags & HAS_EYE_COLOR)
					eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
			else
				eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			overlays_to_add.Add(eyes_icon)

	if(owner.lip_style && (species && (species.species_appearance_flags & HAS_LIPS)))
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
		overlays_to_add.Add(lip_icon)
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = GLOB.legacy_facial_hair_lookup[owner.f_style]
		if(facial_hair_style && (!facial_hair_style.apply_restrictions || (species.get_bodytype_legacy(owner) in facial_hair_style.species_allowed)))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)
			overlays_to_add.Add(image(facial_s, "pixel_y" = head_offset))

	if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = GLOB.legacy_hair_lookup[owner.h_style]
		if(hair_style && (!hair_style.apply_restrictions || (species.get_bodytype_legacy(owner) in hair_style.species_allowed)))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration && islist(h_col) && h_col.len >= 3)
				hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_MULTIPLY)
			overlays_to_add.Add(image(hair_s, "pixel_y" = head_offset))

	add_overlay(overlays_to_add)

	return mob_icon

/obj/item/organ/external/head/vr
	var/eye_icons_vr = 'icons/mob/human_face_vr.dmi'
	var/eye_icon_vr = "blank_eyes"
	var/head_offset = 0
	eye_icon = "blank_eyes"

/obj/item/organ/external/head/vr/sergal
	eye_icon_vr = "eyes_sergal"

/obj/item/organ/external/head/vr/werebeast
	eye_icons_vr = 'icons/mob/werebeast_face_vr.dmi'
	eye_icon_vr = "werebeast_eyes"
	head_offset = 6

/obj/item/organ/external/head/vr/shadekin
	cannot_gib = 1
	cannot_amputate = 1

	eye_icons_vr = 'icons/mob/human_face_vr.dmi'
	eye_icon_vr = "eyes_shadekin"
