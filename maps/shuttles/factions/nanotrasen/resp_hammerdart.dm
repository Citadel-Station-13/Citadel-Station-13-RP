DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/resp_hammerdart)
	id = "nanotrasen-resp_hammerdart"
	name = "RESP - Hammerdart"
	display_name = "Hammerdart Response Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
		preferred_orientation = EAST;
		overmap_icon_color = "#2613d1";
		overmap_legacy_scan_name = "Hammerdart Interception and Rescue Shuttle";
		overmap_legacy_scan_desc = @{"
			[i]Registration[/i]: ---
			[i]Class[/i]: Hammerdart Orbit Patrol Shuttle, Medical refit.
			[i]Transponder[/i]: Transmitting (MED) and (CIV), Registered with NT.
			[b]Notice[/b]: The shuttle is assigned to the NEV Strelka. It is also a fighter carrier vessel.
		"};
		overmap_legacy_name = "Hammerdart Interception and Rescue Shuttle";
		overmap_legacy_desc = "A shuttle combining EMT search and rescue work, with security like work. The best of 2 worlds.";
	}
	facing_dir = EAST

#warn this one's the strelka emt-ish shuttle ; map

/area/shuttle/emt/strelka
/area/shuttle/emt/strelka/cockpit
/area/shuttle/emt/strelka/main

/obj/overmap/entity/visitable/ship/landable/emt/strelka
