/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 50
	min_broken_damage = 15
	w_class = WEIGHT_CLASS_SMALL
	body_part_flags = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = TRUE
	damage_force = 3
	throw_force = 6

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
			owner.afflict_paralyze(20 * 5)

/obj/item/organ/external/foot/left

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part_flags = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"
