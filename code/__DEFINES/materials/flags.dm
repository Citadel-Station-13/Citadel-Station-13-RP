//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* /datum/material material_flags

/// vulnerability applies to mob armor (uh oh)
#define MATERIAL_FLAG_VULNERABLE_MOB_ARMOR (1<<0)

DEFINE_BITFIELD(material_flags, list(
	BITFIELD(MATERIAL_FLAG_VULNERABLE_MOB_ARMOR),
))

//* /datum/material material_constraints
//* /datum/design material_constraints list values

// None yet

DEFINE_BITFIELD(material_constraints, list(
	// none yet
))

//* /datum/material_trait material_trait_flags

/// used to attack
#define MATERIAL_TRAIT_ATTACK (1<<0)
/// used to defend
#define MATERIAL_TRAIT_DEFEND (1<<1)
/// reqiures passive ticking
#define MATERIAL_TRAIT_TICKING (1<<2)
/// has examine text
#define MATERIAL_TRAIT_EXAMINE (1<<3)
/// requires setup/teardown
#define MATERIAL_TRAIT_REGISTRATION (1<<4)

DEFINE_BITFIELD(material_trait_flags, list(
	BITFIELD(MATERIAL_TRAIT_ATTACK),
	BITFIELD(MATERIAL_TRAIT_DEFEND),
	BITFIELD(MATERIAL_TRAIT_TICKING),
	BITFIELD(MATERIAL_TRAIT_EXAMINE),
	BITFIELD(MATERIAL_TRAIT_REGISTRATION),
))

//! WARNING: CONSIDERED LEGACY CODE !//
// Flags returned from material defense hooks
// eventually we want to transition all of this to the atom shieldcall system.

#define MATERIAL_DEFEND_FORCE_MISS (1<<0)
#define MATERIAL_DEFEND_FULL_BLOCK (1<<1)
#define MATERIAL_DEFEND_REFLECT (1<<2)
