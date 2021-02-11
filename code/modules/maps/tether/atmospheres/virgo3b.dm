/* this seems to be the turf default atmos, so this must be neutral to prevent forcing atmos conditions on future planets
	i don't know why this was lazily assigned as the default, but these values need to be habitable
*/
/datum/atmosphere/planet/virgo3b 
	base_gases = list(
	/datum/gas/oxygen = 0.22,
	/datum/gas/nitrogen = 0.78
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3
