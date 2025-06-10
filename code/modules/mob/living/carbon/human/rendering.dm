/mob/living/carbon/human/flatten_standing_overlays()
	. = ..()
	render_spriteacc_ears(TRUE)
	render_spriteacc_facehair(TRUE)
	render_spriteacc_hair(TRUE)
	render_spriteacc_tail(TRUE)
	render_spriteacc_wings(TRUE)
	render_spriteacc_horns(TRUE)
	reapply_standing_overlays()

/mob/living/carbon/human/proc/render_spriteacc_ears(flatten)
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	var/datum/sprite_accessory/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_EARS)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_EARS)
		return
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_ears, g_ears, b_ears),
			rgb(r_ears2, g_ears2, b_ears2),
			rgb(r_ears3, g_ears3, b_ears3),
		),
		HUMAN_LAYER_SPRITEACC_EARS_FRONT,
		HUMAN_LAYER_SPRITEACC_EARS_BEHIND,
		0, // TODO
		null,
		flattened = flatten,
	)
	// todo: this is awful
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
			I.alpha = head_organ.hair_opacity
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset
		I.alpha = head_organ.hair_opacity

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_EARS, rendered)

/mob/living/carbon/human/proc/render_spriteacc_horns(flatten)
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	var/datum/sprite_accessory/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_HORNS)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	if(hiding_horns && rendering.can_be_hidden)
		//! legacy code
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_HORNS)
		return
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_horn, g_horn, b_horn),
			rgb(r_horn2, g_horn2, b_horn2),
			rgb(r_horn3, g_horn3, b_horn3),
		),
		HUMAN_LAYER_SPRITEACC_HORNS_FRONT,
		HUMAN_LAYER_SPRITEACC_HORNS_BEHIND,
		0, // TODO
		null,
		flattened = flatten,
	)
	// todo: this is awful
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
			I.alpha = head_organ.hair_opacity
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset
		I.alpha = head_organ.hair_opacity

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_HORNS, rendered)

/mob/living/carbon/human/proc/render_spriteacc_facehair(flatten)
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & BLOCKHAIR)
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	var/datum/sprite_accessory/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_FACEHAIR)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_FACEHAIR)
		return
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_facial, g_facial, b_facial),
		),
		HUMAN_LAYER_SPRITEACC_FACEHAIR_FRONT,
		HUMAN_LAYER_SPRITEACC_FACEHAIR_BEHIND,
		0, // TODO
		null,
		flattened = flatten,
	)
	var/alpha_to_use = species.species_appearance_flags & HAS_HAIR_ALPHA ? hair_alpha : head_organ.hair_opacity
	// todo: this is awful
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
			I.alpha = alpha_to_use
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset
		I.alpha = alpha_to_use

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_FACEHAIR, rendered)

/mob/living/carbon/human/proc/render_spriteacc_hair(flatten)
	if((head?.inv_hide_flags | wear_mask?.inv_hide_flags) & (BLOCKHEADHAIR | BLOCKHAIR))
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	var/datum/sprite_accessory/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_HAIR)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump())
		remove_standing_overlay(HUMAN_OVERLAY_HAIR)
		return
	// todo: what is this for?
	// if(head && (head.inv_hide_flags & BLOCKHEADHAIR))
	// 	if(!(hair_style.hair_flags & HAIR_VERY_SHORT))
	// 		hair_style = GLOB.legacy_hair_lookup["Short Hair"]
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_hair, g_hair, b_hair),
		),
		HUMAN_LAYER_SPRITEACC_HAIR_FRONT,
		HUMAN_LAYER_SPRITEACC_HAIR_BEHIND,
		0, // TODO
		null,
		flattened = flatten,
	)
	var/alpha_to_use = species.species_appearance_flags & HAS_HAIR_ALPHA ? hair_alpha : head_organ.hair_opacity
	// todo: this is awful
	if(islist(rendered))
		for(var/image/I as anything in rendered)
			I.pixel_y += head_spriteacc_offset
			I.alpha = alpha_to_use
	else
		var/image/I = rendered
		I.pixel_y += head_spriteacc_offset
		I.alpha = alpha_to_use

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_HAIR, rendered)

