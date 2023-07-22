//* /datum/material material_flags

// None yet

DEFINE_BITFIELD(material_flags, list(
	// none yet
))

//* /datum/material material_constraints
//* /datum/design material_constraints list values

// None yet

DEFINE_BITFIELD(material_constraints, list(
	// none yet
))

//* /datum/material_trait material_trait_flags

/// outgoing melee or throw impact
#define MATERIAL_TRAIT_MELEE_OUTBOUND (1<<0)
/// incoming melee or throw impact
#define MATERIAL_TRAIT_MELEE_INBOUND (1<<1)
/// incoming projectile
#define MATERIAL_TRAIT_PROJECTILE_INBOUND (1<<2)
/// used as projectile
#define MATERIAL_TRAIT_PROJECTILE_OUTBOUND (1<<3)
/// reqiures passive ticking
#define MATERIAL_TRAIT_TICKING (1<<4)
/// has examine text
#define MATERIAL_TRAIT_EXAMINE (1<<5)

DEFINE_BITFIELD(material_trait_flags, list(
	BITFIELD(MATERIAL_TRAIT_MELEE_INBOUND),
	BITFIELD(MATERIAL_TRAIT_MELEE_OUTBOUND),
	BITFIELD(MATERIAL_TRAIT_PROJECTILE_INBOUND),
	BITFIELD(MATERIAL_TRAIT_PROJECTILE_OUTBOUND),
	BITFIELD(MATERIAL_TRAIT_TICKING),
	BITFIELD(MATERIAL_TRAIT_EXAMINE),
))
