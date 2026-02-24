//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#define GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH) \
/obj/shuttle_dock_preload/generated##TYPEPATH {; \
	shuttle_template_path = /datum/shuttle_template##TYPEPATH; \
	maptext = MAPTEXT_CENTER_CONST("Shuttle Preloader\n" + "(" + /datum/shuttle_template##TYPEPATH::id + ")"); \
}; \
/datum/shuttle_template/##TYPEPATH

#define DECLARE_SHUTTLE_TEMPLATE(TYPEPATH) GENERATE_SHUTTLE_TEMPLATE_PRELOAD(TYPEPATH)
