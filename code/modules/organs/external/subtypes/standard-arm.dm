/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 80
	min_broken_damage = 30
	w_class = WEIGHT_CLASS_NORMAL
	body_part_flags = ARM_LEFT
	parent_organ = BP_TORSO
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = TRUE
	damage_force = 7
	throw_force = 10

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
				owner.drop_held_index(1)
			else if(organ_tag == BP_R_ARM)
				owner.drop_held_index(2)

/obj/item/organ/external/arm/left

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part_flags = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"
