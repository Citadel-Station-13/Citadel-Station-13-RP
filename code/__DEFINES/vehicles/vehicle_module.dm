//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//*                  Module Slots                *//
//* A simple, single assignment limitation system. *//

#define VEHICLE_MODULE_SLOT_HULL "hull"
#define VEHICLE_MODULE_SLOT_WEAPON "weapon"
#define VEHICLE_MODULE_SLOT_UTILITY "utility"
#define VEHICLE_MODULE_SLOT_SPECIAL "special"

//* Module Classes *//

/// allow micro-mechs
/// * sigh, blame vorestation but i didn't have the heart to backspace it even though i honestly should
#define VEHICLE_MODULE_CLASS_MICRO (1<<0)
/// allow macro-mechs
#define VEHICLE_MODULE_CLASS_MACRO (1<<1)

// TODO: DEFINE_BITFIELD_NEW
