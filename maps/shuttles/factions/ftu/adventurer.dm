DECLARE_SHUTTLE_TEMPLATE(/factions/ftu/adventurer)
	id = "ftu-adventurer"
	name = "Spacena Adventurer Shuttle"
	desc = "A cheap shuttle, variant of the Spacena Caravan, made for more versatile use."
	display_name = "Spacena Adventurer Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 8500;
		overmap_icon_color = "#323f55"; //Blue grey
		overmap_legacy_scan_name = "Spacena Adventurer Shuttle";
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/adventurer
/area/shuttle/adventurer
