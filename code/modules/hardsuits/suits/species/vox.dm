/obj/item/hardsuit/vox	//Just to get the atom_flags set up
	name = "alien control module"
	desc = "This metal box writhes and squirms as if it were alive..."
	suit_type = "alien"
	icon_state = "vox_rig"
	armor_type = /datum/armor/hardsuit/vox
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	siemens_coefficient = 0.2
	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/bluespace_radio,
	)
	air_type = /obj/item/tank/vox
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/vox
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/vox
	chest_type = /obj/item/clothing/suit/space/hardsuit/vox
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/vox

/datum/armor/hardsuit/vox
	melee = 0.45
	melee_tier = 4.5
	bullet = 0.4
	bullet_tier = 4.5
	laser = 0.375
	laser_tier = 4.5
	energy = 0.25
	bomb = 0.3
	bio = 1.0
	rad = 0.5

/obj/item/clothing/head/helmet/space/hardsuit/vox
	species_restricted = list(SPECIES_VOX)
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/shoes/magboots/hardsuit/vox
	name = "talons"
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/suit/space/hardsuit/vox
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/gloves/gauntlets/hardsuit/vox
	siemens_coefficient = 0
	species_restricted = list(SPECIES_VOX)

/obj/item/hardsuit/vox/carapace
	name = "dense alien control module"
	suit_type = "dense alien"
	emp_protection = 40 //change this to 30 if too high.
	req_access = list(ACCESS_FACTION_SYNDICATE)
	cell_type =  /obj/item/cell/hyper
	initial_modules = list(
		/obj/item/hardsuit_module/mounted/energy_blade,
		/obj/item/hardsuit_module/sprinter,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/vision,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/self_destruct
		)

/obj/item/hardsuit/vox/stealth
	name = "sinister alien control module"
	suit_type = "sinister alien"
	icon_state = "voxstealth_rig"
	emp_protection = 40 //change this to 30 if too high.
	req_access = list(ACCESS_FACTION_SYNDICATE)
	cell_type =  /obj/item/cell/hyper
	initial_modules = list(
		/obj/item/hardsuit_module/stealth_field,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/vision,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/self_destruct
		)
