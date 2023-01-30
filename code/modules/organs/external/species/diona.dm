/proc/spawn_diona_nymph(turf/target)
	if(!istype(target))
		return FALSE

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = SSplants.seeds["diona"]
	if(!diona)
		return FALSE

	. = TRUE

	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/alien/diona/D = new(target)
		var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
		P.request_player(D, "A diona nymph has split off from its gestalt. ")
		spawn(60)
			if(D)
				if(!D.ckey || !D.client)
					D.death()

/obj/item/organ/external/diona
	name = "tendril"
	cannot_break = TRUE
	amputation_point = "branch"
	joint = "structural ligament"
	dislocated = -1

/obj/item/organ/external/diona/chest
	name = "core trunk"
	organ_tag = BP_TORSO
	icon_name = "torso"
	max_damage = 200
	min_broken_damage = 50
	w_class = ITEMSIZE_HUGE
	body_part = UPPER_TORSO
	vital = TRUE
	cannot_amputate = TRUE
	parent_organ = null

/obj/item/organ/external/diona/groin
	name = "fork"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 50
	w_class = ITEMSIZE_LARGE
	body_part = LOWER_TORSO
	parent_organ = BP_TORSO

/obj/item/organ/external/diona/arm
	name = "left upper tendril"
	organ_tag = BP_L_ARM
	icon_name = "l_arm"
	max_damage = 30
	min_broken_damage = 20
	w_class = ITEMSIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_TORSO
	can_grasp = TRUE

/obj/item/organ/external/diona/arm/right
	name = "right upper tendril"
	organ_tag = BP_R_ARM
	icon_name = "r_arm"
	body_part = ARM_RIGHT

/obj/item/organ/external/diona/leg
	name = "left lower tendril"
	organ_tag = BP_L_LEG
	icon_name = "l_leg"
	max_damage = 30
	min_broken_damage = 20
	w_class = ITEMSIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	can_stand = TRUE

/obj/item/organ/external/diona/leg/right
	name = "right lower tendril"
	organ_tag = BP_R_LEG
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT

/obj/item/organ/external/diona/foot
	name = "left foot"
	organ_tag = BP_L_FOOT
	icon_name = "l_foot"
	max_damage = 25
	min_broken_damage = 10
	w_class = ITEMSIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_R_LEG
	can_stand = TRUE

/obj/item/organ/external/diona/foot/right
	name = "right foot"
	organ_tag = BP_R_FOOT
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/diona/hand
	name = "left grasper"
	organ_tag = BP_L_HAND
	icon_name = "l_hand"
	max_damage = 25
	min_broken_damage = 15
	w_class = ITEMSIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	can_grasp = TRUE

/obj/item/organ/external/diona/hand/right
	name = "right grasper"
	organ_tag = BP_R_HAND
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM

//DIONA ORGANS.
/obj/item/organ/external/diona/removed()
	if(robotic >= ORGAN_ROBOT)
		return ..()
	var/mob/living/carbon/human/H = owner
	..()
	if(!istype(H) || !H.organs || !H.organs.len)
		H.death()
	if(prob(50) && spawn_diona_nymph(get_turf(src)))
		qdel(src)

/obj/item/organ/external/head/no_eyes/diona
	max_damage = 50
	min_broken_damage = 25
	cannot_break = TRUE
	amputation_point = "branch"
	joint = "structural ligament"
	dislocated = -1
	vital = FALSE
	slot_flags = SLOT_BELT
	gendered_icon = FALSE
