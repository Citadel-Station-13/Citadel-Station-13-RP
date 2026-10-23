DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/sdf_birdcage)
	id = "generic-sdf_birdcage"
	name = "SDF Birdcage"
	display_name = "SDF Birdcage"

	descriptor = /datum/shuttle_descriptor{
		mass = 12000;
		overmap_legacy_scan_name = "SDF Birdcage";
		overmap_legacy_scan_desc = @{"\[i\]Registration\[/i\]: SDV Birdcage
	\[i\]Class\[/i\]: Light Escort Carrier
	\[i\]Transponder\[/i\]: Transmitting (MIL), Weak Signal
	\[b\]Notice\[/b\]: Registration Expired"};
	}
	facing_dir = WEST
/obj/effect/shuttle_landmark/shuttle_initializer/tinycarrier
/obj/overmap/entity/visitable/ship/landable/tinycarrier
