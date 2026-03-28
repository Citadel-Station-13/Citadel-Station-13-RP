DECLARE_SECTOR_SHUTTLE_TEMPLATE(/nebula_tradeport, /micro_shuttle)
	id = "sector-nebula_tradeport-micro_shuttle"
	name = "Nebula Utility Micro Shuttle"
	desc = "A shuttle for utility operations around tradeports."
	descriptor = /datum/shuttle_descriptor{
		mass = 2500;
		overmap_icon_color = "#6b6d52";
		overmap_legacy_scan_name = "Utility Micro Shuttle";
	}
	facing_dir = WEST

#warn impl
/obj/overmap/entity/visitable/ship/landable/trade/utilitymicro
/area/shuttle/utilitymicro
#warn map
