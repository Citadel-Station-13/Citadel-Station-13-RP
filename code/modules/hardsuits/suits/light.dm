/datum/armor/hardsuit/light
	melee = 0.5
	bullet = 0.15
	laser = 0.5
	energy = 0.1
	bomb = 0.25

// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/hardsuit/light
	name = "light suit control module"
	desc = "A lighter, less armoured hardsuit suit."
	icon_state = "ninja_rig"
	suit_type = "light suit"
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/cell)
	armor_type = /datum/armor/hardsuit/light
	emp_protection = 10
	slowdown = 0
	clothing_flags = CLOTHING_THICK_MATERIAL
	offline_slowdown = 0
	offline_vision_restriction = 0

	chest_type = /obj/item/clothing/suit/space/hardsuit/light
	helm_type =  /obj/item/clothing/head/helmet/space/hardsuit/light
	boot_type =  /obj/item/clothing/shoes/magboots/hardsuit/light
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/light
	rigsuit_max_pressure = 5 * ONE_ATMOSPHERE			  // Max pressure the hardsuit protects against when sealed
	rigsuit_min_pressure = 0							  // Min pressure the hardsuit protects against when sealed

/obj/item/clothing/suit/space/hardsuit/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits

/obj/item/clothing/gloves/gauntlets/hardsuit/light
	name = "gloves"

/obj/item/clothing/shoes/magboots/hardsuit/light
	name = "shoes"
	step_volume_mod = 0.8

/obj/item/clothing/head/helmet/space/hardsuit/light
	name = "hood"

/obj/item/hardsuit/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(ACCESS_FACTION_SYNDICATE)

	airtight = 1
	seal_delay = 5 //Being straight out of a cyberpunk space movie has its perks.

	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/light/hacker
	chest_type = /obj/item/clothing/suit/space/hardsuit/light/hacker
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/light/hacker
	boot_type = /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/datajack,
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/voice,
		/obj/item/hardsuit_module/vision,
		)

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/helmet/space/hardsuit/light/hacker
	name = "headgear"
	siemens_coefficient = 0.4
	inv_hide_flags = HIDEEARS

/obj/item/clothing/suit/space/hardsuit/light/hacker
	siemens_coefficient = 0.4

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.4
	step_volume_mod = 0.3 //Special sneaky cyber-soles, for infiltration.
	atom_flags = NOSLIP //They're not magboots, so they're not super good for exterior hull walking, BUT for interior infiltration they'll do swell.

/obj/item/clothing/gloves/gauntlets/hardsuit/light/hacker
	siemens_coefficient = 0

/obj/item/hardsuit/light/ninja
	name = "ominous suit control module"
	suit_type = "ominous"
	desc = "A unique suit of nano-enhanced armor designed for covert operations."
	icon_state = "ninja_rig"
	emp_protection = 40 //change this to 30 if too high.
	slowdown = 0

	chest_type = /obj/item/clothing/suit/space/hardsuit/light/ninja
	glove_type = /obj/item/clothing/gloves/gauntlets/hardsuit/light/ninja
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/light/ninja
	cell_type =  /obj/item/cell/hyper

	req_access = list(ACCESS_FACTION_SYNDICATE)
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/cell,
		/obj/item/storage/backpack,
		/obj/item/bluespace_radio,
	)

	initial_modules = list(
		/obj/item/hardsuit_module/teleporter,
		/obj/item/hardsuit_module/stealth_field,
		/obj/item/hardsuit_module/mounted/energy_blade,
		/obj/item/hardsuit_module/vision,
		/obj/item/hardsuit_module/voice,
		/obj/item/hardsuit_module/fabricator/energy_net,
		/obj/item/hardsuit_module/chem_dispenser/ninja,
		/obj/item/hardsuit_module/grenade_launcher,
		/obj/item/hardsuit_module/ai_container,
		/obj/item/hardsuit_module/power_sink,
		/obj/item/hardsuit_module/datajack,
		/obj/item/hardsuit_module/self_destruct
		)


/obj/item/clothing/gloves/gauntlets/hardsuit/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/hardsuit/light/ninja
	step_volume_mod = 0.25	//Not quite silent, but still damn quiet

/obj/item/clothing/suit/space/hardsuit/light/ninja
	breach_threshold = 38 //comparable to regular hardsuits

/obj/item/hardsuit/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"

	req_access = list(ACCESS_FACTION_SYNDICATE)

	initial_modules = list(
		/obj/item/hardsuit_module/stealth_field,
		/obj/item/hardsuit_module/vision
		)
