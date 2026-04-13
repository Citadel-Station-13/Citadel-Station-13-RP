DECLARE_SECTOR_SHUTTLE_TEMPLATE(/nebula_tradeport, /teshari_runabout)
	id = "sector-nebula_tradeport-teshari_runabout"
	name = "Teshari Runabout"
	desc = "A teshari Design... At least the hull is, probably found in a shipyard, after being decommisionned. This shuttle might have been once a scout vessel linked with a other bigger teshari or skrell ship, and as been modified for civilian use."
	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_icon_color = "#aa499b";
		overmap_legacy_scan_name = "Runabout Shuttle";
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/runabout
/area/shuttle/runabout
	name = "Teshari Runabout"
