/obj/item/hardsuit/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A Security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor_type = /datum/armor/hardsuit/hazard
	slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = 1
	siemens_coefficient= 0.7

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/hazard

	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/melee/baton,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)
/datum/armor/hardsuit/hazard
	melee = 0.6
	bullet = 0.4
	laser = 0.3
	energy = 0.15
	bomb = 0.6
	bio = 1.0
	rad = 0.3

/obj/item/hardsuit/hazard/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/vision/sechud,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/grenade_launcher,
		/obj/item/hardsuit_module/mounted/taser
		)

/obj/item/clothing/head/helmet/space/hardsuit/hazard
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SECURITY)
