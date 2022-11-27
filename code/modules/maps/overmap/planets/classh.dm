/datum/atmosphere/planet/classh
	base_gases = list(
	/datum/gas/oxygen = 0.24,
	/datum/gas/nitrogen = 0.72,
	/datum/gas/carbon_dioxide = 0.04
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 317.3 //Barely enough to avoid baking Teshari
	maximum_temp = 317.3

/obj/effect/overmap/visitable/sector/class_h
	name = "Desert Planet"
	desc = "Planet readings indicate light atmosphere and high heat."
	scanner_desc = @{"[i]Information[/i]
Atmosphere: Thin
Weather: Sunny, little to no wind
Lifesign: Multiple Fauna and humanoid life-signs detected."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#BA9066"
