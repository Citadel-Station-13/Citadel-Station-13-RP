DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/civ_decades_old)
	id = "nanotrasen-civ_decades_old"
	name = "CIV - Decades Old"
	display_name = "Decades Old"

	descriptor = /datum/shuttle_descriptor{
		mass = 8500;
		preferred_orientation = NORTH;
		overmap_icon_color = "#4cad73";
		overmap_legacy_name = "Decades Old Transport";
		overmap_legacy_desc = "A basic, but slow, transport to ferry civilian to and from the ship.";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: 2460 Ustio class Civilian Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT."};
		overmap_icon_color = "#7fbd27";
	}
	facing_dir = NORTH

#warn obliterate, map
/area/shuttle/civvie/strelka
/area/shuttle/civvie/strelka/main
/area/shuttle/civvie/strelka/cockpit
