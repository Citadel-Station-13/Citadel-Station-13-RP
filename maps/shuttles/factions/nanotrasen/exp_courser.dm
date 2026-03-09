DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/courser)
	id = "nanotrasen-courser"
	name = "Courser Scouting Vessel"
	desc = "A small vessel armed with a disperser cannon."
	display_name = "Courser Scouting Vessel"
	descriptor = /datum/shuttle_descriptor{
		mass = 8000;
		overmap_legacy_scan_name = "Courser Scouting Vessel";
		overmap_icon_color = "#af3e97"; //Pinkish Purple
	}
	facing_dir = EAST
#warn impl


/obj/overmap/entity/visitable/ship/landable/courser
/area/shuttle/courser

#warn map
