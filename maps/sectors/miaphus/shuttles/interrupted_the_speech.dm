DECLARE_SECTOR_SHUTTLE_TEMPLATE(/miaphus/interrupted_the_speech)
	id = "miaphus-interrupted_the_speech"
	name = "SDF Interrupted-The-Speech"
	desc = "A patrol military vessel."
	display_name = "SDF Interrupted-The-Speech"

	descriptor = /datum/shuttle_descriptor{
		mass = 8000;
		overmap_legacy_scan_name = "SDF Interrupted-The-Speech";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Andromeda BS2002
[i]Transponder[/i]: Transmitting (SDF)
[b]Notice[/b]: A SDF corvette, patrolling the sector."};
		overmap_icon_color = "#ff9900";
	}
	facing_dir = WEST

#warn below sigh

//SDF
/datum/shuttle/autodock/overmap/miaphus/sdf
/obj/overmap/entity/visitable/ship/landable/miaphus/sdf
/area/shuttle/miaphus/sdf
