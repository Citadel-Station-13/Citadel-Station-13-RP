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

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/storage/excavation,
		/obj/item/pickaxe,
		/obj/item/healthanalyzer,
		/obj/item/measuring_tape,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/pickaxe/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)

/datum/armor/hardsuit/ami
	melee = 0.45
	bullet = 0.2
	laser = 0.45
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
