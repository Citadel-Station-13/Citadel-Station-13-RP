//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

#define BIOLOGY_TYPES_FLESHY (BIOLOGY_TYPE_HUMAN | BIOLOGY_TYPE_CHIMERA | BIOLOGY_TYPE_PLANT | BIOLOGY_TYPE_SLIME)
#define BIOLOGY_TYPES_ALL (ALL)

// todo: define bitfield (when do i rework define bitfield)
