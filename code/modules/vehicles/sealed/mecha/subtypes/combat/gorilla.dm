/datum/armor/vehicle/mecha/combat/gorilla
	melee = 0.45
	melee_tier = 4
	bullet = 0.45
	bullet_tier = 4
	laser = 0.45
	laser_tier = 4
	energy = 0.35
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/gorilla
	name = "Gorilla"
	desc = "<b>Blitzkrieg!</b>"
	description_fluff = "Quadrupedal mech designs are considered excessively rare. This chassis feels more like a vehicle than a proper exosuit as a result. Although specs similar to those found in the Gorilla were patened by Hephaestus over a century ago, the company maintains that it had nothing to do with the production of this machine. When its legs are fully extended the Gorilla stands 20'(6.1m) tall, making it nearly impossible to operate at full speed within the cramped confines of a facility or vessel."
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrmech"
	initial_icon = "pzrmech"
	// Multi-tile mechs don't support opacity properly.
	opacity = FALSE
	pixel_x = -16
	integrity = 5000
	integrity_max = 5000

	base_movement_speed = 1.5
	armor_type = /datum/armor/vehicle/mecha/combat/gorilla

	max_temperature = 35000 //Just a bit better than the Durand.
	wreckage = /obj/effect/decal/mecha_wreckage/gorilla
	add_req_access = 0
	internal_damage_threshold = 25

	melee_standard_force = 45
	melee_standard_tier = 5

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/toggled/jetpack/electric,
		/obj/item/vehicle_module/lazy/smokescreen,
	)

	zoom_possible = 1

/obj/vehicle/sealed/mecha/combat/gorilla/equipped
	modules = list(
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/weak,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/lmg,
	)

/obj/effect/decal/mecha_wreckage/gorilla
	name = "Gorilla wreckage"
	desc = "... Blitzkrieg?"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrwreck"
	plane = MOB_PLANE
	pixel_x = -16
	anchored = 1 // It's fucking huge. You aren't moving it.
