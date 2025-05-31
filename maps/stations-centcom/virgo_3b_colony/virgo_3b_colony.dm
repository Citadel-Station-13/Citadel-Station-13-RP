//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map/centcom/virgo_3b_colony
	id = "centcom-virgo_3b_colony"
	name = "Centcom - Virgo 3B Colony"
	levels = list(
		/datum/map_level/centcom/virgo_3b_colony,
	)
	width = 192
	height = 192

/datum/map_level/centcom/virgo_3b_colony
	id = "centcom-virgo_3b_colony"
	name = "Tether - Virgo 3B Colony (Centcom)"
	display_id = "virgo_3b_colony"
	display_name = "Virgo 3B Colony"
	path = "maps/stations-centcom/virgo_3b_colony/virgo_3b_colony.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
