/obj/mecha/combat/reticent
	name = "Reticent"
	desc = "Designed in response to the H.O.N.K., Reticent models are close combat powerhouses designed to rapidly and quietly ambush slower foes."
	icon_state = "reticent"
	initial_icon = "reticent"
	step_in = 3
	dir_in = 1 //Facing North.
	health = 180
	maxhealth = 180			//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 25
	damage_absorption = list("brute"=1,"fire"=0.75,"bullet"=0.85,"laser"=0.8,"energy"=0.7,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/reticent
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

	stomp_sound = 'sound/effects/suitstep1.ogg'
	swivel_sound = 'sound/effects/suitstep2.ogg'

/obj/mecha/combat/reticent/reticence
	name = "Reticence"
	desc = "The current flagship mecha of Le Rien. The Reticence trades some speed for durability, but remains formidable. It is not commercially available."
	icon_state = "reticence"
	initial_icon = "reticence"
	health = 350
	maxhealth = 350
	deflect_chance = 40
	damage_absorption = list("brute"=0.8,"fire"=0.6,"bullet"=0.5,"laser"=0.65,"energy"=0.6,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/reticent/reticence
	max_equip = 4
	step_energy_drain = 5

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 2

	starting_equipment = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/whisperblade,
		/obj/item/mecha_parts/mecha_equipment/weapon/infernoblade,
		/obj/item/mecha_parts/mecha_equipment/omni_shield/reticence,
		/obj/item/mecha_parts/mecha_equipment/cloak
		)

/obj/mecha/combat/reticent/reticence/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
