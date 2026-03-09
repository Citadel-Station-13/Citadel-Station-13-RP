DECLARE_SECTOR_SHUTTLE_TEMPLATE(/nebula_tradeport, /cargo_tug)
	id = "sector-nebula_tradeport-cargo_tug"
	name = "Cargo Tug Hauler Shuttle"
	desc = "A Shuttle made to tug barge, offering a high ammount of cargo ."
	descriptor = /datum/shuttle_descriptor{
		mass = 13500;
		overmap_icon_color = "#6b6d52";
		overmap_legacy_scan_name = "Cargo Tug Hauler Shuttle";
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/cargotug
/area/shuttle/tug
