//! bodytypes - they are flags for var storage, but should only be passed one at a time to rendering!
#define S_BODYTYPE(num) (#num + ",")

/// normal human bodytype (or generally everyone else)
#define BODYTYPE_DEFAULT S_BODYTYPE(0)
/// teshari bodytype (or generally tiny birds)
#define BODYTYPE_TESHARI S_BODYTYPE(1)
/// adherent bodytype (or generally giant serpent creatures)
#define BODYTYPE_ADHERENT S_BODYTYPE(2)
/// unathi bodytype (or generally lizard)
#define BODYTYPE_UNATHI S_BODYTYPE(3)
/// tajaran bodytype (or generally cat)
#define BODYTYPE_TAJARAN S_BODYTYPE(4)
/// vulp bodytype (or generally foxes)
#define BODYTYPE_VULPKANIN S_BODYTYPE(5)
/// skrell bodytype (or generally weird fleshy fishpeople)
#define BODYTYPE_SKRELL S_BODYTYPE(6)
/// sergal bodytype (or generally cheese)
#define BODYTYPE_SERGAL S_BODYTYPE(7)
/// akula bodytype (or generally shark)
#define BODYTYPE_AKULA S_BODYTYPE(8)
/// vox bodytype
#define BODYTYPE_VOX S_BODYTYPE(9)
/// neverean bodytype
#define BODYTYPE_NEVREAN S_BODYTYPE(10)
/// promethean bodytype
#define BODYTYPE_PROMETHEAN S_BODYTYPE(11)
/// highlander zorren
#define BODYTYPE_ZORREN_HIGH S_BODYTYPE(12)
/// flatlander zorren
#define BODYTYPE_ZORREN_FLAT S_BODYTYPE(13)
/// zaddat
#define BODYTYPE_ZADDAT S_BODYTYPE(14)
/// phoronoid
#define BODYTYPE_PHORONOID S_BODYTYPE(15)
/// werebeast
#define BODYTYPE_WEREBEAST S_BODYTYPE(16)
/// xenomorph hybrid
#define BODYTYPE_XENOHYBRID S_BODYTYPE(17)
/// digitigrade unathi
#define BODYTYPE_UNATHI_DIGI S_BODYTYPE(18)

//! KEEP THIS UP TO DATE
#define S_BODYTYPE_MAX 18

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

//! bodytypes as strings
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
#define BODYTYPE_STRING_ZORREN_HIGH "zorren_highlander"
#define BODYTYPE_STRING_ZORREN_FLAT "zorren_flatlander"
#define BODYTYPE_STRING_ZADDAT "zaddat"
#define BODYTYPE_STRING_PHORONOID "phoronoid"
#define BODYTYPE_STRING_WEREBEAST "werebeast"
#define BODYTYPE_STRING_XENOHYBRID "xenohybrid"

/proc/bodytype_to_string(bodytype)
	// todo: make this an assoc list lookup
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
