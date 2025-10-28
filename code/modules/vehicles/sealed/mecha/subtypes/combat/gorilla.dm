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
	desc = "<b>Blitzkrieg!</b>" //stop using all caps in item descs i will fight you. its redundant with the bold.
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
	force = 60

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

	smoke_possible = 1
	zoom_possible = 1
	thrusters_possible = 1

/obj/vehicle/sealed/mecha/combat/gorilla/equipped
	modules = list(
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/cannon/weak,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/lmg,
	)

/obj/vehicle/sealed/mecha/combat/gorilla/mechstep(direction)
	var/result = step(src,direction)
	playsound(src,"mechstep",40,1)
	return result

/obj/vehicle/sealed/mecha/combat/gorilla/mechturn(direction)
	dir = direction
	playsound(src,"mechstep",40,1)

/obj/vehicle/sealed/mecha/combat/gorilla/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke_reserve]"}
	return output

/obj/vehicle/sealed/mecha/combat/gorilla/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/effect/decal/mecha_wreckage/gorilla
	name = "Gorilla wreckage"
	desc = "... Blitzkrieg?"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrwreck"
	plane = MOB_PLANE
	pixel_x = -16
	anchored = 1 // It's fucking huge. You aren't moving it.
