/obj/item/hardsuit/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A Security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor_type = /datum/armor/hardsuit/hazard
	offline_vision_restriction = 1
	siemens_coefficient= 0.7

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/hazard

/datum/armor/hardsuit/hazard
	melee = 0.3
	melee_tier = 4
	bullet = 0.3
	bullet_tier = 4
	laser = 0.3
	laser_tier = 4
	energy = 0.25
	bomb = 0.6
	bio = 1.0
	rad = 0.5
	fire = 0.7
	acid = 0.7

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
