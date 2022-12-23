//! bodytypes - they are lists for var storage, but should only be passed one at a time to rendering!

//? special - do not use directly in item defs
/// should be the only element in the list if used; represents all-except-these
#define BODYTYPE_EXCEPT "except"

//? helpers - use these to make your lists in item definitions
/// all bodytypes
#define BODYTYPES_ALL "all"
/// these bodytypes
#define BODYTYPES(types...) list(types)
/// all but these bodytypes
#define BODYTYPES_EXCEPT(types...) list(BODYTYPE_EXCEPT, ##types)
/// no bodytypes
#define BODYTYPES_NONE "none"

//? bodytype defs
/// normal human bodytype (or generally everyone else)
#define BODYTYPE_DEFAULT			"default"
/// teshari bodytype (or generally tiny birds)
#define BODYTYPE_TESHARI			"teshari"
/// adherent bodytype (or generally giant serpent creatures)
#define BODYTYPE_ADHERENT			"adherent"
/// unathi bodytype (or generally lizard)
#define BODYTYPE_UNATHI				"unathi"
/// tajaran bodytype (or generally cat)
#define BODYTYPE_TAJARAN			"tajaran"
/// vulp bodytype (or generally foxes)
#define BODYTYPE_VULPKANIN			"vulpkanin"
/// skrell bodytype (or generally weird fleshy fishpeople)
#define BODYTYPE_SKRELL				"skrell"
/// sergal bodytype (or generally cheese)
#define BODYTYPE_SERGAL				"sergal"
/// akula bodytype (or generally shark)
#define BODYTYPE_AKULA				"akula"
/// vox bodytype
#define BODYTYPE_VOX				"vox"
/// neverean bodytype
#define BODYTYPE_NEVREAN			"nevrean"
/// promethean bodytype
#define BODYTYPE_PROMETHEAN			"promethean"
/// highlander zorren
#define BODYTYPE_ZORREN_HIGH		"zorren-high"
/// flatlander zorren
#define BODYTYPE_ZORREN_FLAT		"zorren-flat"
/// zaddat
#define BODYTYPE_ZADDAT				"zaddat"
/// phoronoid
#define BODYTYPE_PHORONOID			"phoronoid"
/// werebeast
#define BODYTYPE_WEREBEAST			"werebeast"
/// xenomorph hybrid
#define BODYTYPE_XENOHYBRID			"xenohybrid"
/// digitigrade unathi
#define BODYTYPE_UNATHI_DIGI        "unathi-digi"

//! keep this number (count) up to date
#define BODYTYPES_TOTAL 19

//? automatically typelist bodytypes if it's a list
#define CACHE_BODYTYPES(LIST) if(islist(LIST)) LIST = typelist(NAMEOF(src, LIST), LIST)
//? check bodytype lists matching
#define COMPARE_BODYTYPES(L1, L2) compare_bodytypes(L1, L2)
//? check bodytype list membership
#define CHECK_BODYTYPE(L, BT) (L != BODYTYPE_NONE) && ((L == BODYTYPE_ALL) || (BODYTYPE_EXCLUDE in L? !(bt in L) : (bt in L)))

/proc/compare_bodytypes(list/L1, list/L2)
	if(L1 == BODYTYPE_NONE || L2 == BODYTYPE_NONE)
		return FALSE
	if(L1 == BODYTYPE_ALL || L2 == BODYTYPE_ALL)
		return TRUE
	if(BODYTYPE_EXCLUDE in L1)
		if(BODYTYPE_EXCLUDE in L2)
			return length(L1 | L2) != BODYTYPES_TOTAL
		else
			return !!length(L2 - L1) // l2 has something not excluded from l1
	else
		if(BODYTYPE_EXCLUDE in L2)
			return !!length(L1 - L2) // l1 has something not excluded from l2
		else
			return !!length(L1 & L2) // l1 has something in l2

