//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/var/hides_underfloor

/// never underfloor, even if floor isn't plating
#define OBJ_UNDERFLOOR_NONE 0
/// always underfloor, as long as floor isn't plating
#define OBJ_UNDERFLOOR_ALWAYS 1
/// automatic
///
/// * gets set to UNDERFLOOR_NONE if we were made while the floor is intact
/// * gets set to UNDERFLOOR_ALWAYS if we were made while the floor isn't intact
#define OBJ_UNDERFLOOR_AUTOMATIC 2

#warn DEFINE_ENUM
