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
	icon_state = "phazon"
	initial_icon = "phazon"

	base_movement_speed = 5
	armor_type = /datum/armor/vehicle/mecha/combat/phazon
	comp_armor = /obj/item/vehicle_component/plating/armor/alien
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	dir_in = 1 //Facing North.
	step_energy_drain = 3
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	internal_damage_threshold = 25
	force = 15

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

/obj/vehicle/sealed/mecha/combat/phazon/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];phasing=1'><span id="phasing_command">[phasing?"Dis":"En"]able phasing</span></a><br>
						<a href='?src=\ref[src];switch_damtype=1'>Change melee damage type</a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/phazon/old
	desc = "An exosuit which can only be described as 'WTF?'. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/phazon/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 150	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
