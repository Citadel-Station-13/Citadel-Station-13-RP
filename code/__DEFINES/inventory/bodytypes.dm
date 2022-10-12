// bodytypes - they are flags for var storage, but should only be passed one at a time to rendering!
/// normal human bodytype
#define BODYTYPE_DEFAULT			(1<<0)
/// teshari bodytype
#define BODYTYPE_TESHARI			(1<<2)
/// adherent bodytype
#define BODYTYPE_ADHERENT			(1<<3)
/// unathi bodytype
#define BODYTYPE_UNATHI				(1<<4)
/// tajaran bodytype
#define BODYTYPE_TAJARAN			(1<<5)
/// vulp bodytype
#define BODYTYPE_VULPKANIN			(1<<6)
/// skrell bodytype
#define BODYTYPE_SKRELL				(1<<7)
/// sergal bodytype
#define BODYTYPE_SERGAL				(1<<8)
/// akula bodytype
#define BODYTYPE_AKULA				(1<<9)

/// has snout - usually relevant for masks and headgear
#define BODYTYPE_SNOUT				(1<<20)
/// snake taur bodytype - usually relevant for hardsuits and similar
#define BODYTYPE_TAUR_SNAKE			(1<<21)
/// horse taur bodytype - ditto
#define BODYTYPE_TAUR_HORSE			(1<<22)
/// digitigrade feet - usually relevant for leg covering gear
#define BODYTYPE_DIGITIGRADE		(1<<23)
