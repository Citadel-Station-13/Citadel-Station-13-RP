//! bodytypes - they are flags for var storage, but should only be passed one at a time to rendering!
/// normal human bodytype (or generally everyone else)
#define BODYTYPE_DEFAULT			(1<<0)
/// teshari bodytype (or generally tiny birds)
#define BODYTYPE_TESHARI			(1<<2)
/// adherent bodytype (or generally giant serpent creatures)
#define BODYTYPE_ADHERENT			(1<<3)
/// unathi bodytype (or generally lizard)
#define BODYTYPE_UNATHI				(1<<4)
/// tajaran bodytype (or generally cat)
#define BODYTYPE_TAJARAN			(1<<5)
/// vulp bodytype (or generally foxes)
#define BODYTYPE_VULPKANIN			(1<<6)
/// skrell bodytype (or generally weird fleshy fishpeople)
#define BODYTYPE_SKRELL				(1<<7)
/// sergal bodytype (or generally cheese)
#define BODYTYPE_SERGAL				(1<<8)
/// akula bodytype (or generally shark)
#define BODYTYPE_AKULA				(1<<9)
/// vox bodytype
#define BODYTYPE_VOX				(1<<10)
/// neverean bodytype
#define BODYTYPE_NEVREAN			(1<<11)
/// promethean bodytype
#define BODYTYPE_PROMETHEAN			(1<<12)
/// highlander zorren
#define BODYTYPE_ZORREN_HIGHLANDER	(1<<13)
/// flatlander zorren
#define BODYTYPE_ZORREN_FLATLANDER	(1<<14)

#warn impl vox, nevrean, promethean, zorren's in species and the shit below

// todo: what are we going to do with these?
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
#define BODYTYPE_STRING_TAJARAN "tajaran"
#define BODYTYPE_STRING_VULPKANIN "vulpkanin"
#define BODYTYPE_STRING_SKRELL "skrell"
#define BODYTYPE_STRING_SERGAL "sergal"
#define BODYTYPE_STRING_AKULA "akula"

/proc/bodytype_to_string(bodytype)
	switch(bodytype)
		if(BODYTYPE_DEFAULT)
			return BODYTYPE_STRING_DEFAULT
		if(BODYTYPE_TESHARI)
			return BODYTYPE_STRING_TESHARI
		if(BODYTYPE_ADHERENT)
			return BODYTYPE_STRING_ADHERENT
		if(BODYTYPE_UNATHI)
			return BODYTYPE_STRING_UNATHI
		if(BODYTYPE_TAJARAN)
			return BODYTYPE_STRING_TAJARAN
		if(BODYTYPE_VULPKANIN)
			return BODYTYPE_STRING_VULPKANIN
		if(BODYTYPE_SKRELL)
			return BODYTYPE_STRING_SKRELL
		if(BODYTYPE_SERGAL)
			return BODYTYPE_STRING_SKRELL
		if(BODYTYPE_AKULA)
			return BODYTYPE_STRING_AKULA
		else
			CRASH("unknown bodytype: [bodytype]")
