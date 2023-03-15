/obj/item/rig/vox	//Just to get the atom_flags set up
	name = "alien control module"
	desc = "This metal box writhes and squirms as if it were alive..."
	suit_type = "alien"
	icon_state = "vox_rig"
	r_armor_type = /datum/armor/rig/vox
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL
	siemens_coefficient = 0.2
	offline_slowdown = 5
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	air_type = /obj/item/tank/vox
	helm_type = /obj/item/clothing/head/helmet/space/rig/vox
	boot_type = /obj/item/clothing/shoes/magboots/rig/vox
	chest_type = /obj/item/clothing/suit/space/rig/vox
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/vox

/datum/armor/rig/vox
	melee = 0.6
	bullet = 0.5
	laser = 0.4
	energy = 0.25
	bomb = 0.3
	bio = 1.0
	rad = 0.5

/obj/item/clothing/head/helmet/space/rig/vox
	species_restricted = list(SPECIES_VOX)
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/shoes/magboots/rig/vox
	name = "talons"
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/suit/space/rig/vox
	species_restricted = list(SPECIES_VOX)

/obj/item/clothing/gloves/gauntlets/rig/vox
	siemens_coefficient = 0
	species_restricted = list(SPECIES_VOX)

/obj/item/rig/vox/carapace
	name = "dense alien control module"
	suit_type = "dense alien"
	emp_protection = 40 //change this to 30 if too high.
	req_access = list(ACCESS_FACTION_SYNDICATE)
	cell_type =  /obj/item/cell/hyper
	initial_modules = list(
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/self_destruct
		)

/obj/item/rig/vox/stealth
	name = "sinister alien control module"
	suit_type = "sinister alien"
	icon_state = "voxstealth_rig"
	emp_protection = 40 //change this to 30 if too high.
	req_access = list(ACCESS_FACTION_SYNDICATE)
	cell_type =  /obj/item/cell/hyper
	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/self_destruct
		)
