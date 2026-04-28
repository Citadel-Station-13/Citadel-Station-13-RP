DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/cruise_ship)
	id = "generic-cruise_ship"
	name = "Cruise Shuttle"
	desc = "A luxury cruise shuttle. Sometimes used by diplomats for speedy transit."
	display_name = "Cruise Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_legacy_scan_name = "Aerondight-class Cruise Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: UNKNOWN
	[i]Class[/i]: Pleasure Yacht
	[i]Transponder[/i]: Transmitting (CIV), UNKNOWN
	[b]Notice[/b]: Potentially diplomatic vessel"};
		overmap_icon_color = "#b4a90a"; //Gold baybeee
	}
	facing_dir = WEST

#warn below
/area/shuttle/cruise_ship
/area/shuttle/cruise_ship/bedroom
/obj/effect/shuttle_landmark/shuttle_initializer/cruise_ship
/obj/overmap/entity/visitable/ship/landable/cruise_ship
