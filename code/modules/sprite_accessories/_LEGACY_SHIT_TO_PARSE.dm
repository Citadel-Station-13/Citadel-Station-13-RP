/*
//HAIR OVERLAY
/mob/living/carbon/human/update_hair()
	if(QDESTROYING(src))
		return

	//Reset our hair
	remove_layer(HAIR_LAYER)
	update_eyes() //Pirated out of here, for glowing eyes.

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//base icons
	var/icon/face_standing = icon(icon = 'icons/mob/human_face.dmi', icon_state = "bald_s")

	if(f_style)
		var/datum/sprite_accessory_meta/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && (!facial_hair_style.apply_restrictions || (src.species.get_bodytype_legacy(src) in facial_hair_style.species_allowed)))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), facial_hair_style.color_blend_mode)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style)
		var/datum/sprite_accessory_meta/hair/hair_style = hair_styles_list[h_style]
		if(head && (head.flags_inv & BLOCKHEADHAIR))
			if(!(hair_style.flags & HAIR_VERY_SHORT))
				hair_style = hair_styles_list["Short Hair"]

		if(hair_style && (!hair_style.apply_restrictions || (src.species.get_bodytype_legacy(src) in hair_style.species_allowed)))
			var/icon/grad_s
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			var/icon/hair_s_add
			if(hair_style.icon_add)
				hair_s_add = new/icon("icon" = hair_style.icon_add, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				if(grad_style)
					grad_s = new/icon("icon" = 'icons/mob/hair_gradients.dmi', "icon_state" = GLOB.hair_gradients[grad_style])
					grad_s.Blend(hair_s, ICON_AND)
					grad_s.Blend(rgb(r_grad, g_grad, b_grad), ICON_MULTIPLY)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_MULTIPLY)
				if(hair_s_add)
					hair_s.Blend(hair_s_add, ICON_ADD)
				if(grad_s)
					hair_s.Blend(grad_s, ICON_OVERLAY)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	var/icon/ears_s = get_ears_overlay()
	if(ears_s)
		face_standing.Blend(ears_s, ICON_OVERLAY)
	if(istype(head_organ,/obj/item/organ/external/head/vr))
		var/obj/item/organ/external/head/vr/head_organ_vr = head_organ
		overlays_standing[HAIR_LAYER] = image(face_standing, layer = BODY_LAYER+HAIR_LAYER, "pixel_y" = head_organ_vr.head_offset)
		apply_layer(HAIR_LAYER)
		return

	var/icon/horns_s = get_horns_overlay()
	if(horns_s)
		face_standing.Blend(horns_s, ICON_OVERLAY)
	if(istype(head_organ,/obj/item/organ/external/head/vr))
		var/obj/item/organ/external/head/vr/head_organ_vr = head_organ
		overlays_standing[HAIR_LAYER] = image(face_standing, layer = BODY_LAYER+HAIR_LAYER, "pixel_y" = head_organ_vr.head_offset)
		apply_layer(HAIR_LAYER)
		return

	if(head_organ.transparent)
		face_standing += rgb(,,,120)

	overlays_standing[HAIR_LAYER] = image(face_standing, layer = BODY_LAYER+HAIR_LAYER)
	apply_layer(HAIR_LAYER)



/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER
	var/list/image/tail_overlays = overlays_standing[used_tail_layer]

	remove_layer(TAIL_LAYER)
	remove_layer(TAIL_LAYER_ALT)

	if(!tail_overlays)
		return
	if(islist(tail_overlays))
		for(var/image/tail_overlay as anything in tail_overlays)
			if(species.get_tail_animation(src))
				tail_overlay.icon_state = t_state
		overlays_standing[used_tail_layer] = tail_overlays
	else
		var/image/tail_overlay = tail_overlays
		if(species.get_tail_animation(src))
			tail_overlay.icon_state = t_state
			. = tail_overlay
		overlays_standing[used_tail_layer] = tail_overlay

	apply_layer(used_tail_layer)


//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
//You can sort of flick images now with flick_overlay -Aro
/mob/living/carbon/human/proc/animate_tail_once()
	if(QDESTROYING(src))
		return

	var/t_state = "[species.get_tail(src)]_once"
	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER

	var/image/tail_overlay = overlays_standing[used_tail_layer]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state) // Calls remove_layer & apply_layer
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			if(overlays_standing[used_tail_layer] == tail_overlay && tail_overlay.icon_state == t_state)
				animate_tail_stop()

/mob/living/carbon/human/proc/animate_tail_start()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_fast()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_reset()
	if(QDESTROYING(src))
		return

	if(stat != DEAD)
		set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	else
		set_tail_state("[species.get_tail(src)]_static")
		toggle_tail_vr(FALSE) // So tails stop when someone dies. TODO - Fix this hack ~Leshana

/mob/living/carbon/human/proc/animate_tail_stop()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_static")

/// Wings! See update_icons_vr.dm for more wing procs
/mob/living/carbon/human/proc/update_wing_showing()
	if(QDESTROYING(src))
		return

	remove_layer(WING_LAYER)

	overlays_standing[WING_LAYER] = list()

	var/image/vr_wing_image = get_wing_image(TRUE)
	if(vr_wing_image)
		vr_wing_image.layer = BODY_LAYER+WING_LAYER
		overlays_standing[WING_LAYER] += vr_wing_image

	if(wing_style?.front_behind_system)
		var/image/vr_wing_image_2 = get_wing_image(FALSE)
		vr_wing_image_2.layer = BODY_LAYER - WING_LAYER
		overlays_standing[WING_LAYER] += vr_wing_image_2

	apply_layer(WING_LAYER)


*/
