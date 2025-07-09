//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* /datum/prototype/material material_flags

/// vulnerability applies to mob armor (uh oh)
#define MATERIAL_FLAG_VULNERABLE_MOB_ARMOR (1<<0)
/// utterly immune to melting, thermite or otherwise
#define MATERIAL_FLAG_UNMELTABLE (1<<1)
/// too dangerous to persist
/// this is a somewhat awful flag so we'll keep it until we need to get rid of it
#define MATERIAL_FLAG_CONSIDERED_OVERPOWERED (1<<2)

DEFINE_BITFIELD(material_flags, list(
	BITFIELD(MATERIAL_FLAG_VULNERABLE_MOB_ARMOR),
	BITFIELD(MATERIAL_FLAG_UNMELTABLE),
	BITFIELD(MATERIAL_FLAG_CONSIDERED_OVERPOWERED),
))

//* /datum/prototype/material material_constraints
//* /datum/prototype/design material_constraints list values



#define MATERIAL_CONSTRAINT_NONE ~0 //all on. NEVER GIVE A MATERIAL THIS. THIS SHOULD BE ON material_constraints ONLY.
#define MATERIAL_CONSTRAINT_RIGID (1<<0)//can be used for structure. walls, floors, etc
#define MATERIAL_CONSTRAINT_TRANSPARENT (1<<1) //transparent: glass and stuff
#define MATERIAL_CONSTRAINT_CONDUCTIVE (1<<2) //conducts electricity

DEFINE_BITFIELD(material_constraints, list(
	BITFIELD(MATERIAL_CONSTRAINT_RIGID),
	BITFIELD(MATERIAL_CONSTRAINT_TRANSPARENT),
	BITFIELD(MATERIAL_CONSTRAINT_CONDUCTIVE),
))

//* /datum/prototype/material_trait material_trait_flags

/// hook melees
#define MATERIAL_TRAIT_MELEE (1<<0)
/// hook shieldcalls
//  todo: not implemented; maybe rework?
#define MATERIAL_TRAIT_SHIELD (1<<1)
/// reqiures passive ticking
//  todo: re-evaluate
#define MATERIAL_TRAIT_TICKING (1<<2)
/// has examine text
#define MATERIAL_TRAIT_EXAMINE (1<<3)
/// requires setup/teardown
//  todo: not implemented; maybe rework?
#define MATERIAL_TRAIT_REGISTRATION (1<<4)

DEFINE_BITFIELD(material_trait_flags, list(
	BITFIELD(MATERIAL_TRAIT_MELEE),
	BITFIELD(MATERIAL_TRAIT_SHIELD),
	BITFIELD(MATERIAL_TRAIT_TICKING),
	BITFIELD(MATERIAL_TRAIT_EXAMINE),
	BITFIELD(MATERIAL_TRAIT_REGISTRATION),
))
