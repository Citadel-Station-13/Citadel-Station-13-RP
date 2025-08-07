/obj/item/clothing/head/helmet/space/hardsuit/pmc
	light_overlay = "helmet_light_dual"

/datum/armor/hardsuit/pmc
	melee = 0.45
	melee_tier = 4
	bullet = 0.325
	bullet_tier = 4
	laser = 0.35
	laser_tier = 4
	energy = 0.25
	bomb = 0.5
	bio = 1.0
	rad = 0.95
	fire = 0.7
	acid = 0.9

/obj/item/hardsuit/pmc
	name = "PMC hardsuit control module"
	desc = "A suit worn by private military contractors. Armoured and space ready."
	suit_type = "PMC"
	icon_state = "pmc_commandergrey_rig"

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/pmc

	req_access = list(ACCESS_CENTCOM_ERT)
	armor_type = /datum/armor/hardsuit/pmc

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/atmos_analyzer,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/melee/baton,
		/obj/item/gun,
		/obj/item/storage/firstaid,
		/obj/item/reagent_containers/hypospray,
		/obj/item/roller,
		/obj/item/bluespace_radio,
	)

/obj/item/hardsuit/pmc/commander
	name = "PMC-C hardsuit control module"
	desc = "A suit worn by private military contractors. Armoured and space ready."
	suit_type = "PMC commander"
	icon_state = "pmc_commandergrey_rig"

/obj/item/hardsuit/pmc/commander/grey/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/datajack,
		)

/obj/item/hardsuit/pmc/commander/green
	icon_state = "pmc_commandergreen_rig"

/obj/item/hardsuit/pmc/commander/green/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/datajack,
		)

/datum/armor/hardsuit/pmc/engineer
	rad = 1.0

/obj/item/hardsuit/pmc/engineer
	name = "PMC-E suit control module"
	desc = "A suit worn by private military contractors. This one is setup for engineering. Armoured and space ready."
	suit_type = "PMC engineer"
	icon_state = "pmc_engineergrey_rig"
	armor_type = /datum/armor/hardsuit/pmc/engineer
	siemens_coefficient = 0

/obj/item/hardsuit/pmc/engineer/grey/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/device/rcd
		)

/obj/item/hardsuit/pmc/engineer/green
	icon_state = "pmc_engineergreen_rig"

/obj/item/hardsuit/pmc/engineer/green/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/device/rcd
		)

/obj/item/hardsuit/pmc/medical
	name = "PMC-M suit control module"
	desc = "A suit worn by private military contractors. This one is setup for medical. Armoured and space ready."
	suit_type = "PMC medic"
	icon_state = "pmc_medicalgrey_rig"

/obj/item/hardsuit/pmc/medical/grey/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/healthscanner,
		/obj/item/hardsuit_module/chem_dispenser/injector/advanced
		)

/obj/item/hardsuit/pmc/medical/green
	icon_state = "pmc_medicalgreen_rig"

/obj/item/hardsuit/pmc/medical/green/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/device/healthscanner,
		/obj/item/hardsuit_module/chem_dispenser/injector/advanced
		)

/obj/item/hardsuit/pmc/security
	name = "PMC-S suit control module"
	desc = "A suit worn by private military contractors. This one is setup for security. Armoured and space ready."
	suit_type = "PMC security"
	icon_state = "pmc_securitygrey_rig"

/obj/item/hardsuit/pmc/security/grey/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/mounted/egun,
		)

/obj/item/hardsuit/pmc/security/green
	icon_state = "pmc_securitygreen_rig"

/obj/item/hardsuit/pmc/security/green/equipped

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/maneuvering_jets,
		/obj/item/hardsuit_module/mounted/egun,
		)
