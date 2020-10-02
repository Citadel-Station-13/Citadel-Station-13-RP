/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_TORSO
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_HUGE
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"
	organ_rel_size = 70
	base_miss_chance = 10

/obj/item/organ/external/chest/robotize()
	if(..() && robotic != ORGAN_NANOFORM) //VOREStation Edit
		// Give them fancy new organs.
		owner.internal_organs_by_name[O_CELL] = new /obj/item/organ/internal/cell(owner,1)
		owner.internal_organs_by_name[O_VOICE] = new /obj/item/organ/internal/voicebox/robot(owner, 1)

/obj/item/organ/external/chest/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for CHEST
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEMSIZE_LARGE
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = BP_TORSO
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	organ_rel_size = 30

/obj/item/organ/external/groin/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for GROIN
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)

/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 80
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_TORSO
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = 1
	force = 7
	throwforce = 10

/obj/item/organ/external/arm/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for ARM
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			if(organ_tag == BP_L_ARM) //Specific level 2 'feature
				owner.drop_l_hand()
			else if(organ_tag == BP_R_ARM)
				owner.drop_r_hand()

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 80
	min_broken_damage = 30
	w_class = ITEMSIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = 1
	force = 10
	throwforce = 12

/obj/item/organ/external/leg/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for LEG
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.Weaken(5)

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = 1
	force = 3
	throwforce = 6

/obj/item/organ/external/foot/removed()
	if(owner)
		owner.drop_from_inventory(owner.shoes)
	..()

/obj/item/organ/external/foot/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for FOOT
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			owner.Weaken(5)

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 50
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = 1
	organ_rel_size = 10
	base_miss_chance = 50
	force = 3
	throwforce = 5

/obj/item/organ/external/hand/removed()
	if(owner)
		owner.drop_from_inventory(owner.gloves)
	..()

/obj/item/organ/external/hand/handle_germ_effects()
	. = ..() //Should return an infection level
	if(!. || (status & ORGAN_DEAD)) return //If it's already above 2, it's become necrotic and we can just not worry about it.

	//Staph infection symptoms for HAND
	if (. >= 1)
		if(prob(.))
			owner.custom_pain("Your [name] [pick("aches","itches","throbs")]!",0)

	if (. >= 2)
		if(prob(.))
			owner.custom_pain("A jolt of pain surges through your [name]!",1)
			if(organ_tag == BP_L_HAND) //Specific level 2 'feature
				owner.drop_l_hand()
			else if(organ_tag == BP_R_HAND)
				owner.drop_r_hand()

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEMSIZE_NORMAL
	body_part = HEAD
	vital = 1
	parent_organ = BP_TORSO
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	cannot_gib = TRUE
	encased = "skull"
	base_miss_chance = 40
	var/can_intake_reagents = 1
	var/eye_icon = "eyes_s"
	force = 3
	throwforce = 7

	var/eye_icon_location = 'icons/mob/human_face.dmi'

/obj/item/organ/external/head/Initialize()
	if(config_legacy.allow_headgibs)
		cannot_gib = FALSE
	return ..()

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	return ..(company, skip_prosthetics, 1)

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	get_icon()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
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

/obj/item/organ/external/head/skrell
	eye_icon = "skrell_eyes_s"

/obj/item/organ/external/head/teshari
	eye_icon = "eyes_seromi"

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"

// For custom heads with custom parts since the base code is restricted to a single icon file.

/obj/item/organ/external/head/vr/get_icon()

	..()
	overlays.Cut()
	if(!owner || !owner.species)
		return

	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		var/icon/mark_s = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[organ_tag]")
		mark_s.Blend(markings[M]["color"], mark_style.color_blend_mode)
		overlays |= mark_s //So when it's not on your body, it has icons
		mob_icon.Blend(mark_s, ICON_OVERLAY) //So when it's on your body, it has icons
		icon_cache_key += "[M][markings[M]["color"]]"

	if(owner.should_have_organ(O_EYES))//Moved on top of markings.
		var/obj/item/organ/internal/eyes/eyes = owner.internal_organs_by_name[O_EYES]
		if(eye_icon)
			var/icon/eyes_icon = new/icon(eye_icons_vr, eye_icon_vr)
			if(eyes)
				eyes_icon.Blend(rgb(eyes.eye_color[1], eyes.eye_color[2], eyes.eye_color[3]), ICON_ADD)
			else
				eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
			mob_icon.Blend(eyes_icon, ICON_OVERLAY)
			overlays |= eyes_icon

	if(owner.lip_style && (species && (species.appearance_flags & HAS_LIPS)))
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips_[owner.lip_style]_s")
		overlays |= lip_icon
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype(owner) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_coloration)
				facial_s.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)
			overlays |= image(facial_s, "pixel_y" = head_offset)

	if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
		if(hair_style && (species.get_bodytype(owner) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_coloration && islist(h_col) && h_col.len >= 3)
				hair_s.Blend(rgb(h_col[1], h_col[2], h_col[3]), ICON_MULTIPLY)
			overlays |= image(hair_s, "pixel_y" = head_offset)
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
