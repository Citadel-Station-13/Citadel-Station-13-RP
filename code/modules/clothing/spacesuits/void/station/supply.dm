/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_helm", SLOT_ID_LEFT_HAND = "mining_helm")
	armor_type = /datum/armor/cargo/mining/space
	light_overlay = "helmet_light_dual"
	worth_intrinsic = 75

/obj/item/clothing/suit/space/void/mining
	name = "mining voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	icon_state = "rig-mining"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_voidsuit", SLOT_ID_LEFT_HAND = "mining_voidsuit")
	armor_type = /datum/armor/cargo/mining/space
	helmet_type = /obj/item/clothing/head/helmet/space/void/mining
	worth_intrinsic = 250

/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "frontier mining voidsuit helmet"
	desc = "An armored cheap voidsuit helmet. Someone must have through they were pretty cool when they painted a mohawk on it."
	icon_state = "rig0-miningalt"
	armor_type = /datum/armor/cargo/mining/space/armored
	worth_intrinsic = 100

/obj/item/clothing/suit/space/void/mining/alt
	icon_state = "rig-miningalt"
	name = "frontier mining voidsuit"
	desc = "A cheap prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and street cred."
	armor_type = /datum/armor/cargo/mining/space/armored
	helmet_type = /obj/item/clothing/head/helmet/space/void/mining/alt
	worth_intrinsic = 300

/obj/item/clothing/head/helmet/space/void/headofsecurity
	desc = "A customized security voidsuit helmet. Has additional composite armor."
	name = "head of security protosuit helmet"
	icon_state = "hosproto"
	armor_type = /datum/armor/security/hos/space
	camera_networks = list(NETWORK_SEC_HELMETS)
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_HELMET_HEAVY
	weight = ITEM_WEIGHT_VOIDSUIT_HELMET_HEAVY

/obj/item/clothing/suit/space/void/headofsecurity
	desc = "A customized security voidsuit. Has additional composite armor."
	name = "head of security protosuit"
	icon_state = "hosproto_void"
	armor_type = /datum/armor/security/hos/space
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_HEAVY
	weight = ITEM_WEIGHT_VOIDSUIT_HEAVY
	helmet_type = /obj/item/clothing/head/helmet/space/void/headofsecurity
