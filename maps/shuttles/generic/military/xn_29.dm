DECLARE_SHUTTLE_TEMPLATE(/generic/military/xn_29)
	id = "military-xn_29"
	name = "XN-29 Hybrid Shuttle"
	desc = "A prototype shuttle with alien technology integrated into its systems."

	descriptor = /datum/shuttle_descriptor{
		overmap_legacy_scan_name = "XN-29 Prototype Shuttle";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: UNKNOWN
	[i]Class[/i]: Shuttle
	[i]Transponder[/i]: Transmitting (MIL), Nanotrasen
	[b]Notice[/b]: Experimental vessel"};
		overmap_icon_color = "#00aaff"; //Bluey
		mass = 7500;
	}

#warn impl

// The shuttle's area(s)
/area/shuttle/blue_fo
// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/hybridshuttle
// The 'ship'
/obj/overmap/entity/visitable/ship/landable/hybridshuttle

#warn map
