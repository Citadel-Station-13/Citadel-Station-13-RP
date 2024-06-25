//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/var/hides_underfloor

/// do not change these willy-nilly, these are strings for the map editor.

/// just Don't
#define OBJ_UNDERFLOOR_DISABLED "disabled"
/// never underfloor, even if floor isn't plating
#define OBJ_UNDERFLOOR_NEVER "never"
/// always underfloor, as long as floor isn't plating
#define OBJ_UNDERFLOOR_ALWAYS "always"
/// automatic
///
/// * gets set to UNDERFLOOR_NONE if we were made while the floor is intact
/// * gets set to UNDERFLOOR_ALWAYS if we were made while the floor isn't intact
#define OBJ_UNDERFLOOR_IF_COVERED "initially-covered"
/// automatic
///
/// * DEPENDS_ON_CREATION, but always underfloor if made in mapload
#define OBJ_UNDERFLOOR_UNLESS_CREATED_ONTOP "initially-underfloor"

DEFINE_ENUM("obj_hides_underfloor", list(
	/obj = list(
		"hides_underfloor",
	),
), list(
	"Disabled" = OBJ_UNDERFLOOR_DISABLED,
	"Never" = OBJ_UNDERFLOOR_NEVER,
	"Always" = OBJ_UNDERFLOOR_ALWAYS,
	"If Covered (Init Only)" = OBJ_UNDERFLOOR_IF_COVERED,
	"If Created On Floor (Init Only)" = OBJ_UNDERFLOOR_UNLESS_CREATED_ONTOP,
))
