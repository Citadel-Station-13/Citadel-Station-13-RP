/obj/mecha/combat/durand
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms."
	name = "Durand"
	icon_state = "durand"
	initial_icon = "durand"
	step_in = 4
	dir_in = 1 //Facing North.
	health = 400
	maxhealth = 400
	deflect_chance = 20
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 30000
	infra_luminosity = 8
	force = 40
	wreckage = /obj/effect/decal/mecha_wreckage/durand

	max_hull_equip = 2
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	defence_mode_possible = 1

//This is for the Mech stats / Menu system. To be moved later on.
/obj/mecha/combat/durand/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_defence_mode=1'>Toggle defence mode</a>
						</div>
						</div>
						"}
	output += ..()
	return output
