/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 80
	min_broken_damage = 30
	w_class = WEIGHT_CLASS_NORMAL
	body_part_flags = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = TRUE
	damage_force = 10
	throw_force = 12

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
			owner.afflict_paralyze(20 * 5)

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part_flags = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"
