/obj/vehicle/sealed/mecha/working/ripley/deathripley
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	name = "DEATH-RIPLEY"
	icon_state = "deathripley"
	initial_icon = "deathripley"
	base_movement_speed = 4.5
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/deathripley

	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/tool/orescanner,
		/obj/item/vehicle_module/lazy/legacy/tool/hydraulic_clamp/safety,
	)

/obj/effect/decal/mecha_wreckage/ripley/deathripley
	name = "Death-Ripley wreckage"
	icon_state = "deathripley-broken"
