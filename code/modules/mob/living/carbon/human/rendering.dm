/mob/living/carbon/human/proc/render_spriteacc_ears()
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	if(isnull(ear_style))
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	var/rendered = ear_style.render(
		src,
		list(
			rgb(r_ears, g_ears, b_ears),
			rgb(r_ears2, g_ears2, b_ears2),
			rgb(r_ears3, g_ears3, b_ears3),
		),
		HUMAN_LAYER_SPRITEACC_EARS_FRONT,
		HUMAN_LAYER_SPRITEACC_EARS_BEHIND,
		0, // TODO
	)
	// todo: awful snowflake shifting system
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset
	set_standing_overlay(HUMAN_OVERLAY_EARS, rendered)

/mob/living/carbon/human/proc/render_spriteacc_horns()
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	if(isnull(horn_style))
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	var/rendered = ear_style.render(
		src,
		list(
			rgb(r_horn, g_horn, b_horn),
			rgb(r_horn2, g_horn2, b_horn2),
			rgb(r_horn3, g_horn3, b_horn3),
		),
		HUMAN_LAYER_SPRITEACC_HORNS_FRONT,
		HUMAN_LAYER_SPRITEACC_HORNS_BEHIND,
		0, // TODO
	)
	// todo: awful snowflake shifting system
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset

	set_standing_overlay(HUMAN_OVERLAY_HORNS, rendered)
	
/mob/living/carbon/human/proc/render_spriteacc_facehair()
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & BLOCKHAIR)
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	if(isnull(f_style))
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	var/datum/sprite_accessory/hair/facial_hair/beard_style = GLOB.legacy_facial_hair_lookup[f_style]
	if(isnull(beard_style))
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	set_standing_overlay(HUMAN_OVERLAY_FACEHAIR, beard_style.render(
		src,
		list(
			rgb(r_facial, g_facial, b_facial),
		),
		HUMAN_LAYER_SPRITEACC_FACEHAIR_FRONT,
		HUMNA_LAYER_SPRITEACC_FACEHAIR_BEHIND,
		0, // TODO
	))

/mob/living/carbon/human/proc/render_spriteacc_hair()
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	if(isnull(h_style))
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	var/datum/sprite_accessory/hair/hair_style = GLOB.legacy_hair_lookup[h_style]
	if(isnull(hair_style))
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	// todo: what is this for?
	// if(head && (head.inv_hide_flags & BLOCKHEADHAIR))
	// 	if(!(hair_style.hair_flags & HAIR_VERY_SHORT))
	// 		hair_style = GLOB.legacy_hair_lookup["Short Hair"]
	set_standing_overlay(HUMAN_OVERLAY_HAIR, hair_style.render(
		src,
		list(
			rgb(r_hair, g_hair, b_hair),
		),
		HUMAN_LAYER_SPRITEACC_FACEHAIR_FRONT,
		HUMNA_LAYER_SPRITEACC_FACEHAIR_BEHIND,
		0, // TODO
	))

//! old code below

/mob/living/carbon/human/proc/render_spriteacc_wings()

/mob/living/carbon/human/proc/render_spriteacc_tail()


//? Sprite Accessories
var/global/list/wing_icon_cache = list()

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
	if(tail_style && !(wear_suit && wear_suit.inv_hide_flags & HIDETAIL && !isTaurTail(tail_style)))
		var/base_state = wagging && tail_style.ani_state ? tail_style.ani_state : tail_style.icon_state
		if(tail_style.front_behind_system_legacy)
			base_state += front? "_FRONT" : "_BEHIND"
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = base_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.color_blend_mode)
		if(tail_style.extra_overlay)
			var/extra_overlay_state = tail_style.front_behind_system_legacy ? "[tail_style.extra_overlay][front ? "_FRONT" : "_BEHIND"]" : tail_style.extra_overlay
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = extra_overlay_state)
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

