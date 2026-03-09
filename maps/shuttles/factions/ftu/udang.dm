DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/udang)
	id = "ftu-udang"
	name = "Udang Transport Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to carry passengers. It seems that civilian pilot may also pilot it."
	display_name = "Udang Transport Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#a66d45"; //Orange Brownish
		overmap_legacy_scan_name = "Udang Transport Shuttle";
	}
	facing_dir = EAST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/udang
/area/shuttle/udang/cockpit
/area/shuttle/udang/main