/mob/living/carbon/human/proc/render_spriteacc_wings(flatten)
	var/datum/sprite_accessory/wing/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_WINGS)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_WINGS)
		return
	if(hiding_wings && rendering.can_be_hidden)
		//! legacy code
		remove_standing_overlay(HUMAN_OVERLAY_WINGS)
		return
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_wing, g_wing, b_wing),
			rgb(r_wing2, g_wing2, b_wing2),
			rgb(r_wing3, g_wing3, b_wing3),
		),
		HUMAN_LAYER_SPRITEACC_WINGS_FRONT,
		HUMAN_LAYER_SPRITEACC_WINGS_BEHIND,
		0, // TODO
		null,
		legacy_wing_variation,
		flattened = flatten,
	)

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_WINGS, rendered)


/mob/living/carbon/human/proc/render_spriteacc_tail(flatten)
	var/datum/sprite_accessory/tail/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_TAIL)
	if(isnull(rendering))
		remove_standing_overlay(HUMAN_OVERLAY_TAIL)
		return
	if(wear_suit?.inv_hide_flags & HIDETAIL)
		remove_standing_overlay(HUMAN_OVERLAY_TAIL)
		return
	if(hiding_tail && rendering.can_be_hidden)
		//! legacy code
		remove_standing_overlay(HUMAN_OVERLAY_TAIL)
		return
	var/rendered = rendering.render(
		src,
		list(
			rgb(r_tail, g_tail, b_tail),
			rgb(r_tail2, g_tail2, b_tail2),
			rgb(r_tail3, g_tail3, b_tail3),
		),
		HUMAN_LAYER_SPRITEACC_TAIL_FRONT,
		HUMAN_LAYER_SPRITEACC_TAIL_BEHIND,
		0, // TODO,
		null,
		legacy_tail_variation,
		flattened = flatten,
	)

	. = rendered
	set_standing_overlay(HUMAN_OVERLAY_TAIL, rendered)

/mob/living/carbon/human/proc/set_wing_variation(variation)
	var/datum/sprite_accessory/wing/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_WINGS)
	if(!rendering?.variations?[variation] && !isnull(variation))
		return
	legacy_wing_variation = variation
	render_spriteacc_wings()

/mob/living/carbon/human/proc/set_tail_variation(variation)
	var/datum/sprite_accessory/tail/rendering = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_TAIL)
	// todo: legacy sihtcode lol
	if(istype(rendering) && rendering.ani_state && variation == SPRITE_ACCESSORY_VARIATION_WAGGING)
	else
		if(!rendering?.variations?[variation] && !isnull(variation))
			return
	legacy_tail_variation = variation
	render_spriteacc_tail()

/mob/living/carbon/proc/get_sprite_accessory(slot)
	return

/mob/living/carbon/human/get_sprite_accessory(slot)
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_TAIL)
			// . = GLOB.sprite_accessory_tails[tail_style]
			. = tail_style
		if(SPRITE_ACCESSORY_SLOT_HAIR)
			. = GLOB.legacy_hair_lookup[h_style]
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
			. = GLOB.legacy_facial_hair_lookup[f_style]
		if(SPRITE_ACCESSORY_SLOT_WINGS)
			// . = GLOB.sprite_accessory_wings[wing_style]
			. = wing_style
		if(SPRITE_ACCESSORY_SLOT_HORNS)
			// . = GLOB.sprite_accessory_ears[horn_style]
			. = horn_style
		if(SPRITE_ACCESSORY_SLOT_EARS)
			// . = GLOB.sprite_accessory_ears[ear_style]
			. = ear_style
	if(slot == SPRITE_ACCESSORY_SLOT_TAIL && !.)
		var/datum/robolimb/limb = isSynthetic()
		if(istype(limb))
			. = limb?.legacy_includes_tail
			if(.)
				//! :skull_emoji:
				//  todo: better defaulting system, this is horrible.
				r_tail = r_skin
				g_tail = g_skin
				b_tail = b_skin

/mob/living/carbon/proc/render_sprite_accessory(slot)
	return

