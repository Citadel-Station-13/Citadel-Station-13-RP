/datum/armor/hardsuit/light
	melee = 0.4
	melee_tier = 3.5
	bullet = 0.3
	bullet_tier = 3
	laser = 0.5
	laser_tier = 3
	energy = 0.25
	bomb = 0.35
	rad = 0.5
	fire = 0.7
	acid = 0.7

/obj/item/hardsuit/light
	name = "light suit control module"
	desc = "A lighter, less armoured hardsuit suit."
	icon_state = "ninja_rig"
	armor_type = /datum/armor/hardsuit/light
	encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT
	offline_encumbrance = ITEM_ENCUMBRANCE_LEGACY_RIG_LIGHT * 2
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	offline_vision_restriction = 0

/obj/item/hardsuit/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(ACCESS_FACTION_SYNDICATE)

	airtight = 1
	seal_delay = 5 //Being straight out of a cyberpunk space movie has its perks.

	initial_modules = list(
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/basic/datajack,
		/obj/item/rig_module/basic/electrowarfare_suite,
		/obj/item/rig_module/basic/voice,
		/obj/item/rig_module/basic/vision,
		)

/obj/item/hardsuit/light/ninja
	name = "ominous suit control module"
	suit_type = "ominous"
	desc = "A unique suit of nano-enhanced armor designed for covert operations."
	icon_state = "ninja_rig"

	initial_modules = list(
		/obj/item/rig_module/basic/teleporter,
		/obj/item/rig_module/basic/stealth_field,
		/obj/item/rig_module/basic/mounted/energy_blade,
		/obj/item/rig_module/basic/vision,
		/obj/item/rig_module/basic/voice,
		/obj/item/rig_module/basic/fabricator/energy_net,
		/obj/item/rig_module/basic/chem_dispenser/ninja,
		/obj/item/rig_module/basic/grenade_launcher,
		/obj/item/rig_module/basic/ai_container,
		/obj/item/rig_module/basic/power_sink,
		/obj/item/rig_module/basic/datajack,
		/obj/item/rig_module/basic/self_destruct
		)

/obj/item/hardsuit/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"

	req_access = list(ACCESS_FACTION_SYNDICATE)

	initial_modules = list(
		/obj/item/rig_module/basic/stealth_field,
		/obj/item/rig_module/basic/vision
		)
