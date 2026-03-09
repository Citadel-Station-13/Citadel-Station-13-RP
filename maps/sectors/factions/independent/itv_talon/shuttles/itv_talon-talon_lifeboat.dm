DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_talon, /talon_lifeboat)
	id = "sector-itv_talon-talon_lifeboat"
	name = "Talon Lifeboat"
	desc = "A tiny engineless lifeboat from the ITV Talon."
	descriptor = /datum/shuttle_descriptor{
		mass = 1000;
		overmap_legacy_scan_name = "ITV Talon Escape Pod";
	}

#warn impl
/obj/overmap/entity/visitable/ship/landable/talon_lifeboat
/obj/effect/shuttle_landmark/shuttle_initializer/talon_lifeboat
/datum/shuttle/autodock/overmap/talon_lifeboat
