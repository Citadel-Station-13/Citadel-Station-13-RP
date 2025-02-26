/obj/vehicle/sealed/mecha/micro/sec/weasel
	desc = "A light scout exosuit for micro crewmembers, built for fast reconnaisance."
	name = "Weasel"
	icon_state = "weasel"
	initial_icon = "weasel"
	step_in = 1 // zoom zoom
	dir_in = 2 //Facing south.
	integrity = 100
	deflect_chance = 5
	damage_absorption = list("brute"=1,"fire"=1,"bullet"=0.9,"laser"=0.8,"energy"=0.85,"bomb"=1)
	max_temperature = 5000
	wreckage = /obj/effect/decal/mecha_wreckage/micro/sec/weasel
	internal_damage_threshold = 20
	max_equip = 2
	max_micro_utility_equip = 0
	max_micro_weapon_equip = 2

/obj/effect/decal/mecha_wreckage/micro/sec/weasel
	name = "Weasel wreckage"
	icon_state = "weasel-broken"
