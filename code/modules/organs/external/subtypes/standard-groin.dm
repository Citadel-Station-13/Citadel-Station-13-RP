/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = WEIGHT_CLASS_BULKY
	body_part_flags = LOWER_TORSO
	parent_organ = BP_TORSO
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = TRUE
	cannot_amputate = TRUE
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
