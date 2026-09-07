DECLARE_SECTOR_SHUTTLE_TEMPLATE(/sky_planet, /red_comet)
	id = "sky_planet-red_comet"
	name = "Red Comet Racing Shuttle"
	desc = "A racing shuttle, that arrived second during the 2542 Voidline shuttle race."
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#ab0000"; //Crimson. Makes shuttle go 3 times faster (no). Beside, You solely, are responsible for this.
		overmap_legacy_scan_name = "Red Comet Racing Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
[b]Notice[/b]: Racing shuttle, arrived second during the 2542 Voidline."};
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/redcomet
/area/shuttle/redcomet
