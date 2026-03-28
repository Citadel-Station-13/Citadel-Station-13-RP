DECLARE_STATION_SHUTTLE_TEMPLATE(/strelka, /micro_shuttle)
	id = "strelka-micro_shuttle"
	name = "NEV Strelka Personal Shuttle"
	desc = "A small shuttle used for short range transport to and from the NEV Strelka."
	display_name = "Personal Micro Shuttle"
	descriptor = /datum/shuttle_descriptor{
		mass = 1000;
		overmap_icon_color = "#78cf56";
		overmap_legacy_name = "Strelka Personal Transport";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
	[i]Class[/i]: 2550 Personal Civilian Shuttle
	[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
	[b]Notice[/b]: The shuttle is assigned to the NEV Strelka"};
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/personalmicro1
/area/shuttle/personalmicro1


#warn map; these are on strelka
