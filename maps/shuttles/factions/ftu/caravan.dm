DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/caravan)
	id = "ftu-caravan"
	name = "Spacena Caravan Shuttle"
	desc = "A cheap shuttle made for people wanting to live in their shuttle or travel."
	display_name = "Spacena Caravan Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 8500;
		overmap_icon_color = "#8f6f4b"; //Brown
		overmap_legacy_scan_name = "Spacena Caravan Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Caravan Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the FTU, non-hostile
[b]Notice[/b]: Caravan shuttle, cheap, comfy, fragile."};
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/caravan
/area/shuttle/caravan
