//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/var/hides_underfloor *//

/// do not change these willy-nilly, these are strings for the map editor.

/// just Don't
/// * this is different from 'NEVER'
#define OBJ_UNDERFLOOR_UNSUPPORTED "unsupported"
/// never underfloor, even if floor isn't plating
#define OBJ_UNDERFLOOR_NEVER "never"
/// Should be underfloor, and is not currently underfloor.
/// * Setting to this at runtime is equal to setting to [OBJ_UNDERFLOOR_ACTIVE].
///   The atom will automatically hide under the floor if the floor is covered.
#define OBJ_UNDERFLOOR_INACTIVE "inactive"
/// Should be underfloor, and is currently underfloor.
/// * Setting to this at runtime is equal to setting to [OBJ_UNDERFLOOR_INACTIVE].
///   The atom will automatically hide under the floor if the floor is covered.
#define OBJ_UNDERFLOOR_ACTIVE "active"
/// automatic
///
/// * gets set to UNDERFLOOR_NEVER if we were made while the floor is intact
/// * gets set to UNDERFLOOR_ALWAYS if we were made while the floor isn't intact
#define OBJ_UNDERFLOOR_IF_CREATED_UNCOVERED "initially-covered"
/// automatic
///
/// * This is what you usually want.
/// * IF_CREATED_UNCOVERED, but always underfloor if made in mapload
#define OBJ_UNDERFLOOR_UNLESS_PLACED_ONTOP "initially-underfloor"

DEFINE_ENUM("obj_hides_underfloor", list(
	/obj = list(
		"hides_underfloor",
	),
), list(
	"Unsupported" = OBJ_UNDERFLOOR_UNSUPPORTED,
	"No" = OBJ_UNDERFLOOR_NEVER,
	"Yes (Currently Uncovered)" = OBJ_UNDERFLOOR_INACTIVE,
	"Yes (Currently Covered)" = OBJ_UNDERFLOOR_ACTIVE,
	"If Created Uncovered (Init Only)" = OBJ_UNDERFLOOR_IF_CREATED_UNCOVERED,
	"If Created Uncovered Or In Mapload (Init Only)" = OBJ_UNDERFLOOR_UNLESS_PLACED_ONTOP,
))