//HAIR OVERLAY
/mob/living/carbon/human/update_hair()
	update_eyes() //Pirated out of here, for glowing eyes.

	if(istype(head_organ,/obj/item/organ/external/head/vr))
		var/obj/item/organ/external/head/vr/head_organ_vr = head_organ
		head_spriteacc_offset = head_organ_vr.head_offset
	else
		head_spriteacc_offset = 0

	render_spriteacc_ears()
	render_spriteacc_horns()
	render_spriteacc_hair()
	render_spriteacc_facehair()

	face_standing += rgb(,,,head_organ.hair_opacity)

#warn below

/mob/living/carbon/human/proc/update_tail_showing()
	if(QDESTROYING(src))
		return

	remove_layer(TAIL_LAYER)
	remove_layer(TAIL_LAYER_ALT)

	if(hiding_tail && tail_style.can_be_hidden)
		return

	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER

	var/list/image/tail_images = list()

	var/image/rendering
	rendering = get_tail_image(TRUE)
	if(rendering)
		rendering.layer = BODY_LAYER + used_tail_layer
		tail_images += rendering

	if(tail_style?.front_behind_system_legacy)
		rendering = get_tail_image(FALSE)
		rendering.layer = BODY_LAYER - used_tail_layer
		tail_images += rendering

	if(length(tail_images))
		overlays_standing[used_tail_layer] = tail_images
		apply_layer(used_tail_layer)
		return

	var/species_tail = species.get_tail(src) // Species tail icon_state prefix.

	//This one is actually not that bad I guess.
	if(species_tail && !(wear_suit && wear_suit.inv_hide_flags & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[used_tail_layer] = image(icon = tail_s, icon_state = "[species_tail]_s", layer = BODY_LAYER+used_tail_layer)
		animate_tail_reset()

//TODO: Is this the appropriate place for this, and not on species...?
/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = GLOB.tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/species_tail_anim = species.get_tail_animation(src)
		if(!species_tail_anim && species.icobase_tail)
			species_tail_anim = species.icobase // Allow override of file for non-animated tails
		if(!species_tail_anim)
			species_tail_anim = 'icons/effects/species.dmi'
		tail_icon = new/icon(species_tail_anim)
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		// The following will not work with animated tails.
		var/use_species_tail = species.get_tail_hair(src)
		if(use_species_tail)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]_[use_species_tail]_s") // Suffix icon state string with '_s' to compensate for diff in .dmi b/w us & Polaris. //TODO: No.
			if(species.color_force_greyscale)
				hair_icon.MapColors(arglist(color_matrix_greyscale()))
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), species.color_mult ? ICON_MULTIPLY : ICON_ADD) // Check for species color_mult
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		GLOB.tail_icon_cache[icon_key] = tail_icon

	return tail_icon

/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER
	var/list/image/tail_overlays = overlays_standing[used_tail_layer]

	remove_layer(TAIL_LAYER)
	remove_layer(TAIL_LAYER_ALT)

	if(!tail_overlays || hiding_tail)
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

	if(hiding_wings && wing_style.can_be_hidden)
		return

	overlays_standing[WING_LAYER] = list()

	var/image/vr_wing_image = get_wing_image(TRUE)
	if(vr_wing_image)
		vr_wing_image.layer = HUMAN_LAYER_WING
		overlays_standing[WING_LAYER] += vr_wing_image

	if(wing_style?.front_behind_system_legacy)
		var/image/vr_wing_image_2 = get_wing_image(FALSE)
		vr_wing_image_2.layer = BODY_LAYER - WING_LAYER
		overlays_standing[WING_LAYER] += vr_wing_image_2

	apply_layer(WING_LAYER)

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
	if(wing_style && (!(wear_suit && wear_suit.inv_hide_flags & HIDETAIL) || !wing_style.clothing_can_hide))
		var/icon/wing_s = new/icon("icon" = wing_style.icon, "icon_state" = spread ? wing_style.spr_state : (flapping && wing_style.ani_state ? wing_style.ani_state : (wing_style.front_behind_system_legacy? (wing_style.icon_state + (front? "_FRONT" : "_BEHIND")) : wing_style.icon_state)))
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

//? Body

