/obj/item/clothing/head/helmet/space/hardsuit/ert
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ERT)

/datum/armor/hardsuit/ert
	melee = 0.6
	melee_tier = 4
	bullet = 0.5
	bullet_tier = 4
	laser = 0.5
	laser_tier = 4.5
	energy = 0.15
	bomb = 0.3
	bio = 1.0
	rad = 1.0
	fire = 0.7
	acid = 1.0

/obj/item/hardsuit/ert
	name = "ERT-C hardsuit control module"
	desc = "A suit worn by the commander of an Emergency Response Team. Has blue highlights. Armoured and space ready."
	suit_type = "ERT commander"
	icon_state = "ert_commander_rig"

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/ert

	req_access = list(ACCESS_CENTCOM_ERT)
	siemens_coefficient= 0.5

	armor_type = /datum/armor/hardsuit/ert

/datum/armor/hardsuit/ert/deathsquad
	melee_tier = 5
	bullet_tier = 6
	laser_tier = 6
	bomb = 0.8
	energy = 0.45

/obj/item/hardsuit/ert/assetprotection
	name = "Heavy Asset Protection suit control module"
	desc = "A heavy suit worn by the highest level of Asset Protection, don't mess with the person wearing this. Armoured and space ready."
	suit_type = "heavy asset protection"
	icon_state = "asset_protection_rig"
	armor_type = /datum/armor/hardsuit/ert/deathsquad
	siemens_coefficient= 0.3
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/eva

/obj/item/hardsuit/ert/para
	name = "PARA suit control module"
	desc = "A sleek module decorated with intricate glyphs and alien wards. When worn by a trained agent, the various glyphs faintly glow."
	suit_type = "PMD agent"
	icon_state = "para_ert_rig"
	item_action_name = "Enable RIG Sigils"

	var/anti_magic = FALSE
	var/blessed = FALSE
	var/emp_proof = FALSE
