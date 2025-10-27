
/obj/item/clothing/head/helmet/space/void/pilot
	desc = "An atmos resistant helmet for space and planet exploration."
	name = "pilot voidsuit helmet"
	icon_state = "rig0_pilot"
	item_state = "pilot_helm"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_helm", SLOT_ID_LEFT_HAND = "atmos_helm")
	armor_type = /datum/armor/exploration/space/pilot
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	worth_intrinsic = 125 // literally an atmos suit

/obj/item/clothing/suit/space/void/pilot
	desc = "An atmos resistant voidsuit for space and planet exploration."
	icon_state = "rig-pilot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_voidsuit", SLOT_ID_LEFT_HAND = "atmos_voidsuit")
	name = "pilot voidsuit"
	armor_type = /datum/armor/exploration/space/pilot
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	helmet_type = /obj/item/clothing/head/helmet/space/void/pilot
	worth_intrinsic = 450 // literally an atmos suit

/obj/item/clothing/head/helmet/space/void/pilot/alt
	icon_state = "rig0_pilot2"
	item_state = "pilot_helm2"

/obj/item/clothing/suit/space/void/pilot/alt
	desc = "An atmos resistant voidsuit for space."
	icon_state = "rig-pilot2"
	item_state = "rig-pilot2"
	helmet_type = /obj/item/clothing/head/helmet/space/void/pilot/alt