/mob/living/carbon/human/update_damage_overlay()
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(icon = species.damage_overlays, icon_state = "00", layer = HUMAN_LAYER_DAMAGE)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype_legacy(src)]"
		if(GLOB.damage_icon_parts[cache_index] == null)
			DI = icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			GLOB.damage_icon_parts[cache_index] = DI
		else
			DI = GLOB.damage_icon_parts[cache_index]

		standing_image.add_overlay(DI)

	set_standing_overlay(HUMAN_OVERLAY_DAMAGE, standing_image)

//BASE MOB SPRITE
/mob/living/carbon/human/update_icons_body()
	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (MUTATION_HUSK in src.mutations)
	var/fat = (MUTATION_FAT in src.mutations)
	var/hulk = (MUTATION_HULK in src.mutations)
	var/skeleton = (MUTATION_SKELETON in src.mutations)

	robolimb_count = 0 //TODO, here, really tho?
	robobody_count = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	var/icon/stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")

	var/g = gender == FEMALE ? "f" : "m"
	/* 	This was the prior code before the above line. It was faulty and has been commented out.
	var/g = "male"
	if(gender == FEMALE)
		g = "female"
	*/

	var/icon_key = "[species.get_race_key(src)][s_base][g][s_tone][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "[r_eyes], [g_eyes], [b_eyes]"

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	if(head)
		if(!istype(head, /obj/item/organ/external/stump))
			icon_key += "[head.eye_icon]"
	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		// Allowing tails to prevent bodyparts rendering, granting more spriter freedom for taur/digitigrade stuff.
		if(isnull(part) || part.is_stump() || part.is_hidden_by_tail())
			icon_key += "0"
			continue
		if(part)
			icon_key += "[part.name]"
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.s_tone]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
				if(species.color_force_greyscale)
					icon_key += "_ags"
				if(species.color_mult)
					icon_key += "[ICON_MULTIPLY]"
				else
					icon_key += "[ICON_ADD]"
			else
				icon_key += "#000000"
			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

			if(part.robotic >= ORGAN_ROBOT)
				icon_key += "2[part.model ? "-[part.model]": ""]"
				robolimb_count++
				if((part.robotic == ORGAN_ROBOT || part.robotic == ORGAN_LIFELIKE || part.robotic == ORGAN_NANOFORM) && (part.organ_tag == BP_HEAD || part.organ_tag == BP_TORSO || part.organ_tag == BP_GROIN))
					robobody_count ++
			else if(part.status & ORGAN_DEAD)
				icon_key += "3"
			else
				icon_key += "1"
			if(part.transparent)
				icon_key += "_t"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"

	var/icon/base_icon
	if(GLOB.human_icon_cache[icon_key])
		base_icon = GLOB.human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_TORSO)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			if(isnull(part) || part.is_stump() || part.is_hidden_by_tail())
				continue
			var/icon/temp = part.get_icon(skeleton)
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else if(part.icon_position & UNDER)
				base_icon.Blend(temp, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		// Handle husk overlay.
		if(husk)
			var/husk_icon = species.get_husk_icon(src)
			if(husk_icon)
				var/icon/mask = new(base_icon)
				var/icon/husk_over = new(species.husk_icon,"")
				mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
				husk_over.Blend(mask, ICON_ADD)
				base_icon.Blend(husk_over, ICON_OVERLAY)

		GLOB.human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)
	icon = stand_icon

	//tail
	update_tail_showing()
	//wing
	update_wing_showing()

/mob/living/carbon/human/proc/update_skin()
	var/image/skin = species.update_skin(src)
	set_standing_overlay(HUMAN_OVERLAY_SKIN, skin)

/mob/living/carbon/human/proc/update_bloodied()
	if(!blood_DNA && !feet_blood_DNA)
		remove_standing_overlay(HUMAN_OVERLAY_BLOOD)
		return

	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = HUMAN_LAYER_BLOOD)

	//Bloody hands
	if(blood_DNA)
		var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "bloodyhands", layer = HUMAN_LAYER_BLOOD)
		bloodsies.color = hand_blood_color
		both.add_overlay(bloodsies)

	//Bloody feet
	if(feet_blood_DNA)
		var/image/bloodsies = image(icon = species.get_blood_mask(src), icon_state = "shoeblood", layer = HUMAN_LAYER_BLOOD)
		bloodsies.color = feet_blood_color
		both.add_overlay(bloodsies)

	set_standing_overlay(HUMAN_OVERLAY_BLOOD, both)

