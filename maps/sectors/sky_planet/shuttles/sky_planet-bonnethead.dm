DECLARE_SECTOR_SHUTTLE_TEMPLATE(/sky_planet, /bonnethead)
	id = "sky_planet-bonnethead"
	name = "Bonnethead Racing Shuttle"
	desc = "A racing shuttle, that arrived third during the 2542 Voidline shuttle race."

	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#edac14"; //orange
		overmap_legacy_scan_name = "Bonnethead Racing Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
	[i]Class[/i]: Racing Shuttle
	[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
	[b]Notice[/b]: Racing shuttle, arrived third during the 2542 Voidline."};
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/bonnethead
/area/shuttle/bonnethead
