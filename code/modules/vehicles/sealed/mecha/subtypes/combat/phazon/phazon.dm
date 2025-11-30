/datum/armor/vehicle/mecha/combat/phazon
	melee = 0.6
	melee_tier = 3
	bullet = 0.45
	bullet_tier = 4.5
	laser = 0.45
	laser_tier = 5
	energy = 0.5
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/phazon
	name = "Phazon"
	desc = "A sleek exosuit with unnaturally pronounced curves."
	description_fluff = "The Phazon exosuit is the result of a heavily classified Nanotrasen research initiative. Designed to serve as a reconnaissance, infiltration, and flanking mecha, the Phazon possesses an array of complex and expensive phasing and cloaking systems which allow it to change its matter state and move through solid materials. Although initial field tests were positive, the raw cost of manufacturing the Phazon made mass production untenable. Of the few suits deployed during the Phoron War, none are known to have fallen into enemy hands. In spite of this, corporate espionage has lead to various parts and components becoming available on the black market. The actual circuitry and chips necessary to construct the Phazon, however, remain closely guarded corporate secrets. The exosuit's hover capabilities cause it to float roughly a foot off of the ground. Due to this, although the Janus itself comes in at a moderate 9'(2.7m) in height, it effectively takes up 10' to 11'(3m-3.4m) of space when in operation."
	icon_state = "phazon"
	initial_icon = "phazon"

	base_movement_speed = 5
	armor_type = /datum/armor/vehicle/mecha/combat/phazon
	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/alien
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/durable

	dir_in = 1 //Facing North.
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	internal_damage_threshold = 25

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 3,
		VEHICLE_MODULE_SLOT_UTILITY = 6,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/cloak,
	)

	encumbrance_gap = 2

	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE

/obj/effect/decal/mecha_wreckage/phazon
	name = "Phazon wreckage"
	icon_state = "phazon-broken"

/obj/vehicle/sealed/mecha/combat/phazon/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/tool/rcd,
		/obj/item/vehicle_module/lazy/legacy/gravcatapult,
	)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/phazon/old
	desc = "An exosuit which can only be described as 'WTF?'. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/phazon/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 150	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