//! disabled for shitcode reasons; rewrite later? it was directly writing to an occupied overlay standing,
//  which is a memory leak.
// /mob/living/carbon/human/proc/BloodyMouth()

// 	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = HUMAN_LAYER_BLOOD)

// 	//"lol", said the scorpion, "lmao"
// 	var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "redwings", layer = HUMAN_LAYER_BLOOD)
// 	bloodsies.color = src.species.blood_color
// 	both.add_overlay(bloodsies)

// 	overlays_standing[BLOOD_LAYER] = both

// 	apply_layer(BLOOD_LAYER)

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear()
	if(!(species.species_appearance_flags & HAS_UNDERWEAR))
		remove_standing_overlay(HUMAN_OVERLAY_UNDERWEAR)
		return
	var/list/setting = list()
	for(var/category in all_underwear)
		if(hide_underwear[category])
			continue
		var/datum/category_item/underwear/UWI = all_underwear[category]
		var/image/wear = UWI.generate_image(all_underwear_metadata[category], layer = HUMAN_LAYER_UNDERWEAR)
		setting += wear
	set_standing_overlay(HUMAN_OVERLAY_UNDERWEAR, setting)

/mob/living/carbon/human/update_eyes()
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		eyes.update_colour()
		update_icons_body()

	//TODO: Probably redo this. I know I wrote it, but...

	//This is ONLY for glowing eyes for now. Boring flat eyes are done by the head's own proc.
	if(!species.has_glowing_eyes)
		remove_standing_overlay(HUMAN_OVERLAY_EYES)
		return

	//Our glowy eyes should be hidden if some equipment hides them.
	if(!should_have_organ(O_EYES) || (head && (head.inv_hide_flags & BLOCKHAIR)) || (wear_mask && (wear_mask.inv_hide_flags & BLOCKHAIR)))
		remove_standing_overlay(HUMAN_OVERLAY_EYES)
		return

	//Get the head, we'll need it later.
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		remove_standing_overlay(HUMAN_OVERLAY_EYES)
		return

	//The eyes store the color themselves, funny enough.
	if(!head_organ.eye_icon)
		remove_standing_overlay(HUMAN_OVERLAY_EYES)
		return

	var/icon/eyes_icon = new/icon(head_organ.eye_icon_location, head_organ.eye_icon)
	if(eyes)
		eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
	else
		eyes_icon.Blend(rgb(128,0,0), ICON_ADD)

	var/image/eyes_image = image(eyes_icon)
	eyes_image.plane = ABOVE_LIGHTING_PLANE

	set_standing_overlay(HUMAN_OVERLAY_EYES, eyes_image)

/mob/living/carbon/human/update_mutations()
	if(!LAZYLEN(mutations))
		remove_standing_overlay(HUMAN_OVERLAY_MUTATIONS)
		return //No mutations, no icons.

	//TODO: THIS PROC???
	var/fat
	if(MUTATION_FAT in mutations)
		fat = "fat"

	var/image/standing	= image(icon = 'icons/effects/genetics.dmi', layer = HUMAN_LAYER_MUTATIONS)
	var/g = gender == FEMALE ? "f" : "m"

	for(var/datum/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay = gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay

	for(var/mut in mutations)
		if(mut == MUTATION_LASER)
			standing.overlays += "lasereyes_s" //TODO

	set_standing_overlay(HUMAN_OVERLAY_MUTATIONS, standing)

//? Misc

/mob/living/carbon/human/update_modifier_visuals()
	if(!LAZYLEN(modifiers))
		remove_standing_overlay(HUMAN_OVERLAY_MODIFIERS)
		return //No modifiers, no effects.

	var/image/effects = new()
	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image(icon = 'icons/mob/modifier_effects.dmi', icon_state = M.mob_overlay_state)
			effects.add_overlay(I) //TODO, this compositing is annoying.

	set_standing_overlay(HUMAN_OVERLAY_MODIFIERS, effects)

/mob/living/carbon/human/update_fire()
	if(!on_fire)
		remove_standing_overlay(HUMAN_OVERLAY_FIRE)
		return
	set_standing_overlay(
		HUMAN_OVERLAY_FIRE,
		image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state(), layer = HUMAN_LAYER_FIRE),
	)

