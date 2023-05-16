
/datum/atmosphere/planet/virgo3b
	base_gases = list(
	/datum/gas/nitrogen = 0.16,
	/datum/gas/phoron = 0.72,
	/datum/gas/carbon_dioxide = 0.12
	)
	base_target_pressure = 82.4
	minimum_pressure = 82.4
	maximum_pressure = 82.4
	minimum_temp = 234
	maximum_temp = 234

/obj/effect/overmap/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia, where you can dock and refuel your craft."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	base = 1
	icon_state = "globe"
	color = "#d35b5b"
	initial_generic_waypoints = list(
		"tether_dockarm_d2a", //Top left
		"tether_dockarm_d2b", //Bottom left,
		"tether_dockarm_d2r", //Right,
		"tether_dockarm_d2l", //End of arm,
		"tether_space_SE", //station1, bottom right of space,
		"tether_space_SE", //station1, bottom right of space,
		"tether_space_NE", //station1, top right of space,
		"tether_space_SW", //station2, bottom left of space,
		"tether_excursion_hangar", //Excursion shuttle hangar,
		"tether_medivac_dock", //Medical shuttle dock,
		"tourbus_dock" //Surface large hangar
		)



//Despite not being in the multi-z complex, these levels are part of the overmap sector
/* This should be placed in the map's define files.
/obj/effect/overmap/visitable/sector/virgo3b
	extra_z_levels = list(
		Z_LEVEL_SURFACE_MINE,
		Z_LEVEL_SOLARS,
		Z_LEVEL_PLAINS,
		Z_LEVEL_UNDERDARK
	)

	levels_for_distress = list(
		Z_LEVEL_OFFMAP1,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT,
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_FUELDEPOT,
		Z_LEVEL_CLASS_D
		)
*/
