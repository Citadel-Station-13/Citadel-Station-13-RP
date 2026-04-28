DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/beruang)
	id = "ftu-beruang"
	name = "Beruang Trade Ship"
	desc = "You know our motto: 'We deliver!'"
	display_name = "Beruang Trade Ship"

	descriptor = /datum/shuttle_descriptor{
		mass = 15000;
		overmap_icon_color = "#754116"; //Brown
		overmap_legacy_scan_name = "Beruang Trade Ship";
		overmap_legacy_scan_desc = "You know our motto: 'We deliver!'";
	}
	facing_dir = WEST

#warn impl
/obj/overmap/entity/visitable/ship/landable/trade
/area/shuttle/trade_ship/general
/area/shuttle/trade_ship/cockpit
