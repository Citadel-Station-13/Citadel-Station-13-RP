/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_TORSO
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = WEIGHT_CLASS_HUGE
	body_part_flags = UPPER_TORSO
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = TRUE
	cannot_amputate = TRUE
	parent_organ = null
	encased = "ribcage"
	organ_rel_size = 70
	base_miss_chance = 10

/obj/item/organ/external/chest/robotize()
	if(..() && robotic != ORGAN_NANOFORM)
		// Give them fancy new organs.
		owner.internal_organs_by_name[O_CELL] = new /obj/item/organ/internal/cell(owner,1)
		owner.internal_organs_by_name[O_VOICE] = new /obj/item/organ/internal/voicebox/robot(owner, 1)
		owner.internal_organs_by_name[O_PUMP] = new /obj/item/organ/internal/heart/machine(owner,1)
		owner.internal_organs_by_name[O_CYCLER] = new /obj/item/organ/internal/stomach/machine(owner,1)
		owner.internal_organs_by_name[O_HEATSINK] = new /obj/item/organ/internal/robotic/heatsink(owner,1)
		owner.internal_organs_by_name[O_DIAGNOSTIC] = new /obj/item/organ/internal/robotic/diagnostic(owner,1)

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
