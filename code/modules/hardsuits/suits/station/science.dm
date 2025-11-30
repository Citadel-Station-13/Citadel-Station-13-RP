/obj/item/hardsuit/hazmat
	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	armor_type = /datum/armor/hardsuit/ami
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	siemens_coefficient= 0.75

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/hazmat

/datum/armor/hardsuit/ami
	melee = 0.3
	melee_tier = 4
	bullet = 0.15
	bullet_tier = 4
	laser = 0.375
	laser_tier = 4.5
	energy = 0.8
	bomb = 0.6
	bio = 1.0
	rad = 0.9

/obj/item/hardsuit/hazmat/equipped
	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/anomaly_scanner,
		/obj/item/hardsuit_module/device/drill,
		)

/obj/item/clothing/head/helmet/space/hardsuit/hazmat
	light_overlay = "hardhat_light"
	camera_networks = list(NETWORK_RESEARCH,NETWORK_COMMAND)
