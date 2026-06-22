#warn check map, is this viable for moving to generic shuttles?
DECLARE_SECTOR_SHUTTLE_TEMPLATE(/ndv_von_braun, /nrv_robineau)
	id = "sector-ndv_von_braun-nrv_robineau"
	name = "NRV Robineau"
	desc = "A corporate emergency response ship."

	descriptor = /datum/shuttle_descriptor{
		overmap_icon_color = "#9999ff";
		mass = 8000;
		preferred_orientation = EAST;
		overmap_legacy_scan_name = "NRV Von Braun"
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: Nanotrasen RRV Von Braun
[i]Class[/i]: [i]Kepler[/i]-class Frigate
[i]Transponder[/i]: Broadcasting (ER-CORP)
[b]Notice[/b]: Impeding or interfering with emergency response vessels is a breach of numerous interstellar codes. Approach with caution."};
	}
	facing_dir = EAST;

/obj/effect/shuttle_landmark/premade/ert_ship_port
/obj/effect/shuttle_landmark/premade/ert_ship_star
/obj/effect/shuttle_landmark/premade/ert_ship_near_fore
/obj/effect/shuttle_landmark/premade/ert_ship_near_aft
/obj/effect/shuttle_landmark/premade/ert_ship_near_port
/obj/effect/shuttle_landmark/premade/ert_ship_near_star

#warn this shit
