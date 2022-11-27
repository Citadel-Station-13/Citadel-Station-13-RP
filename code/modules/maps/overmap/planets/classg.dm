/datum/atmosphere/planet/classg
	base_gases = list(
	/datum/gas/oxygen = 10,
	/datum/gas/nitrogen = 10,
	/datum/gas/phoron = 80
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3

/obj/effect/overmap/visitable/sector/mining_planet
	name = "Mineral Rich Planet"
	desc = "A planet filled with valuable minerals. No life signs currently detected on the surface."
	scanner_desc = @{"[i]Information[/i]
Atmopshere: Mix of Oxygen, Nitrogen and Phoron. DANGER
Lifesigns: No immediate life-signs detected."}
	in_space = 0
	icon_state = "globe"
	color = "#8F6E4C"
	initial_generic_waypoints = list("mining_outpost")
