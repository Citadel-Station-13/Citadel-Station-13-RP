//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//**** Slots - /obj/item/gun_component ****//

//* Note: These are all suggestions.                                     *//
//* Components hook the gun via component signals and registration APIs  *//
//* An acceleration coil can hook power draw just like a power unit can. *//

//* All components are defaulted. This is for UX and optimization.                   *//
//* Unless a gun otherwise specifies, not having a component just means 'no change'. *//
//*                                                                                  *//
//* This is because components are not actually hardcoded APIs that are called       *//
//* during firing, but actually modifiers onto the gun.                              *//
//*                                                                                  *//
//* This is a large departure from traditional guncrafting systems that necessitate  *//
//* invoking procs on all components every cycle.                                    *//

// todo: DEFINE_ENUM on everything

//* - generic - all weaponry -- *//

/// any internal modules like trackers, etc
#define GUN_COMPONENT_INTERNAL_MODULE "internal-module"

//* - generic - all energy-based weaponry -- *//

/// interacts with energizing the beam lens / acceleration coils
#define GUN_COMPONENT_ENERGY_HANDLER "energy-handler"
/// interacts with power draw
#define GUN_COMPONENT_POWER_UNIT "power-unit"
/// a ballistic gun can have this but these generally require power to function
#define GUN_COMPONENT_ACTIVE_COOLER "active-cooler"

//* - generally magnetic - *//

/// component used for accelerating the projectile.
#define GUN_COMPONENT_ACCELERATION_COIL "magnetic-coil"

//* - generally particle (energy) - *//

/// component used to (re)-focus the energy beam being emit
#define GUN_COMPONENT_FOCUSING_LENS "focusing-lens"
/// component that generates the particle stream
#define GUN_COMPONENT_PARTICLE_ARRAY "particle-array"

GLOBAL_REAL_LIST(gun_component_enum_to_name) = list(
	GUN_COMPONENT_INTERNAL_MODULE = "internal module",
	GUN_COMPONENT_ENERGY_HANDLER = "energy handler",
	GUN_COMPONENT_POWER_UNIT = "power unit",
	GUN_COMPONENT_ACTIVE_COOLER = "cooling system",
	GUN_COMPONENT_ACCELERATION_COIL = "acceleration coil",
	GUN_COMPONENT_FOCUSING_LENS = "focusing lens",
	GUN_COMPONENT_PARTICLE_ARRAY = "particle array",
)

//**** Conflict Flags - /obj/item/gun_component ****//

// None yet.
