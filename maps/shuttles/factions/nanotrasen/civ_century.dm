DECLARE_SHUTTLE_TEMPLATE(/nanotrasen/civ_century)
	id = "nanotrasen-civ_century"
	name = "CIV - Century Shuttle"
	display_name = "Century Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 8000;
		preferred_orientation = NORTH;
		overmap_icon_color = "#4cad73";
		overmap_legacy_name = "Century Shuttle";
		overmap_legacy_desc = "Is it... A replica ? Or... the real deal ? This shuttle, based on the shuttles from earth's old days. No teasing, this shuttle is a replica, but still a old and crapy ship.";
	}

#warn map, obliterate
/area/shuttle/oldcentury
