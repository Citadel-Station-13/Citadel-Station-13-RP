/datum/armor/vehicle/mecha/combat/durand
	melee = 0.45
	melee_tier = 4
	bullet = 0.45
	bullet_tier = 4
	laser = 0.45
	laser_tier = 4
	energy = 0.35
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/durand
	name = "Durand"
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms."
	description_fluff = {"
		The Durand is an aging combat exosuit designed during the Rye-Egress War.
		Once considered the most durable exosuit ever developed by Humanity, this platform has long since lost that title.
		In spite of its age, the Durand remains one of the most well built and armored exosuits on the market.
		Standing at a towering 12'(3.5m), the exosuit boasts depleted uranium armor paneling and a
		robust electrical harness capable of powering some of the most fearsome weaponry still in use today.
		Although modern militaries - both Galactic and Corporate - have since moved on to more contemporary models,
		the Durand continues to see usage with smaller mercenary bands and SysDef elements.
	"}
	icon_state = "durand"
	initial_icon = "durand"

	armor_type = /datum/armor/vehicle/mecha/combat/durand
	integrity = 1.25 * /obj/vehicle/sealed/mecha/combat::integrity
	integrity_max = 1.25 * /obj/vehicle/sealed/mecha/combat::integrity_max
	base_movement_speed = 2.5

	comp_hull_relative_thickness = 1.5 * /obj/vehicle/sealed/mecha/combat::comp_hull_relative_thickness
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/durable
	comp_armor_relative_thickness = 1.5 * /obj/vehicle/sealed/mecha/combat::comp_armor_relative_thickness
	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/military

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/personal_shield/deflector/durand,
	)

	dir_in = 1 //Facing North.
	max_temperature = 30000
	wreckage = /obj/effect/decal/mecha_wreckage/durand

	melee_standard_force = 40

	icon_scale_x = 1.5
	icon_scale_y = 1.5

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/durand/old
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/durand/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 250	//Just slightly worse.
	power_cell.charge = rand(0, (power_cell.charge/2))
