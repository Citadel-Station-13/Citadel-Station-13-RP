DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/gecko_sh)
	id = "generic-gecko_sh"
	name = "Gecko Stationhopper"
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#3366FF";
		overmap_legacy_name = "Gecko Stationhopper";
		overmap_legacy_desc = "A medium personnel transport shuttle.";
	}

DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/gecko_cr)
	id = "generic-gecko_cr"
	name = "Gecko Cargo Hauler"
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#3366FF";
		overmap_legacy_name = "Gecko Cargo Hauler";
		overmap_legacy_desc = "A medium supply transport shuttle.";
	}

DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/gecko_cr_wreck)
	id = "generic-gecko_cr_wreck"
	name = "Wrecked Gecko Cargo Hauler"
	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#3366FF";
		overmap_legacy_name = "Wrecked Gecko Cargo Hauler";
		overmap_legacy_desc = "A wrecked medium supply transport shuttle.";
	}

#warn below, map

/obj/effect/shuttle_landmark/shuttle_initializer/gecko_sh
/obj/effect/shuttle_landmark/shuttle_initializer/gecko_cr
/obj/effect/shuttle_landmark/shuttle_initializer/gecko_cr_wreck
/datum/map_template/shuttle/overmap/generic/gecko_stationhopper
	name = "OM Ship - Gecko Stationhopper (new Z)"
	desc = "A medium personnel transport shuttle."
/datum/map_template/shuttle/overmap/generic/gecko_cargohauler
	name = "OM Ship - Gecko Cargo Hauler (new Z)"
	desc = "A medium supply transport shuttle."
/datum/map_template/shuttle/overmap/generic/gecko_cargohauler_wreck
	name = "OM Ship - Wrecked Gecko Cargo Hauler (new Z)"
	desc = "A wrecked medium supply transport shuttle."
/area/shuttle/gecko_sh
/area/shuttle/gecko_sh_engineering
/area/shuttle/gecko_sh_cockpit
/area/shuttle/gecko_cr
/area/shuttle/gecko_cr_engineering
/area/shuttle/gecko_cr_cockpit
/area/shuttle/gecko_cr_wreck
/area/shuttle/gecko_cr_engineering_wreck
/area/shuttle/gecko_cr_cockpit_wreck
/obj/overmap/entity/visitable/ship/landable/gecko_sh
/obj/overmap/entity/visitable/ship/landable/gecko_cr
/obj/overmap/entity/visitable/ship/landable/gecko_cr_wreck
