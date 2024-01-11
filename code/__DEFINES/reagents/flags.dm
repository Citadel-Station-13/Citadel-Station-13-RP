//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? flags for /datum/reagent_holder/var/reagent_holder_flags

/// stasis all reactions
#define REAGENT_HOLDER_NO_REACT (1<<0)
/// when we are the primary reagents container of an object, we are considered 'open' (e.g. we can be poured out and others can be poured in)
// todo: should this really be a flag?
// todo: god, i hate /atom/var/reagents
#define REAGENT_HOLDER_CONSIDERED_OPEN (1<<1)
/// when we are the primary reagent container of an object, allow viewing reagent (display) names
#define REAGENT_HOLDER_EXAMINE_REAGENTS (1<<2)
/// when we are the primary reagent container of an object, allow viewing exact reagent volumes
#define REAGENT_HOLDER_EXAMINE_EXACT_VOLUMES (1<<3)
/// when we are the primary reagent container of an object, allow viewing overall reagent volumes
#define REAGENT_HOLDER_EXAMINE_OVERALL_VOLUME (1<<4)
/// when we are the primary reagent container of an object, allow analyzing inside
#define REAGENT_HOLDER_TRANSPARENT_ANALYSIS (1<<5)
/// when we are the primary reagent container of an object, allow syringe injection
#define REAGENT_HOLDER_SYRINGE_INJECTABLE (1<<6)
/// when we are the primary reagent container of an object, allow syringe drawing
#define REAGENT_HOLDER_SYRINGE_DRAWABLE (1<<7)


#define REAGENT_HOLDER_FLAGS_ANY_EXAMINE (REAGENT_HOLDER_TRANSPARENT_ANALYSIS | REAGENT_HOLDER_EXAMINE_REAGENTS \
	REAGENT_HOLDER_EXAMINE_EXACT_VOLUMES | REAGENT_HOLDER_EXAMINE_OVERALL_VOLUME)

// todo: define bitfield

//? flags for /datum/reagent/var/reagent_flags

/// disallow mech syringe guns synthesis / cloning of this reagent
// todo: this is shit and i hate reagent synth
#define REAGENT_NO_SYNTH (1<<0)

// todo: define bitfield

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
