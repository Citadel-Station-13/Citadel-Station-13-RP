DECLARE_SECTOR_SHUTTLE_TEMPLATE(/nebula_tradeport, /vevalia_salvage)
	id = "sector-nebula_tradeport-vevalia_salvage"
	name = "GCSS Vevalia Salvage Shuttle"
	desc = "A small shuttle of Skrell design, refitted for salvage work."
	descriptor = /datum/shuttle_descriptor{
		mass = 13500;
		overmap_icon_color = "#71831f";
		overmap_legacy_scan_name = "GCSS Vevalia Salvage Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: GCSS Vevalia
	[i]Class[/i]: Salvage Shuttle
	[i]Transponder[/i]: Transmitting (CIV), Registered with the Guardian Corporation
	[b]Notice[/b]: A vessel part of a bigger fleet arround the Guardian Corporation Mothership. Here in the sector to do legal salvage. the Guardian Corporation is small, and Neutral to NT."};
	}
	facing_dir = EAST

#warn impl
/obj/overmap/entity/visitable/ship/landable/trade/salvager
/area/shuttle/salvager
