/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = WEIGHT_CLASS_NORMAL
	body_part_flags = HEAD
	parent_organ = BP_TORSO
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = TRUE
	cannot_gib = TRUE
	encased = "skull"
	base_miss_chance = 40
	damage_force = 3
	throw_force = 7

	var/hair_opacity = 255
	var/can_intake_reagents = TRUE
	var/eyes_over_markings = FALSE
	var/eye_icon = "eyes_s"
	var/eye_icon_location = 'icons/mob/human_face.dmi'

/obj/item/organ/external/head/Initialize(mapload)
	if(config_legacy.allow_headgibs)
		cannot_gib = FALSE
	return ..()

/obj/item/organ/external/head/robotize(company, skip_prosthetics, keep_organs, force)
	return ..(company, skip_prosthetics, 1, force)

/obj/item/organ/external/head/removed()
	if(owner)
		if(iscarbon(owner))
			name = "[owner.real_name]'s head"
			owner.update_hair()
	get_icon()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), permutation = 0)
	. = ..()
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for HEAD
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.eye_blurry += 20 //Specific level 2 'feature

/obj/item/organ/external/head/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/toy/plushie) || istype(I, /obj/item/organ/external/head))
		user.visible_message("<span class='notice'>[user] makes \the [I] kiss \the [src]!.</span>", \
		"<span class='notice'>You make \the [I] kiss \the [src]!.</span>")
	return ..()

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"

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
		mark_s.Blend(markings[M]["color"], mark_style.legacy_use_additive_color_matrix? ICON_ADD : ICON_MULTIPLY)
		overlays_to_add.Add(mark_s) //So when it's not on your body, it has icons
		mob_icon.Blend(mark_s, ICON_OVERLAY) //So when it's on your body, it has icons
		icon_cache_key += "[M][markings[M]["color"]]"

	if(owner.should_have_organ(O_EYES))//Moved on top of markings.
		var/obj/item/organ/internal/eyes/eyes = owner.keyed_organs[ORGAN_KEY_EYES]
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

	if(owner.h_style && !(owner.head && (owner.head.inv_hide_flags & BLOCKHEADHAIR)))
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
