DECLARE_SHUTTLE_TEMPLATE(/nanotrasen/exp_javelot)
	id = "nanotrasen-exp_javelot"
	name = "EXP - Javelot"
	display_name = "Javelot Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 12500;
		legacy_overmap_scan_name = "Javelot";
		legacy_overmap_color = "#a890ac";
		legacy_overmap_scan_desc = @{"[i]Registration[/i]: ---
	[i]Class[/i]: Javelot Exploration Shuttle
	[i]Transponder[/i]: Transmitting (CIV), Designed by NT. It is also a fighter carrier vessel."}
		preferred_orientation = EAST
	}
	facing_dir = EAST

#warn impl

/area/shuttle/excursion/strelka
/area/shuttle/excursion/cockpit
/area/shuttle/excursion/general

#warn mutable_appearance
