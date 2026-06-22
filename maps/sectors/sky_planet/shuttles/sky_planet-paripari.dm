DECLARE_SECTOR_SHUTTLE_TEMPLATE(/sky_planet, /paripari)
	id = "sky_planet-paripari"
	name = "Udang Pari-pari Racing Shuttle"
	desc = "A racing shuttle, that arrived last during the 2542 Voidline shuttle race."

	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#3adf1d"; //green
		overmap_legacy_scan_name = "Udang Pari-pari Racing Shuttle";
		overmap_legacy_scan_name = @{"[i]Registration[/i]: ---
[i]Class[/i]: Racing Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Lythios 43a Voidline Racing Sky Rig, non-hostile
[b]Notice[/b]: Racing shuttle, arrived last during the 2542 Voidline, altho won prior races in skrell and oricon space while being used to make deliveries."};
	}
	facing_dir = WEST

#warn ipmpl

//Udang Pari-pari
/datum/shuttle/autodock/overmap/voidline/paripari
/area/shuttle/paripari
