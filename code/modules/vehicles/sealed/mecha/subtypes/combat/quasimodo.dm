/obj/vehicle/sealed/mecha/combat/quasimodo
	name = "Quasimodo"
	desc = "This is a test."
	icon = 'icons/mecha/mecha96x96.dmi'
	icon_state = "quasimodo"
	initial_icon = "quasimodo"
	bound_width = 96
	bound_height = 96
	bound_x = 0
	bound_y = 0
	step_in = 10
	integrity = 5000
	integrity_max = 5000
	opacity = 0 // Because its a huge ass mech.
	deflect_chance = 50
	damage_absorption = list("brute"=0.1,"fire"=0.8,"bullet"=0.1,"laser"=0.6,"energy"=0.7,"bomb"=0.7) //values show how much damage will pass through, not how much will be absorbed.
	max_temperature = 50000 //Big ass mech can take a lot of heat.
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/quasimodo
	add_req_access = 0
	internal_damage_threshold = 25
	force = 100 //Are you really gonna walk up to the giant, slow moving mech and let yourself get punched by it?
	max_equip = 5
	max_hull_equip = 5
	max_weapon_equip = 5
	max_utility_equip = 5
	max_universal_equip = 5
	max_special_equip = 2
	max_heavy_weapon_equip = 1
/obj/vehicle/sealed/mecha/combat/quasimodo/Initialize(mapload)
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/ballistic/cannon/hag_30(src) // The default equip for the Quasi.
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/quasimodo
	name = "Quasimodo wreckage"
	desc = "You thought you were invincible. But you guessed wrong. Have fun explaining this to your superiors."
	icon = 'icons/mecha/mecha96x96.dmi'
	icon_state = "quasimodowreck"
	bound_width = 96
	bound_height = 96
	bound_x = 0
	bound_y = 0
	plane = MOB_PLANE
	anchored = 1 // It's fucking huge. You aren't moving it. <--- Old comment still holds up.
