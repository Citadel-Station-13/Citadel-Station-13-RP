/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	r_armor_type = /datum/armor/rig/medical
	slowdown = 1
	offline_vision_restriction = 1
	siemens_coefficient= 0.75

	helm_type = /obj/item/clothing/head/helmet/space/rig/medical

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/firstaid,
		/obj/item/healthanalyzer,
		/obj/item/storage/backpack,
		/obj/item/stack/medical,
		/obj/item/roller
		)

/datum/armor/rig/medical
	melee = 0.3
	bullet = 0.15
	laser = 0.2
	energy = 0.6
	bomb = 0.3
	bio = 1.0
	rad = 1.0

/obj/item/rig/medical/equipped
	seal_delay = 5
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm,
		/obj/item/rig_module/device/hand_defib
		)

/obj/item/clothing/head/helmet/space/rig/medical
	camera_networks = list(NETWORK_MEDICAL)
