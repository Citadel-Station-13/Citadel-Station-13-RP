/obj/item/clothing/head/helmet/space/void/science
	name = "hazard bypass helmet"
	desc = "A special helmet designed for the immense pressures, heat, cold, and anomlous natures that may be thrown at a scientist."
	icon_state = "phase"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	armor_type = /datum/armor/station/secsuit
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/void/science
	name = "hazard bypass voidsuit"
	desc = "A special helmet designed for the immense pressures, heat, cold, and anomlous natures that may be thrown at a scientist."
	icon_state = "phase"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	armor_type = /datum/armor/station/secsuit
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)
	siemens_coefficient = 0.7
	helmet_type = /obj/item/clothing/head/helmet/space/void/science/phase