/mob/living/carbon/human/render_sprite_accessory(slot)
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_TAIL)
			render_spriteacc_tail()
		if(SPRITE_ACCESSORY_SLOT_HAIR)
			render_spriteacc_hair()
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
			render_spriteacc_facehair()
		if(SPRITE_ACCESSORY_SLOT_WINGS)
			render_spriteacc_wings()
		if(SPRITE_ACCESSORY_SLOT_HORNS)
			render_spriteacc_horns()
		if(SPRITE_ACCESSORY_SLOT_EARS)
			render_spriteacc_ears()

/mob/living/carbon/proc/set_sprite_accessory_variation(slot, variation)
	return

/mob/living/carbon/human/set_sprite_accessory_variation(slot, variation)
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_HAIR)
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
		if(SPRITE_ACCESSORY_SLOT_HORNS)
		if(SPRITE_ACCESSORY_SLOT_EARS)
		if(SPRITE_ACCESSORY_SLOT_WINGS)
			set_wing_variation(variation)
		if(SPRITE_ACCESSORY_SLOT_TAIL)
			set_tail_variation(variation)

/mob/living/carbon/proc/has_sprite_accessory_variation(slot, variation)
	return

/mob/living/carbon/human/has_sprite_accessory_variation(slot, variation)
	var/datum/sprite_accessory/resolved = get_sprite_accessory(slot)
	if(istype(resolved, /datum/sprite_accessory/tail) && variation == SPRITE_ACCESSORY_VARIATION_WAGGING)
		var/datum/sprite_accessory/tail/tail = resolved
		if(tail.ani_state)
			return TRUE
	return (resolved?.variations?[variation])? TRUE : FALSE

/mob/living/carbon/proc/get_sprite_accessory_variation(slot)
	return

/mob/living/carbon/human/get_sprite_accessory_variation(slot)
	var/datum/sprite_accessory/resolved = get_sprite_accessory(slot)
	var/variation
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_HAIR)
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
		if(SPRITE_ACCESSORY_SLOT_HORNS)
		if(SPRITE_ACCESSORY_SLOT_EARS)
		if(SPRITE_ACCESSORY_SLOT_TAIL)
			variation = legacy_tail_variation
		if(SPRITE_ACCESSORY_SLOT_WINGS)
			variation = legacy_wing_variation
	if(istype(resolved, /datum/sprite_accessory/tail) && variation == SPRITE_ACCESSORY_VARIATION_WAGGING)
		var/datum/sprite_accessory/tail/tail = resolved
		if(tail.ani_state)
			return SPRITE_ACCESSORY_VARIATION_WAGGING
	return (resolved.variations?[variation])? variation : null

//! old code below

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
//You can sort of flick images now with flick_overlay -Aro
/mob/living/carbon/human/proc/animate_tail_once()
	var/datum/sprite_accessory/accessory = get_sprite_accessory(SPRITE_ACCESSORY_SLOT_TAIL)
	var/time = accessory.variation_animation_times?[SPRITE_ACCESSORY_VARIATION_WAGGING] || accessory.variation_animation_time
	if(!set_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, SPRITE_ACCESSORY_VARIATION_WAGGING))
		return
	addtimer(CALLBACK(src, PROC_REF(animate_tail_reset)), time, TIMER_CLIENT_TIME)

/mob/living/carbon/human/proc/toggle_tail_vr(var/setting,var/message = 0)
	if(!has_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, SPRITE_ACCESSORY_VARIATION_WAGGING))
		if(message)
			to_chat(src, "<span class='warning'>You don't have a tail that supports this.</span>")
		return 0

	if(!set_sprite_accessory_variation(
		SPRITE_ACCESSORY_SLOT_TAIL,
		get_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL) == SPRITE_ACCESSORY_VARIATION_WAGGING? null : SPRITE_ACCESSORY_VARIATION_WAGGING,
	))
		return 0
	return 1

/mob/living/carbon/human/proc/animate_tail_start()
	set_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, SPRITE_ACCESSORY_VARIATION_WAGGING)
	// set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_fast()
	set_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, SPRITE_ACCESSORY_VARIATION_WAGGING)
	// set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_reset()
	set_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, null)
	// if(stat != DEAD)
	// 	set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	// else
	// 	set_tail_state("[species.get_tail(src)]_static")
	// 	toggle_tail_vr(FALSE) // So tails stop when someone dies. TODO - Fix this hack ~Leshana

