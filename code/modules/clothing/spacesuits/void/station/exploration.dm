/obj/item/clothing/head/helmet/space/void/exploration
	name = "exploration voidsuit helmet"
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_explorer"
	item_state = "helm_explorer"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-black", SLOT_ID_LEFT_HAND = "syndicate-helm-black")
	armor_type = /datum/armor/exploration/space
	light_overlay = "helmet_light_dual" //explorer_light
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	worth_intrinsic = 75

/obj/item/clothing/suit/space/void/exploration
	name = "exploration voidsuit"
	desc = "A lightweight, radiation-resistant voidsuit, featuring the Explorer emblem on its chest plate. Designed for exploring unknown planetary environments."
	icon_state = "void_explorer"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_black", SLOT_ID_LEFT_HAND = "skrell_suit_black")
	armor_type = /datum/armor/exploration/space
	helmet_type = /obj/item/clothing/head/helmet/space/void/exploration
	worth_intrinsic = 300

/obj/item/clothing/head/helmet/space/void/exploration/alt
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_explorer2"
	item_state = "helm_explorer2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_helm", SLOT_ID_LEFT_HAND = "mining_helm")

/obj/item/clothing/suit/space/void/exploration/alt
	desc = "A lightweight, radiation-resistant voidsuit. Designed for exploring unknown planetary environments."
	icon_state = "void_explorer2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_white", SLOT_ID_LEFT_HAND = "skrell_suit_white")
	helmet_type = /obj/item/clothing/head/helmet/space/void/exploration/alt

/obj/item/clothing/head/helmet/space/void/exploration/med
	name = "field medic voidsuit helmet"
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_exp_medic"
	item_state = "helm_exp_medic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-black", SLOT_ID_LEFT_HAND = "syndicate-helm-black")
	armor_type = /datum/armor/exploration/space
	light_overlay = "helmet_light"
	camera_networks = list(NETWORK_EXPLO_HELMETS)

/obj/item/clothing/suit/space/void/exploration/med
	name = "field medic voidsuit"
	desc = "A lightweight, radiation-resistant voidsuit, featuring the Medical emblem on its chest plate. Designed for exploring unknown planetary environments."
	icon_state = "void_exp_medic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_black", SLOT_ID_LEFT_HAND = "skrell_suit_black")
	helmet_type = /obj/item/clothing/head/helmet/space/void/exploration

/obj/item/clothing/head/helmet/space/void/exploration/pathfinder
	name = "pathfinder voidsuit helmet"
	desc = "A comfortable helmet designed to provide protection for Pathfinder units on long-term operations."
	icon_state = "helm_explorer_pf"
	item_state = "helm_explorer_pf"
	armor_type = /datum/armor/exploration/space/pathfinder
	worth_intrinsic = 100

/obj/item/clothing/suit/space/void/exploration/pathfinder
	name = "pathfinder voidsuit"
	desc = "A versatile, armored voidsuit, featuring the Pathfinder emblem on its chest plate. Designed for long deployments in unknown planetary environments."
	icon_state = "void_explorer_pf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_black", SLOT_ID_LEFT_HAND = "skrell_suit_black")
	armor_type = /datum/armor/exploration/space/pathfinder
	helmet_type = /obj/item/clothing/head/helmet/space/void/exploration/pathfinder
	worth_intrinsic = 400
