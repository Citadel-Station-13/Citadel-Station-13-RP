//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* flags for /datum/chemical_reaction/var/chemical_reaction_flags *//

// none yet

//* flags for /datum/chemical_reaction/var/reaction_guidebook_flags *//

/// doesn't show in guidebook reaction list
#define REACTION_GUIDEBOOK_UNLISTED (1<<0)
/// can't be pulled up on guidebook at all, other than name
#define REACTION_GUIDEBOOK_HIDDEN (1<<1)

DEFINE_SHARED_BITFIELD(reaction_guidebook_flags, list(
	"reaction_guidebook_flags",
), list(
	BITFIELD(REACTION_GUIDEBOOK_UNLISTED),
	BITFIELD(REACTION_GUIDEBOOK_HIDDEN),
))
