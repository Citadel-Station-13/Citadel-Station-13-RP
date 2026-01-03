/obj/vehicle/sealed/mecha/micro/utility/gopher //small digging creature, to keep the theme
	desc = "A tough little utility mech for micro crewmembers, based on a miner borg chassis."
	name = "Gopher"
	icon_state = "gopher"
	initial_icon = "gopher"

	base_movement_speed = 3.75

	dir_in = 2 //Facing south.
	integrity = 100
	max_temperature = 15000
	wreckage = /obj/effect/decal/mecha_wreckage/micro/utility/gopher
	internal_damage_threshold = 35

/obj/effect/decal/mecha_wreckage/micro/utility/gopher
	name = "Gopher wreckage"
	icon_state = "gopher-broken"
