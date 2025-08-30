// // // External Organs
/obj/item/organ/external/chest/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 200
	min_broken_damage = 1000
	vital = TRUE
	emp_mod = 7
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/groin/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 100
	min_broken_damage = 1000 //Multiple
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/head/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000 //Inheritance
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/arm/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000 //Please
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/arm/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/leg/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/leg/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/hand/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/hand/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/foot/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

/obj/item/organ/external/foot/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 80
	min_broken_damage = 1000
	vital = FALSE
	emp_mod = 4
	biology_type = BIOLOGY_TYPE_NANITES

// The 'out on the ground' object, not the organ holder
/obj/item/mmi/digital/posibrain/nano
	name = "protean posibrain"
	desc = "A more advanced version of the standard posibrain, typically found in protean bodies."
	icon = 'icons/mob/clothing/species/protean/protean.dmi'
	icon_state = "posi"

/obj/item/mmi/digital/posibrain/nano/Initialize(mapload)
	. = ..()
	icon_state = "posi"

/obj/item/mmi/digital/posibrain/nano/request_player()
	icon_state = initial(icon_state)
	return //We don't do this stuff

/obj/item/mmi/digital/posibrain/nano/reset_search()
	icon_state = initial(icon_state)
	return //Don't do this either because of the above

/obj/item/mmi/digital/posibrain/nano/transfer_personality()
	. = ..()
	icon_state = "posi1"

/obj/item/mmi/digital/posibrain/nano/transfer_identity()
	. = ..()
	icon_state = "posi1"
