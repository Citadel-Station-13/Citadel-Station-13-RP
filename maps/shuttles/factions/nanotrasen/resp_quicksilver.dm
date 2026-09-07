DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/resp_quicksilver)
	id = "nanotrasen-resp_quicksilver"
	name = "RESP - Quicksilver"
	display_name = "NDV Quicksilver"
	descriptor = /datum/shuttle_descriptor{
		mass = 4000;
		preferred_orientation = EAST;
		overmap_legacy_name = "NDV Quicksilver";
		overmap_legacy_desc = "A Nanotasen rapid-response vessel.";
	}
	facing_dir = EAST

#warn ncv_oracle, ndv_marksman, nts_demeter, obliterate, map

/area/shuttle/specops
/area/shuttle/specops/general
/area/shuttle/specops/cockpit
/area/shuttle/specops/engine
/obj/effect/shuttle_landmark/shuttle_initializer/specops
