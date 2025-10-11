/obj/vehicle/sealed/mecha/combat/quasimodo
	name = "Quasimodo"
	desc = "A massive mech that seems to tower over most people, it has a massive cannon on its shoulder."
	icon = 'icons/mecha/mecha96x96.dmi'
	icon_state = "quasimodo"
	initial_icon = "quasimodo"
	bound_width = 96
	bound_height = 96
	bound_x = 0
	bound_y = 0
	step_in = 10
	integrity = 4500 //Designed to take a lot of hits, but not able to be repaired in combat.
	integrity_max = 4500
	fail_penetration_value = 0.40
	opacity = 0 // Because its a huge ass mech.
	deflect_chance = 50
	damage_absorption = list("brute"=0.9,"fire"=0.3,"bullet"=0.9,"laser"=0.9,"energy"=0.7,"bomb"=0.4) //It's real absorption will come from it's armor + it can take that damage.
	max_temperature = 50000 //Big ass mech can take a lot of heat.
	infra_luminosity = 3
	lights_power = 12 //Big mechs would have large floodlights.
	wreckage = /obj/effect/decal/mecha_wreckage/quasimodo
	add_req_access = 0
	internal_damage_threshold = 25
	force = 100 //Are you really gonna walk up to the giant, slow moving mech and let yourself get punched by it?
	zoom_possible = 1
	max_equip = 5
	max_hull_equip = 0
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 0
	max_special_equip = 1
	max_heavy_weapon_equip = 1

	starting_components = list(
		/obj/item/vehicle_component/hull/heavy_duty,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/heavy_duty,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)



/obj/vehicle/sealed/mecha/combat/quasimodo/Initialize(mapload)
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/ballistic/cannon/hag_30(src) // The default equip for the Quasi.
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/marauder/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

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
	climb_allowed = 1
	anchored = 1 // It's fucking huge. You aren't moving it. <--- Old comment still holds up.
