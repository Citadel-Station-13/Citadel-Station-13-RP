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

	default_access_lookup_keys = list(
		/obj/map_helper/access_helper/auto/generic/staff::lookup_key,
	)
