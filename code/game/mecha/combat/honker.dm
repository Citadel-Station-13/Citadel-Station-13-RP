/obj/mecha/combat/honker
	name = "H.O.N.K."
	desc = "The H.O.N.K. mecha is sometimes crafted by deranged Roboticists with a grudge, and is illegal in thirty six different sectors."
	icon_state = "honker"
	initial_icon = "honker"
	step_in = 4
	dir_in = 1 //Facing North.
	health = 250
	maxhealth = 250			//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 15
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	internal_damage_threshold = 35
	max_equip = 4

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	starting_components = list(
		/obj/item/mecha_parts/component/hull/durable,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/marshal,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

	overload_possible = 1

	icon_scale_x = 1.35
	icon_scale_y = 1.35

/obj/mecha/combat/honker/cluwne
	name = "C.L.U.W.N.E."
	desc = "The C.L.U.W.N.E. mecha is an up-armored cousin of the H.O.N.K. mech. Still in service on the borders of the Clown Planet, this unit is not typically commercially available."
	icon = 'icons/mecha/mecha_vr.dmi'
	icon_state = "cluwne"
	initial_icon = "cluwne"
	health = 400
	maxhealth = 400
	deflect_chance = 25
	damage_absorption = list("brute"=0.6,"fire"=0.8,"bullet"=0.6,"laser"=0.5,"energy"=0.65,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/honker/cluwne
	max_equip = 4
	step_energy_drain = 5

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 2

	starting_equipment = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/honker,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/banana,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/teleporter
		)

/obj/mecha/combat/honker/cluwne/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
