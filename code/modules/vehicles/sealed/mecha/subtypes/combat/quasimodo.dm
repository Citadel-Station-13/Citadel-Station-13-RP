/obj/vehicle/sealed/mecha/combat/quasimodo
	name = "Quasimodo"
	desc = "A massive mech that seems to tower over most people, it has a massive cannon on its shoulder."
	icon = 'icons/mecha/mecha96x96.dmi'
	icon_state = "quasimodo"
	initial_icon = "quasimodo"
	// Multi-tile mechs don't support opacity properly.
	opacity = FALSE
	// 3x3
	bound_width = 96
	bound_height = 96
	bound_x = 0
	bound_y = 0

	integrity = 9 * /obj/vehicle/sealed/mecha/combat::integrity
	integrity_max = 9 * /obj/vehicle/sealed/mecha/combat::integrity_max

	base_movement_speed = 1.5

	comp_hull_relative_thickness = 5 * /obj/vehicle/sealed/mecha/combat::comp_hull_relative_thickness
	comp_hull = /obj/item/vehicle_component/plating/hull/heavy_duty
	comp_armor_relative_thickness = 5 * /obj/vehicle/sealed/mecha/combat::comp_armor_relative_thickness
	comp_armor = /obj/item/vehicle_component/plating/armor/heavy_duty

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 0,
	)

	lights_power = 12 //Big mechs would have large floodlights.
	wreckage = /obj/effect/decal/mecha_wreckage/quasimodo
	add_req_access = 0
	internal_damage_threshold = 25
	zoom_possible = 1

	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/hag_30,
	)

/obj/vehicle/sealed/mecha/combat/quasimodo/get_commands()
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
