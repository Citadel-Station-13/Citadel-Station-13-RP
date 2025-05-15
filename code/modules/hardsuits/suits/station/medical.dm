/obj/item/hardsuit/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor_type = /datum/armor/hardsuit/medical
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	siemens_coefficient= 0.75

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/medical

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/firstaid,
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/roller,
		/obj/item/bluespace_radio,
	)

/datum/armor/hardsuit/medical
	melee = 0.3
	melee_tier = 3.5
	bullet = 0.15
	bullet_tier = 3.5
	laser = 0.2
	laser_tier = 3.5
	energy = 0.6
	bomb = 0.3
	bio = 1.0
	rad = 1.0
	fire = 0.8
	acid = 0.9

/obj/item/hardsuit/medical/equipped
	seal_delay = 5
	initial_modules = list(
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/healthscanner,
		/obj/item/hardsuit_module/vision/medhud,
		/obj/item/hardsuit_module/sprinter,
		/obj/item/hardsuit_module/chem_dispenser/injector,
		/obj/item/hardsuit_module/pat_module,
		/obj/item/hardsuit_module/rescue_pharm,
		/obj/item/hardsuit_module/device/hand_defib,
		)

/obj/item/clothing/head/helmet/space/hardsuit/medical
	camera_networks = list(NETWORK_MEDICAL)
