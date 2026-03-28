DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/arrowhead)
	id = "ftu-arrowhead"
	name = "Arrowhead Racing Shuttle"
	desc = "A ex-racing shuttle, part of the VIP suite of the Nebula Motel."
	display_name = "Arrowhead Racing Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#002d75"; //Darkblue
		overmap_legacy_scan_name = "Arrowhead Racing Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile
[b]Notice[/b]: Racing shuttle, winner of the 2542 Voidline gold trophy"};
	}
	facing_dir = WEST

#warn impl
/obj/overmap/entity/visitable/ship/landable/trade/arrowhead
/area/shuttle/arrowhead
