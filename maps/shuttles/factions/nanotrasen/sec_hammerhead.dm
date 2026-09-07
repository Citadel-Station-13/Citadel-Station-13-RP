DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/sec_hammerhead)
	id = "nanotrasen-sec_hammerhead"
	name = "SEC - Hammerhead Patrol Barge"

	descriptor = /datum/shuttle_descriptor{
		preferred_orientation = WEST;
		mass = 10000;
		overmap_icon_color = "#b91a14";
		overmap_legacy_name = "Hammerhead Patrol Barge";
	}

	display_name = "Hammerhead Patrol Barge"
	facing_dir = WEST

#warn below

/obj/overmap/entity/visitable/ship/landable/hammerhead
/area/shuttle/hammerhead

#warn map