/mob/living/carbon/human/update_water()
	var/depth = check_submerged()
	if(!depth || lying)
		remove_standing_overlay(HUMAN_OVERLAY_LIQUID)
		return
	var/image/applying
	if(depth < 3)
		applying = image(icon = 'icons/mob/submerged.dmi', icon_state = "human_swimming_[depth]", layer = HUMAN_LAYER_LIQUID) //TODO: Improve
	if(depth == 4)
		applying = image(icon = 'icons/mob/submerged.dmi', icon_state = "hacid_1", layer = HUMAN_LAYER_LIQUID)
	if(depth == 5)
		applying = image(icon = 'icons/mob/submerged.dmi', icon_state = "hacid_2", layer = HUMAN_LAYER_LIQUID)
	if(depth == 6)
		applying = image(icon = 'icons/mob/submerged.dmi', icon_state = "hblood_1", layer = HUMAN_LAYER_LIQUID)
	if(depth == 7)
		applying = image(icon = 'icons/mob/submerged.dmi', icon_state = "hblood_2", layer = HUMAN_LAYER_LIQUID)
	set_standing_overlay(HUMAN_OVERLAY_LIQUID, applying)

// todo: burn with fire
/mob/living/carbon/human/update_acidsub()
	var/depth = check_submerged()
	if(!depth || lying)
		remove_standing_overlay(HUMAN_OVERLAY_LIQUID)
		return

	set_standing_overlay(
		HUMAN_OVERLAY_LIQUID,
		image(icon = 'icons/mob/submerged.dmi', icon_state = "hacid_[depth]", layer = HUMAN_LAYER_LIQUID),
	)

// todo: burn with fire
/mob/living/carbon/human/update_bloodsub()
	var/depth = check_submerged()
	if(!depth || lying)
		remove_standing_overlay(HUMAN_OVERLAY_LIQUID)
		return

	set_standing_overlay(
		HUMAN_OVERLAY_LIQUID,
		image(icon = 'icons/mob/submerged.dmi', icon_state = "hblood_[depth]", layer = HUMAN_LAYER_LIQUID),
	)

/mob/living/carbon/human/proc/update_surgery()
	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image(icon = 'icons/mob/surgery.dmi',  icon_state = "[E.icon_name][round(E.open)]", layer = HUMAN_LAYER_SURGERY)
			total.add_overlay(I) //TODO: This compositing is annoying

	if(length(total.overlays))
		set_standing_overlay(HUMAN_OVERLAY_SURGERY, total)
	else
		remove_standing_overlay(HUMAN_OVERLAY_SURGERY)

//? Inventory

/mob/living/carbon/human/update_inv_w_uniform()

	//Shoes can be affected by uniform being drawn onto them
	update_inv_shoes()

	if(!w_uniform)
		return

	if(wear_suit && (wear_suit.inv_hide_flags & HIDEJUMPSUIT) && !istype(wear_suit, /obj/item/clothing/suit/space/hardsuit))
		return //Wearing a suit that prevents uniform rendering

	//Build a uniform sprite
	var/icon/c_mask = tail_style?.clip_mask
	if(c_mask)
		var/obj/item/clothing/suit/S = wear_suit
		if((wear_suit?.inv_hide_flags & HIDETAIL) || (istype(S) && S.taurized)) // Reasons to not mask: 1. If you're wearing a suit that hides the tail or if you're wearing a taurized suit.
			c_mask = null
	var/list/MA_or_list = w_uniform.render_mob_appearance(src, SLOT_ID_UNIFORM, species.get_effective_bodytype(src, w_uniform, SLOT_ID_UNIFORM))

	if(c_mask)
		if(islist(MA_or_list))
			for(var/mutable_appearance/MA2 as anything in MA_or_list)
				MA2.filters += filter(type = "alpha", icon = c_mask)
		else
			var/mutable_appearance/MA = MA_or_list
			MA.filters += filter(type = "alpha", icon = c_mask)
	overlays_standing[UNIFORM_LAYER] = MA_or_list

	apply_layer(UNIFORM_LAYER)

