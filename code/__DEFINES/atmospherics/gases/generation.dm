//* Collisions

/// collision threshold for molar mass on generated gasses
#define GAS_COLLISION_THRESHOLD_MOLAR_MASS 0.1
/// factor used because rand() doesn't do decimals.
#define GAS_COLLISION_FACTOR_MOLAR_MASS (1 / GAS_COLLISION_THRESHOLD_MOLAR_MASS)

//* Danger flags

/// allow oxidizer
#define PROCEDURAL_GAS_ALLOW_OXIDIZER (1<<0)
/// allow fuel
#define PROCEDURAL_GAS_ALLOW_FUEL (1<<1)
/// can be both oxidizer and fuel. !!DANGEROUS!!
#define PROCEDURAL_GAS_ALLOW_UNARY_BURNMIX (1<<2)

DEFINE_BITFIELD(procedural_gas_flags, list(
	BITFIELD(PROCEDURAL_GAS_ALLOW_OXIDIZER),
	BITFIELD(PROCEDURAL_GAS_ALLOW_FUEL),
	BITFIELD(PROCEDURAL_GAS_ALLOW_UNARY_BURNMIX),
))
