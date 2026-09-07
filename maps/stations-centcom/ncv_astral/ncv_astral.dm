//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map/centcom/ncv_astral
	id = "centcom-ncv_astral"
	name = "NCV Astral"
	levels = list(
		/datum/map_level/centcom/ncv_astral,
	)
	width = 192
	height = 192

/datum/map_level/centcom/ncv_astral
	id = "centcom-ncv_astral"
	name = "Strelka - Flagship (NCV Astral)"
	display_id = "ncv_astral"
	display_name = "NCV Astral"
	path = "maps/stations-centcom/ncv_astral/ncv_astral.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_TRANSIT,
	)

/obj/overmap/entity/visitable/sector/ncv_astral
	name = "NCV Astral"
	desc = "The NCV Astral is a Nanotrasen Command vessel, and the acting Centcom of the expedition fleet."
	scanner_desc = @{"[i]Information[/i]: The NCV Astral is a Nanotrasen Command vessel, and the acting Centcom of the expedition fleet."}
	in_space = 1
	known = TRUE
	icon = 'icons/modules/overmap/tiled.dmi'
	icon_state = "fleet"
	color = "#ccc014"

	initial_restricted_waypoints = list(
		"NDV Quicksilver" = list("specops_hangar")
		)
