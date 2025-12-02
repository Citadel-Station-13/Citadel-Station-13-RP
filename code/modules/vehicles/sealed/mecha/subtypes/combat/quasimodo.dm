/datum/armor/vehicle/mecha/combat/quasimodo
	melee = 0.35
	melee_tier = 4
	bullet = 0.35
	bullet_tier = 4
	laser = 0.35
	laser_tier = 4
	energy = 0.35
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/quasimodo
	name = "Quasimodo"
	desc = "A massive mech that seems to tower over most people, it has a massive cannon on its shoulder."
	description_fluff = "Created near the end of Nanotrasen’s war with the Syndicate, right before they collapsed, the Quasimodo was designed in collaboration with Hephaestus Industries and Nanotrasen as a response to the growing threat of Cybersun Industries mechs such as the Mauler. This massive mech and its shoulder mounted, weapon mount was made to carry Anti Tank/Anti Building armament, generally too large to fit on any smaller mech. Although it was never used, due to the Syndicate disbanding right before it saw the light, before being promptly shelved. But, the project was picked back up due to consistent requests from SDF members for something larger to deal with the ever growing threats from mercenary companies and pirates getting their hands on their own mechs. But of course, only if they had the money for it. The Quasimodo stands at 36’(11m) tall, its cockpit windows made with phoron reinforced glass, and its hull made with many, many layers of durasteel. Usually paired with the Quasimodo is the Hag-30, 155mm, Anti Tank Cannon, due to the fact it’s usually built with it permanently fixed, but other models do exist that have other weapons. As expected, this mech is designed with ground based, open combat in mind."
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

	base_movement_speed = 1.5
	armor_type = /datum/armor/vehicle/mecha/combat/quasimodo
	integrity = 9 * /obj/vehicle/sealed/mecha/combat::integrity
	integrity_max = 9 * /obj/vehicle/sealed/mecha/combat::integrity_max

	comp_hull_relative_thickness = 5 * /obj/vehicle/sealed/mecha/combat::comp_hull_relative_thickness
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/heavy
	comp_armor_relative_thickness = 5 * /obj/vehicle/sealed/mecha/combat::comp_armor_relative_thickness
	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/heavy

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 0,
	)

	floodlight_range = 12

	wreckage = /obj/effect/decal/mecha_wreckage/quasimodo
	internal_damage_threshold = 25
	zoom_possible = 1

	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/hag_30,
	)

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
