/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	armor_type = /datum/armor/station/secsuit
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SEC_HELMETS)
	worth_intrinsic = 125

/obj/item/clothing/suit/space/void/security
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	icon_state = "rig-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	armor_type = /datum/armor/station/secsuit
	siemens_coefficient = 0.7
	helmet_type = /obj/item/clothing/head/helmet/space/void/security
	worth_intrinsic = 450

/obj/item/clothing/head/helmet/space/void/security/riot
	name = "crowd control voidsuit helmet"
	icon_state = "rig0-sec_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm_riot", SLOT_ID_LEFT_HAND = "sec_helm_riot")

/obj/item/clothing/suit/space/void/security/riot
	name = "crowd control voidsuit"
	icon_state = "rig-sec_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit_riot", SLOT_ID_LEFT_HAND = "sec_voidsuit_riot")
	helmet_type = /obj/item/clothing/head/helmet/space/void/security/riot

//Todo: Both of them being called Riot/CC with one in the suit cycler, and one with actual armor values is really dumb. Seriously.
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "riot security voidsuit helmet"
	desc = "A somewhat tacky voidsuit helmet, a fact mitigated by heavy armor plating."
	icon_state = "rig0-secalt"
	armor_type = /datum/armor/station/secsuitriot

/obj/item/clothing/suit/space/void/security/alt
	icon_state = "rig-secalt"
	name = "riot security voidsuit"
	desc = "A heavily armored voidsuit, designed to intimidate people who find black intimidating. Surprisingly slimming."
	armor_type = /datum/armor/station/secsuitriot
	helmet_type = /obj/item/clothing/head/helmet/space/void/security/alt
