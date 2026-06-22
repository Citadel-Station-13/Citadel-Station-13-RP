DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/generic_1)
	id = "generic-generic_1"
	name = "Generic Shuttle"

	descriptor = /datum/shuttle_descriptor{
		preferred_orientation = EAST;
		mass = 12500;
		overmap_icon_color = "#00AA00";
		overmap_legacy_name = "Generic Shuttle";
		overmap_legacy_desc = "A small privately-owned vessel.";
	}

	display_name = "Private Vessel"
	facing_dir = EAST

#warn impl

/area/shuttle/generic_shuttle/eng
/area/shuttle/generic_shuttle/gen
/obj/effect/shuttle_landmark/shuttle_initializer/generic_shuttle

#warn map
