/datum/armor/vehicle/mecha/combat/gygax/serenity
	melee_tier = 3.5
	bullet_tier = 3.5
	laser_tier = 3.5

/obj/vehicle/sealed/mecha/combat/gygax/serenity
	desc = "A lightweight exosuit made from a modified Gygax chassis combined with proprietary VeyMed medical tech. It's faster and sturdier than most medical mechs, but much of the armor plating has been stripped out, leaving it more vulnerable than a regular Gygax."
	name = "Serenity"
	icon_state = "medgax"
	initial_icon = "medgax"
	integrity = 150
	integrity_max = 150

	base_movement_speed = 4.5
	armor_type = /datum/armor/vehicle/combat/gygax
	integrity = 0.75 * /obj/vehicle/sealed/mecha/combat/gygax::integrity
	integrity_max = 0.75 * /obj/vehicle/sealed/mecha/combat/gygax::integrity_max

	comp_armor = /obj/item/vehicle_component/plating/armor/lightweight

	occupant_huds = list(
		/datum/atom_hud/data/human/medical,
	)

	max_temperature = 20000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity
	step_energy_drain = 8
	cargo_capacity = 2

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 1,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
	)
