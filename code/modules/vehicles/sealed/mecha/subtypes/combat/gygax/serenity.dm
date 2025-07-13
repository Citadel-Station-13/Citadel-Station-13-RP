
/obj/vehicle/sealed/mecha/combat/gygax/serenity
	desc = "A lightweight exosuit made from a modified Gygax chassis combined with proprietary VeyMed medical tech. It's faster and sturdier than most medical mechs, but much of the armor plating has been stripped out, leaving it more vulnerable than a regular Gygax."
	name = "Serenity"
	icon_state = "medgax"
	initial_icon = "medgax"
	integrity = 150
	integrity_max = 150
	deflect_chance = 20
	step_in = 2

	occupant_huds = list(
		/datum/atom_hud/data/human/medical,
	)

	damage_absorption = list("brute"=0.9,"fire"=1,"bullet"=0.9,"laser"=0.8,"energy"=0.9,"bomb"=1)
	max_temperature = 20000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity
	max_equip = 3
	step_energy_drain = 8
	cargo_capacity = 2
	max_hull_equip = 1
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	starting_components = list(
		/obj/item/vehicle_component/hull,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/lightweight,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)
