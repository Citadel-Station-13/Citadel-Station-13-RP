/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 50
	min_broken_damage = 15
	w_class = WEIGHT_CLASS_SMALL
	body_part_flags = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = TRUE
	organ_rel_size = 10
	base_miss_chance = 50
	damage_force = 3
	throw_force = 5

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
				// sequentially drop the first left-held-item
				for(var/i in 1 to length(owner.inventory?.held_items) step 2)
					if(isnull(owner.inventory.held_items[i]))
						continue
					owner.drop_held_index(i)
			else if(organ_tag == BP_R_HAND)
				// sequentially drop the first left-right-item
				for(var/i in 2 to length(owner.inventory?.held_items) step 2)
					if(isnull(owner.inventory.held_items[i]))
						continue
					owner.drop_held_index(i)

/obj/item/organ/external/hand/left

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part_flags = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"
