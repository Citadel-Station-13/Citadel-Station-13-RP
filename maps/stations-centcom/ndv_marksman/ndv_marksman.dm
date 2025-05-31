//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map/centcom/ndv_marksman
	id = "centcom-ndv_marksman"
	name = "Centcom - NDV Marksman"
	levels = list(
		/datum/map_level/centcom/ndv_marksman,
	)
	width = 192
	height = 192

/datum/map_level/centcom/ndv_marksman
	id = "centcom-ndv_marksman"
	name = "Strelka - Flagship (NDV Marksman)"
	display_id = "ndv_marksman"
	display_name = "NDV Marksman"
	path = "maps/stations-centcom/ndv_marksman/ndv_marksman.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