// todo: what are we going to do with these?
//? we should probably standardize bodytypes as entirely different sprites, and also
//? have a set of "mutators" for items that apply to the default humanoid form
//? like having snout, eats, horns, lithe tail, big long tail, the 2-3 types of fox tails,
//? digitigrade legs, so on, so forth
//! How we'll do that is another problem to be oslved later.
/*
/// has snout - usually relevant for masks and headgear
#define BODYTYPE_SNOUT				(1<<20)
/// snake taur bodytype - usually relevant for hardsuits and similar
#define BODYTYPE_TAUR_SNAKE			(1<<21)
/// horse taur bodytype - ditto
#define BODYTYPE_TAUR_HORSE			(1<<22)
/// digitigrade feet - usually relevant for leg covering gear
#define BODYTYPE_DIGITIGRADE		(1<<23)
*/

//! bodytypes as strings - these must never change as .dmis store with these!
#define BODYTYPE_STRING_DEFAULT "default"
#define BODYTYPE_STRING_TESHARI "teshari"
#define BODYTYPE_STRING_ADHERENT "adherent"
#define BODYTYPE_STRING_UNATHI "unathi"
#define BODYTYPE_STRING_UNATHI_DIGI "unathidigi"
#define BODYTYPE_STRING_TAJARAN "tajaran"
#define BODYTYPE_STRING_VULPKANIN "vulpkanin"
#define BODYTYPE_STRING_SKRELL "skrell"
#define BODYTYPE_STRING_SERGAL "sergal"
#define BODYTYPE_STRING_AKULA "akula"
#define BODYTYPE_STRING_VOX "vox"
#define BODYTYPE_STRING_NEVREAN "nevrean"
#define BODYTYPE_STRING_PROMETHEAN "promethean"
#define BODYTYPE_STRING_ZORREN_HIGH "highzorren"
#define BODYTYPE_STRING_ZORREN_FLAT "flatzorren"
#define BODYTYPE_STRING_ZADDAT "zaddat"
#define BODYTYPE_STRING_PHORONOID "phoronoid"
#define BODYTYPE_STRING_WEREBEAST "werebeast"
#define BODYTYPE_STRING_XENOHYBRID "xenohybrid"

/proc/bodytype_to_string(bodytype)
	// todo: assoc list lookup
	switch(bodytype)
		if(BODYTYPE_DEFAULT)
			return BODYTYPE_STRING_DEFAULT
		if(BODYTYPE_TESHARI)
			return BODYTYPE_STRING_TESHARI
		if(BODYTYPE_ADHERENT)
			return BODYTYPE_STRING_ADHERENT
		if(BODYTYPE_UNATHI)
			return BODYTYPE_STRING_UNATHI
		if(BODYTYPE_UNATHI_DIGI)
			return BODYTYPE_STRING_UNATHI_DIGI
		if(BODYTYPE_TAJARAN)
			return BODYTYPE_STRING_TAJARAN
		if(BODYTYPE_VULPKANIN)
			return BODYTYPE_STRING_VULPKANIN
		if(BODYTYPE_SKRELL)
			return BODYTYPE_STRING_SKRELL
		if(BODYTYPE_SERGAL)
			return BODYTYPE_STRING_SERGAL
		if(BODYTYPE_AKULA)
			return BODYTYPE_STRING_AKULA
		if(BODYTYPE_VOX)
			return BODYTYPE_STRING_VOX
		if(BODYTYPE_NEVREAN)
			return BODYTYPE_STRING_NEVREAN
		if(BODYTYPE_PROMETHEAN)
			return BODYTYPE_STRING_PROMETHEAN
		if(BODYTYPE_ZORREN_HIGH)
			return BODYTYPE_STRING_ZORREN_HIGH
		if(BODYTYPE_ZORREN_FLAT)
			return BODYTYPE_STRING_ZORREN_FLAT
		if(BODYTYPE_ZADDAT)
			return BODYTYPE_STRING_ZADDAT
		if(BODYTYPE_PHORONOID)
			return BODYTYPE_STRING_PHORONOID
		if(BODYTYPE_WEREBEAST)
			return BODYTYPE_STRING_WEREBEAST
		if(BODYTYPE_XENOHYBRID)
			return BODYTYPE_STRING_XENOHYBRID
		else
			CRASH("unknown bodytype: [bodytype]")
