//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* biology flags

/// humanlike, organic, normal biology
#define BIOLOGY_TYPE_HUMAN (1<<0)
/// fully machinelike
#define BIOLOGY_TYPE_SYNTH (1<<1)
/// promethean / slime
#define BIOLOGY_TYPE_SLIME (1<<2)
/// chimeric
#define BIOLOGY_TYPE_CHIMERA (1<<3)
/// protean
#define BIOLOGY_TYPE_NANITES (1<<4)
/// plant
#define BIOLOGY_TYPE_PLANT (1<<5)
/// crystalline (adherent)
#define BIOLOGY_TYPE_CRYSTALLINE (1<<6)

#define BIOLOGY_TYPES_FLESHY (BIOLOGY_TYPE_HUMAN | BIOLOGY_TYPE_CHIMERA | BIOLOGY_TYPE_PLANT | BIOLOGY_TYPE_SLIME)
#define BIOLOGY_TYPES_SYNTHETIC (BIOLOGY_TYPE_SYNTH | BIOLOGY_TYPE_NANITES)
#define BIOLOGY_TYPES_ALL (ALL)

DEFINE_BITFIELD_NAMED(biology_types, list(
	/datum/medichine_effect/wound_healing = list(
		"biology_types",
	),
), list(
	BITFIELD_NAMED("Human", BIOLOGY_TYPE_HUMAN),
	BITFIELD_NAMED("Synth", BIOLOGY_TYPE_SYNTH),
	BITFIELD_NAMED("Slime", BIOLOGY_TYPE_SLIME),
	BITFIELD_NAMED("Chimera", BIOLOGY_TYPE_CHIMERA),
	BITFIELD_NAMED("Nanites", BIOLOGY_TYPE_NANITES),
	BITFIELD_NAMED("Plant", BIOLOGY_TYPE_PLANT),
))
