/obj/vehicle/sealed/mecha/combat/gygax
	name = "Gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	description_fluff = "The Gygax is a relatively modern exosuit designed for agility and speed without sacrificing durability. These traits have made the Gygax fairly popular among well funded private and corporate security forces. The Gygax features a bespoke actuator assembly that grants the exosuit short-term bursts of unparalleled speed. Consequently, the strain this assembly puts on the exosuit causes damage the unit's structural integrity. In spite of the drawbacks, this feature is frequently utilized by those who require the ability to rapidly respond to conflict. 10'(3m) tall and rotund, the Gygax's cockpit is fully enclosed and protected by the design's diamond-weave armor plating."
	icon_state = "gygax_adv"
	initial_icon = "gygax_adv"

	base_movement_speed = 4.25
	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/lightweight

	dir_in = 1 //Facing North.
	integrity = 250
	integrity_max = 250			//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 15
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/adv
	internal_damage_threshold = 35

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 2,
	)

	overload_possible = 1

	icon_scale_x = 1.35
	icon_scale_y = 1.35

//Not quite sure how to move those yet.
/obj/vehicle/sealed/mecha/combat/gygax/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_leg_overload=1'>Toggle leg actuators overload</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/vehicle/sealed/mecha/combat/gygax/dark
	desc = "A lightweight exosuit used by paramilitary forces. A significantly upgraded Gygax security mech."
	name = "Dark Gygax"
	integrity = 400
	integrity_max = 400
	icon_state = "darkgygax_adv"
	initial_icon = "darkgygax_adv"
	deflect_chance = 25
	damage_absorption = list("brute"=0.6,"fire"=0.8,"bullet"=0.6,"laser"=0.5,"energy"=0.65,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark_adv
	max_equip = 4
	step_energy_drain = 5
	mech_faction = MECH_FACTION_SYNDI

	max_hull_equip = 1
	max_weapon_equip = 2
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 2

/obj/vehicle/sealed/mecha/combat/gygax/dark/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/vehicle/sealed/mecha/combat/gygax/dark/equipped
	modules = list(
		/obj/item/vehicle_module/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/legacy/weapon/ballistic/missile_rack/grenade/clusterbang,
		/obj/item/vehicle_module/legacy/tesla_energy_relay,
		/obj/item/vehicle_module/legacy/teleporter,
	)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/gygax/old
	desc = "A lightweight, security exosuit. Popular among private and corporate security. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/gygax/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 250	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
