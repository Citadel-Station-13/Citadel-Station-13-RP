/obj/item/clothing/suit/bio_suit/anomaly
	name = "Anomaly suit"
	desc = "A sealed bio suit capable of insulating against exotic alien energies."
	icon = 'icons/obj/clothing/spacesuits.dmi'
	icon_state = "engspace_suit"
	item_state = "engspace_suit"
	armor_type = /datum/armor/general/biosuit/anomaly
	max_pressure_protection = 5   * ONE_ATMOSPHERE // Not very good protection, but if an anomaly starts doing gas stuff you're not screwed
	min_pressure_protection = 0.4 * ONE_ATMOSPHERE
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_ANOMALY
	weight = ITEM_WEIGHT_ARMOR_ANOMALY
	worth_intrinsic = 75

/obj/item/clothing/head/bio_hood/anomaly
	name = "Anomaly hood"
	desc = "A sealed bio hood capable of insulating against exotic alien energies."
	icon_state = "engspace_helmet"
	item_state = "engspace_helmet"
	armor_type = /datum/armor/general/biosuit/anomaly
	max_pressure_protection = 5   * ONE_ATMOSPHERE // Not very good protection, but if an anomaly starts doing gas stuff you're not screwed
	min_pressure_protection = 0.4 * ONE_ATMOSPHERE
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_ANOMALY_HELMET
	weight = ITEM_WEIGHT_ARMOR_ANOMALY_HELMET
	worth_intrinsic = 375

/obj/item/clothing/suit/space/anomaly
	name = "Excavation suit"
	desc = "A pressure resistant excavation suit partially capable of insulating against exotic alien energies."
	icon_state = "cespace_suit"
	item_state = "cespace_suit"
	armor_type = /datum/armor/general/biosuit/anomaly
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_ANOMALY
	weight = ITEM_WEIGHT_VOIDSUIT_ANOMALY
	// Pressure protection inherited from space suits
	worth_intrinsic = 450

/obj/item/clothing/head/helmet/space/anomaly
	name = "Excavation hood"
	desc = "A pressure resistant excavation hood partially capable of insulating against exotic alien energies."
	icon_state = "cespace_helmet"
	item_state = "cespace_helmet"
	armor_type = /datum/armor/general/biosuit/anomaly
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_ANOMALY_HELMET
	weight = ITEM_WEIGHT_VOIDSUIT_ANOMALY_HELMET
	worth_intrinsic = 100
