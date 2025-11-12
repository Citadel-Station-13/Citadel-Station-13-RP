//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map/centcom/ncv_oracle
	id = "centcom-ncv_oracle"
	name = "Centcom - NCV Oracle"
	levels = list(
		/datum/map_level/centcom/ncv_oracle,
	)
	width = 192
	height = 192

/datum/map_level/centcom/ncv_oracle
	id = "centcom-ncv_oracle"
	name = "Endeavour - Flagship (NCV Oracle)"
	display_id = "ncv_oracle"
	display_name = "NCV Oracle"
	path = "maps/stations-centcom/ncv_oracle/ncv_oracle.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
