//? flags for /datum/reagents/var/reagent_holder_flags

// none yet

//? flags for /datum/reagent/var/reagent_flags

// none yet

//? flags for /datum/reagent/var/reagent_guidebook_flags

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

//? flags for /datum/chemical_reaction/var/chemical_reaction_flags

// none yet

//? flags for /datum/chemical_reaction/var/reaction_guidebook_flags

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
