//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* biology flags *//

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
/// diona (legally not plant)
#define BIOLOGY_TYPE_DIONA (1<<5)
/// plant
#define BIOLOGY_TYPE_PLANT (1<<6)
/// crystalline (adherent)
#define BIOLOGY_TYPE_CRYSTALLINE (1<<7)

#define BIOLOGY_TYPES_FLESHY (BIOLOGY_TYPE_HUMAN | BIOLOGY_TYPE_CHIMERA | BIOLOGY_TYPE_PLANT | BIOLOGY_TYPE_DIONA| BIOLOGY_TYPE_SLIME)
#define BIOLOGY_TYPES_SYNTHETIC (BIOLOGY_TYPE_SYNTH | BIOLOGY_TYPE_NANITES)
#define BIOLOGY_TYPES_ALL (ALL)

DEFINE_BITFIELD_NEW(biology_types, list(
	/datum/medichine_effect/wound_healing = list(
		"biology_types",
	),
), list(
	BITFIELD_NEW("Human", BIOLOGY_TYPE_HUMAN),
	BITFIELD_NEW("Synth", BIOLOGY_TYPE_SYNTH),
	BITFIELD_NEW("Slime", BIOLOGY_TYPE_SLIME),
	BITFIELD_NEW("Chimera", BIOLOGY_TYPE_CHIMERA),
	BITFIELD_NEW("Nanites", BIOLOGY_TYPE_NANITES),
	BITFIELD_NEW("Plant", BIOLOGY_TYPE_PLANT),
))
