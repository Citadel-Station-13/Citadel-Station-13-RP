DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/surfluid_egress_dart)
	id = "generic-surfluid_egress_dart"
	name = "Surfluid Egress Dart"
	display_name = "Surfluid Egress Dart"

	descriptor = /datum/shuttle_descriptor{
		mass = 1000;
		overmap_legacy_scan_name = "Surfluid Egress Dart";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: NOT AVAILABLE
	[i]Class[/i]: Escape Pod
	[i]Transponder[/i]: Transmitting (CIV), non-hostile
	[b]Notice[/b]: Emergency Transponder Active"};
	}

#warn fun fluff for this!
#warn impl

/area/shuttle/deployable/escapepod
/obj/effect/shuttle_landmark/shuttle_initializer/escapepod
/obj/overmap/entity/visitable/ship/landable/escapepod
