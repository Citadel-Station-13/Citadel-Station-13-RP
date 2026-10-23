//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_talon, /talon_lifeboat)
	id = "sector-itv_talon-talon_lifeboat"
	name = "Talon Lifeboat"
	path = "maps/sectors/factions/independent/itv_talon/shuttles/itv_talon-talon_lifeboat.dmm"
	desc = "A tiny engineless lifeboat from the ITV Talon."
	descriptor = /datum/shuttle_descriptor{
		mass = 1000;
		overmap_legacy_scan_name = "ITV Talon Escape Pod";
	}
