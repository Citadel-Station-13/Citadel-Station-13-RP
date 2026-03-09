DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/scoophead)
	id = "ftu-scoophead"
	name = "Scoophead trade Shuttle"
	desc = "A shuttle linked to the Nebula Gas Station. Its a cargo ship refitted to be a smaller trade ship, easier to land than the Beruang. The Free Trade Union will always deliver."
	display_name = "Scoophead trade Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
		overmap_icon_color = "#ff811a"; //Orange
		overmap_legacy_scan_name = "Scoophead trade Shuttle";
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/scoophead
/area/shuttle/scoophead/cockpit
/area/shuttle/scoophead/main
/area/shuttle/scoophead/engineering
