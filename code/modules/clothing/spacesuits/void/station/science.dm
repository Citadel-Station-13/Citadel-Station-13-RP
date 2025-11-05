/obj/item/clothing/head/helmet/space/void/science
	name = "hazard bypass helmet"
	desc = "A special helmet designed for the immense pressures, heat, cold, and anomalous natures that may be thrown at a scientist."
	icon_state = "phase"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	armor_type = /datum/armor/science/phase
	siemens_coefficient = 0.7
	max_heat_protection_temperature = 10000
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	worth_intrinsic = 159
	integrity_flags = INTEGRITY_ACIDPROOF

/obj/item/clothing/suit/space/void/science
	name = "hazard bypass voidsuit"
	desc = "A special suit designed for the immense pressures, heat, cold, and anomalous natures that may be thrown at a scientist."
	icon_state = "phase"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	armor_type = /datum/armor/science/phase
	siemens_coefficient = 0.7
	max_heat_protection_temperature = 10000
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	integrity_flags = INTEGRITY_ACIDPROOF
	encumbrance = 40
	worth_intrinsic = 350
	helmet_type = /obj/item/clothing/head/helmet/space/void/science
