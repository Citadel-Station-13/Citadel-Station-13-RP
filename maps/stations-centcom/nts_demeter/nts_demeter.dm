//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map/centcom/nts_demeter
	id = "centcom-nts_demeter"
	name = "Centcom - NTS Demeter"
	levels = list(
		/datum/map_level/centcom/nts_demeter,
	)

/datum/map_level/centcom/nts_demeter
	id = "centcom-nts_demeter"
	name = "Rift - Orbital Relay (NTS Demeter)"
	display_id = "nts_demeter"
	display_name = "NSB Atlas Orbital Relay (NTS Demeter)"
	path = "maps/stations-centcom/nts_demeter/nts_demeter.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)
