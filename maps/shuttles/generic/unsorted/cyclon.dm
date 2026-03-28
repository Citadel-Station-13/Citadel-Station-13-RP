DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/cyclon)
	id = "generic-cyclon"
	name = "Cylon-class Vessel"
	display_name = "Cylon-class Vessel"
	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
		overmap_legacy_scan_name = "Cylon-class Vessel";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: Unknown
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"};
		overmap_icon_color = "#292636";
	}

#warn impl

/obj/effect/shuttle_landmark/shuttle_initializer/paper_clipper
/obj/overmap/entity/visitable/ship/landable/paper_clipper
/area/shuttle/paper_clipper
/area/shuttle/paper_clipper/left_wing
/area/shuttle/paper_clipper/right_wing
/area/shuttle/paper_clipper/right_wing/shuttle_hanger
#warn map