/mob/living/carbon/human/update_inv_wear_id()
	inventory.update_slot_render(SLOT_ID_WORN_ID)

/mob/living/carbon/human/update_inv_gloves()
	inventory.update_slot_render(SLOT_ID_GLOVES)

/mob/living/carbon/human/update_inv_glasses()
	inventory.update_slot_render(SLOT_ID_GLASSES)

/mob/living/carbon/human/update_inv_ears()
	inventory.update_slot_render(SLOT_ID_LEFT_EAR)
	inventory.update_slot_render(SLOT_ID_RIGHT_EAR)

/mob/living/carbon/human/update_inv_shoes()
	inventory.update_slot_render(SLOT_ID_SHOES)

/mob/living/carbon/human/update_inv_s_store()
	inventory.update_slot_render(SLOT_ID_SUIT_STORAGE)

/mob/living/carbon/human/update_inv_head()
	inventory.update_slot_render(SLOT_ID_HEAD)

/mob/living/carbon/human/update_inv_belt()
	inventory.update_slot_render(SLOT_ID_BELT)

/mob/living/carbon/human/update_inv_wear_suit()
	if(QDESTROYING(src))
		return

	remove_layer(SUIT_LAYER)

	//Hide/show other layers if necessary
	update_inv_w_uniform()
	update_inv_shoes()
	update_tail_showing()
	update_wing_showing()

	if(!wear_suit)
		return //No point, no suit.

	// Part of splitting the suit sprites up

	var/icon/c_mask = null
	var/tail_is_rendered = (overlays_standing[TAIL_LAYER] || overlays_standing[TAIL_LAYER_ALT])
	var/valid_clip_mask = tail_style?.clip_mask

	var/obj/item/clothing/suit/S = wear_suit
	if(tail_is_rendered && valid_clip_mask && !(istype(S) && S.taurized)) //Clip the lower half of the suit off using the tail's clip mask for taurs since taur bodies aren't hidden.
		c_mask = valid_clip_mask
	var/list/MA_or_list = wear_suit.render_mob_appearance(src, SLOT_ID_SUIT, species.get_effective_bodytype(src, wear_suit, SLOT_ID_SUIT))
	if(c_mask)
		if(islist(MA_or_list))
			for(var/mutable_appearance/MA2 as anything in MA_or_list)
				MA2.filters += filter(type = "alpha", icon = c_mask)
		else
			var/mutable_appearance/MA = MA_or_list
			MA.filters += filter(type = "alpha", icon = c_mask)
	overlays_standing[SUIT_LAYER] = MA_or_list

	apply_layer(SUIT_LAYER)

/mob/living/carbon/human/update_inv_wear_mask()
	inventory.update_slot_render(SLOT_ID_MASK)

/mob/living/carbon/human/update_inv_back()
	inventory.update_slot_render(SLOT_ID_BACK)

/mob/living/carbon/human/update_inv_handcuffed()
	inventory.update_slot_render(SLOT_ID_HANDCUFFED)

/mob/living/carbon/human/update_inv_legcuffed()
	inventory.update_slot_render(SLOT_ID_LEGCUFFED)

/mob/living/carbon/human/update_inv_r_hand()
	if(isnull(r_hand))
		remove_standing_overlay(HUMAN_OVERLAY_RHAND)
		return
	set_standing_overlay(
		HUMAN_OVERLAY_RHAND,
		r_hand.render_mob_appearance(src, 2, BODYTYPE_DEFAULT),
	)

/mob/living/carbon/human/update_inv_l_hand()
	if(isnull(l_hand))
		remove_standing_overlay(HUMAN_OVERLAY_LHAND)
		return
	set_standing_overlay(
		HUMAN_OVERLAY_LHAND,
		l_hand.render_mob_appearance(src, 1, BODYTYPE_DEFAULT),
	)
