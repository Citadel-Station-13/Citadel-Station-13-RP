DECLARE_SHUTTLE_TEMPLATE(/factions/independent/mackerel_stationhopper)
	id = "independent-mackerel_stationhopper"
	name = "Mackerel Stationhopper"
	desc = "A small personnel transport shuttle."
	display_name = "Mackerel Stationhopper"
	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_icon_color = "#3366FF";
		overmap_legacy_scan_name = "Mackerel-class Transport";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ITV Phish Phlake
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"};
	}

DECLARE_SHUTTLE_TEMPLATE(/factions/independent/mackerel_light_cargo)
	id = "independent-mackerel_light_cargo"
	name = "Mackerel Light Cargo"
	desc = "A small cargo transport shuttle."
	display_name = "Mackerel Transport"
	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_icon_color = "#0099FF";
		overmap_legacy_scan_name = "Mackerel-class Transport";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ITV Phishy Business
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"};
	}

DECLARE_SHUTTLE_TEMPLATE(/factions/independent/mackerel_heavy_cargo)
	id = "independent-mackerel_heavy_cargo"
	name = "Mackerel Heavy Cargo"
	desc = "A small cargo transport shuttle, with a reinforced hull and more powerful engines."
	display_name = "Mackerel Transport"
	descriptor = /datum/shuttle_descriptor{
		mass = 11000;
		overmap_icon_color = "#33CCCC";
		overmap_legacy_scan_name = "Mackerel-class Transport";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ITV Phish Pharma
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"};
	}

DECLARE_SHUTTLE_TEMPLATE(/factions/independent/mackerel_heavy_cargo_spartan)
	id = "independent-mackerel_heavy_cargo_spartan"
	name = "Mackerel Heavy Cargo Spartan"
	desc = "A small cargo transport shuttle, with a reinforced hull and more powerful engines."
	display_name = "Mackerel Heavy Cargo"
	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
		overmap_icon_color = "#33CCCC";
		overmap_legacy_scan_name = "Mackerel-class Transport (Spartanized)";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ITV Phish Pond
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"};
	}

DECLARE_SHUTTLE_TEMPLATE(/factions/independent/mackerel_light_cargo_wreck)
	id = "independent-mackerel_light_cargo_wreck"
	name = "Wrecked Mackerel Light Cargo"
	desc = "The wreck of a Mackerel Light Cargo shuttle."
	display_name = "Mackerel Transport Wreck"
	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_icon_color = "#0099FF";
		overmap_legacy_scan_name = "Wrecked Mackerel-class Transport";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ITV Phish Phood
[i]Class[/i]: Small Shuttle Wreck
[i]Transponder[/i]: Not Transmitting
[b]Notice[/b]: Critical Damage Sustained"};
	}

#warn impl

// The shuttle's area(s)
/area/shuttle/mackerel_sh
/area/shuttle/mackerel_lc
/area/shuttle/mackerel_hc
/area/shuttle/mackerel_hc_skel
/area/shuttle/mackerel_hc_skel_cockpit
/area/shuttle/mackerel_hc_skel_eng
/area/shuttle/mackerel_lc_wreck
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_sh
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc_skel
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc_wreck
/obj/overmap/entity/visitable/ship/landable/mackerel_sh
/obj/overmap/entity/visitable/ship/landable/mackerel_lc
/obj/overmap/entity/visitable/ship/landable/mackerel_hc
/obj/overmap/entity/visitable/ship/landable/mackerel_hc_skel
/obj/overmap/entity/visitable/ship/landable/mackerel_lc_wreck
#warn map
