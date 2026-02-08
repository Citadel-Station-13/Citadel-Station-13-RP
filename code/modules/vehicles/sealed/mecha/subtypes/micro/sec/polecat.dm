/obj/vehicle/sealed/mecha/micro/sec/polecat //figured give 'em the names of small predatory critters
	desc = "A hardened security vehicle for micro crewmembers. To them, it's a superheavy tank. To everyone else, it's kinda cute."
	name = "Polecat"
	icon_state = "polecat"
	initial_icon = "polecat"

	base_movement_speed = 4

	dir_in = 2 //Facing south.
	max_temperature = 15000
	wreckage = /obj/effect/decal/mecha_wreckage/micro/sec/polecat
	internal_damage_threshold = 35

/obj/effect/decal/mecha_wreckage/micro/sec/polecat
	name = "Polecat wreckage"
	icon_state = "polecat-broken"
