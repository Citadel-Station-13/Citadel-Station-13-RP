DECLARE_SHUTTLE_TEMPLATE(/generic/outlaw/pirate_skiff)
	id = "outlaw_pirate_skiff"

	descriptor = /datum/shuttle_descriptor{
		mass = 8000;
		preferred_orientation = WEST;
		overmap_legacy_name = "Unknown Vessel";
		overmap_legacy_desc = "Scans inconclusive.";
		overmap_icon_color = "#751713"; //Dark Red
	}
	facing_dir = WEST

#warn this is on piratebase_192
/obj/effect/shuttle_landmark/shuttle_initializer/pirate
	name = "Pirate Skiff Dock"
// Pirate Skiff
#warn obliterate, map
/area/shuttle/pirate
/area/shuttle/pirate/deck
/area/shuttle/pirate/bridge
/area/shuttle/pirate/engine