/mob/living/carbon/human/proc/animate_tail_stop()
	set_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_TAIL, null)

/mob/living/carbon/human/proc/toggle_wing_vr(var/setting,var/message = 0)
	if(!has_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_WINGS, SPRITE_ACCESSORY_VARIATION_FLAPPING))
		if(message)
			to_chat(src, "<span class='warning'>You don't have wings that support this.</span>")
		return 0
	if(!set_sprite_accessory_variation(
		SPRITE_ACCESSORY_SLOT_WINGS,
		get_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_WINGS) == SPRITE_ACCESSORY_VARIATION_FLAPPING? null : SPRITE_ACCESSORY_VARIATION_FLAPPING,
	))
		return 0
	return 1

/mob/living/carbon/human/proc/toggle_wing_spread(var/folded,var/message = 0)
	if(!has_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_WINGS, SPRITE_ACCESSORY_VARIATION_SPREAD))
		if(message)
			to_chat(src, "<span class='warning'>You don't have wings!</span>")
		return 0
	if(!set_sprite_accessory_variation(
		SPRITE_ACCESSORY_SLOT_WINGS,
		get_sprite_accessory_variation(SPRITE_ACCESSORY_SLOT_WINGS) == SPRITE_ACCESSORY_VARIATION_SPREAD? null : SPRITE_ACCESSORY_VARIATION_SPREAD,
	))
		return 0
	return 1

//? FUCK FUCK FUCK FUCK FUCK-

/mob/living/carbon/human/update_hair()
	update_eyes() //Pirated out of here, for glowing eyes.

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(istype(head_organ,/obj/item/organ/external/head/vr))
		var/obj/item/organ/external/head/vr/head_organ_vr = head_organ
		head_spriteacc_offset = head_organ_vr.head_offset
	else
		head_spriteacc_offset = 0

	render_spriteacc_ears()
	render_spriteacc_horns()
	render_spriteacc_hair()
	render_spriteacc_facehair()

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
				var/list/tone = rgb2num(hulk_color_mod)
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

	var/image/img = image(stand_icon, layer = HUMAN_LAYER_BODY)
	if(species.species_appearance_flags & HAS_BODY_ALPHA)
		img.alpha = body_alpha
	set_standing_overlay(HUMAN_OVERLAY_BODY, img)

	//tail
	render_spriteacc_tail()
	//wing
	render_spriteacc_wings()

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

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear()
	if(!(species.species_appearance_flags & HAS_UNDERWEAR))
		remove_standing_overlay(HUMAN_OVERLAY_UNDERWEAR)
		return
	var/list/setting = list()
	// SHITCODE WARNING
	// MANUAL UNDERWEAR SORT
	for(var/key in list(
		"Underwear, bottom",
		"Socks",
		"Underwear, top",
		"Undershirt",
	))
		var/existing = all_underwear[key]
		all_underwear -= key
		if(existing)
			all_underwear[key] = existing
	// END

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
	inventory.update_slot_render(SLOT_ID_UNIFORM)

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
	inventory.update_slot_render(SLOT_ID_SUIT)

/mob/living/carbon/human/update_inv_wear_mask()
	inventory.update_slot_render(SLOT_ID_MASK)

/mob/living/carbon/human/update_inv_back()
	inventory.update_slot_render(SLOT_ID_BACK)

/mob/living/carbon/human/update_inv_handcuffed()
	inventory.on_handcuffed_update()
	inventory.update_slot_render(SLOT_ID_HANDCUFFED)

/mob/living/carbon/human/update_inv_legcuffed()
	inventory.update_slot_render(SLOT_ID_LEGCUFFED)

/mob/living/carbon/human/update_inv_hand(index)
	if(isnull(inventory.held_items[index]))
		remove_standing_overlay(HUMAN_OVERLAY_HAND(index))
		return
	set_standing_overlay(
		HUMAN_OVERLAY_HAND(index),
		inventory.held_items[index].render_mob_appearance(src, index, BODYTYPE_DEFAULT),
	)
