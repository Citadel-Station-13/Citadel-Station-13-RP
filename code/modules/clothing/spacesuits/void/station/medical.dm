/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm", SLOT_ID_LEFT_HAND = "medical_helm")
	armor_type = /datum/armor/medical/space
	worth_intrinsic = 75

/obj/item/clothing/suit/space/void/medical
	name = "medical voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	icon_state = "rig-medical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit", SLOT_ID_LEFT_HAND = "medical_voidsuit")
	armor_type = /datum/armor/medical/space
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical
	worth_intrinsic = 375

/obj/item/clothing/head/helmet/space/void/medical/emt
	name = "emergency medical response voidsuit helmet"
	icon_state = "rig0-medical_emt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm_emt", SLOT_ID_LEFT_HAND = "medical_helm_emt")

/obj/item/clothing/suit/space/void/medical/emt
	name = "emergency medical response voidsuit"
	icon_state = "rig-medical_emt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit_emt", SLOT_ID_LEFT_HAND = "medical_voidsuit_emt")
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical/emt

/obj/item/clothing/head/helmet/space/void/medical/bio
	name = "biohazard voidsuit helmet"
	desc = "A special helmet that protects against hazardous environments. Has minor radiation shielding."
	icon_state = "rig0-medical_bio"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm_bio", SLOT_ID_LEFT_HAND = "medical_helm_bio")
	armor_type = /datum/armor/medical/space

/obj/item/clothing/suit/space/void/medical/bio
	name = "biohazard voidsuit"
	desc = "A special suit that protects against hazardous, environments. It feels heavier than the standard suit with extra protection around the joints."
	icon_state = "rig-medical_bio"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit_bio", SLOT_ID_LEFT_HAND = "medical_voidsuit_bio")
	armor_type = /datum/armor/medical/space
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical/bio

/obj/item/clothing/head/helmet/space/void/medical/alt
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a sleek blue."
	icon_state = "rig0-medicalalt"
	armor_type = /datum/armor/medical/space
	light_overlay = "helmet_light_dual_blue"
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_HELMET_ULTRALIGHT
	weight = ITEM_WEIGHT_VOIDSUIT_HELMET_ULTRALIGHT

/obj/item/clothing/suit/space/void/medical/alt
	icon_state = "rig-medicalalt"
	name = "streamlined medical voidsuit"
	desc = "A more recent model of Vey-Med voidsuit, exchanging physical protection for fully unencumbered movement and a complete range of motion."
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_ULTRALIGHT
	weight = ITEM_WEIGHT_VOIDSUIT_ULTRALIGHT
	armor_type = /datum/armor/medical/space
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical/alt

/obj/item/clothing/head/helmet/space/void/medical/alt_plated
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, fully biohazard and radiation-shielded voidsuit helmet trimmed in a sleek blue."
	icon_state = "rig0-medicalalt2"
	armor_type = /datum/armor/medical/space/upgraded
	light_overlay = "helmet_light_dual_blue"
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_HELMET_ULTRALIGHT
	weight = ITEM_WEIGHT_VOIDSUIT_HELMET_ULTRALIGHT

/obj/item/clothing/suit/space/void/medical/alt_plated
	icon_state = "rig-medicalalt2"
	name = "plated medical voidsuit"
	desc = "An iteration of an existing Vey-Med voidsuit, allowing full biohazard, radiation and increased close-quarters protection, at the expense of projectile and ranged layers."
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_ULTRALIGHT
	weight = ITEM_WEIGHT_VOIDSUIT_ULTRALIGHT
	armor_type = /datum/armor/medical/space/upgraded
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical/alt_plated
