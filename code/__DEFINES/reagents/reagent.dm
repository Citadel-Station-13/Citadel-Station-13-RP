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

//* flags for /datum/reagent/var/reagent_filter_flags *//

/// the default flag that reagents have by default.
#define REAGENT_FILTER_GENERIC (1<<0)

/// **disallow** from common medical machinery, like sleepers.
///
/// * high-end reagents filtration / systems should be able to hit this
#define REAGENT_FILTER_NO_COMMON_BIOANALYSIS (1<<23)
