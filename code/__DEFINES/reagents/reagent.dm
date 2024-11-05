//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* flags for /datum/reagent/var/reagent_flags *//

// none yet

//* flags for /datum/reagent/var/reagent_guidebook_flags *//

/// doesn't show in guidebook reagent list
#define REAGENT_GUIDEBOOK_UNLISTED (1<<0)
/// can't be pulled up on guidebook at all, other than name
#define REAGENT_GUIDEBOOK_HIDDEN (1<<1)

DEFINE_SHARED_BITFIELD(reagent_guidebook_flags, list(
	"reagent_guidebook_flags",
), list(
	BITFIELD(REAGENT_GUIDEBOOK_UNLISTED),
	BITFIELD(REAGENT_GUIDEBOOK_HIDDEN),
))
