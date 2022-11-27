
/datum/atmosphere/planet/classp
	base_gases = list(
	/datum/gas/oxygen = 0.23,
	/datum/gas/nitrogen = 0.77
	)
	base_target_pressure = 100.1
	minimum_pressure = 100.1
	maximum_pressure = 100.1
	minimum_temp = 225.3
	maximum_temp = 230.3

/obj/effect/overmap/visitable/sector/class_p
	name = "Frozen Planet"
	desc = "A world shrouded in cold and snow that seems to never let up."
	scanner_desc = @{"[i]Information[/i]: A planet with a very cold atmosphere. Possible life signs detected."}
	icon_state = "globe"
	color = "#3434AA"
	known = FALSE
	in_space = 0
