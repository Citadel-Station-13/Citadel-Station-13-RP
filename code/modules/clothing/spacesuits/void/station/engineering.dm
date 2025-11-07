/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm", SLOT_ID_LEFT_HAND = "eng_helm")
	armor_type = /datum/armor/engineering/space
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	worth_intrinsic = 75

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "rig-engineering"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit", SLOT_ID_LEFT_HAND = "eng_voidsuit")
	armor_type = /datum/armor/engineering/space
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering
	worth_intrinsic = 325

/obj/item/clothing/head/helmet/space/void/engineering/hazmat
	name = "HAZMAT voidsuit helmet"
	desc = "A engineering helmet designed for work in a low-pressure environment. Extra radiation shielding appears to have been installed at the price of comfort."
	icon_state = "rig0-engineering_rad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm_rad", SLOT_ID_LEFT_HAND = "eng_helm_rad")
	armor_type = /datum/armor/engineering/space/hazmat

/obj/item/clothing/suit/space/void/engineering/hazmat
	name = "HAZMAT voidsuit"
	desc = "A engineering voidsuit that protects against hazardous, low pressure environments. Has enhanced radiation shielding compared to regular engineering voidsuits."
	icon_state = "rig-engineering_rad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit_rad", SLOT_ID_LEFT_HAND = "eng_voidsuit_rad")
	armor_type = /datum/armor/engineering/space/hazmat
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/hazmat

/obj/item/clothing/head/helmet/space/void/engineering/construction
	name = "construction voidsuit helmet"
	icon_state = "rig0-engineering_con"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm_con", SLOT_ID_LEFT_HAND = "eng_helm_con")

/obj/item/clothing/suit/space/void/engineering/construction
	name = "construction voidsuit"
	icon_state = "rig-engineering_con"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit_con", SLOT_ID_LEFT_HAND = "eng_voidsuit_con")
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/construction

/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon_state = "rig0-engineeringalt"
	armor_type = /datum/armor/engineering/space/heavy
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon_state = "rig-engineeringalt"
	armor_type = /datum/armor/engineering/space/heavy
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/alt

/obj/item/clothing/head/helmet/space/void/engineering/salvage
	name = "salvage voidsuit helmet"
	desc = "A heavily modified salvage voidsuit helmet. It has been fitted with radiation-resistant plating."
	icon_state = "rig0-salvage"
	item_state_slots = list(
		SLOT_ID_LEFT_HAND = "eng_helm",
		SLOT_ID_RIGHT_HAND = "eng_helm",
		)
	armor_type = /datum/armor/engineering/space/salvage

/obj/item/clothing/suit/space/void/engineering/salvage
	name = "salvage voidsuit"
	desc = "A hand-me-down salvage voidsuit. It has obviously had a lot of repair work done to its radiation shielding."
	icon_state = "rig-engineeringsav"
	armor_type = /datum/armor/engineering/space/salvage
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/salvage

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon_state = "rig0-atmos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_helm", SLOT_ID_LEFT_HAND = "atmos_helm")
	armor_type = /datum/armor/engineering/space/atmos
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	worth_intrinsic = 125

/obj/item/clothing/suit/space/void/atmos
	name = "atmos voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon_state = "rig-atmos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_voidsuit", SLOT_ID_LEFT_HAND = "atmos_voidsuit")
	armor_type = /datum/armor/engineering/space/atmos
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	helmet_type = /obj/item/clothing/head/helmet/space/void/atmos
	worth_intrinsic = 450

//Atmospherics Surplus Voidsuit

/obj/item/clothing/head/helmet/space/void/atmos/alt
	desc = "A special voidsuit helmet designed for work in hazardous, low pressure environments.This one has been plated with an expensive heat and radiation resistant ceramic."
	name = "heavy duty atmospherics voidsuit helmet"
	icon_state = "rig0-atmosalt"
	armor_type = /datum/armor/engineering/space/atmos/heavy
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/atmos/alt
	desc = "A special suit that protects against hazardous, low pressure environments. Fits better than the standard atmospheric voidsuit while still rated to withstand extreme heat and even minor radiation."
	icon_state = "rig-atmosalt"
	name = "heavy duty atmos voidsuit"
	armor_type = /datum/armor/engineering/space/atmos/heavy
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	helmet_type = /obj/item/clothing/head/helmet/space/void/atmos/alt
