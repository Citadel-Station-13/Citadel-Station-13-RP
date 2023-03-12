//? --- armor defines ---
//* Want to add more?
//* Update [code/__HELPERS/datastructs/armor.dm]
//* Add an armor var, define it here,
//* and update to_list() and from_list().
//* The system will handle the rest.
//* Make sure the var names match the names in here!

//? Tiered - used to model attacks - stacked with tier system

#define ARMOR_MELEE "melee"
#define ARMOR_MELEE_TIER "melee_t"
#define ARMOR_BULLET "bullet"
#define ARMOR_BULLET_TIER "bullet_t"
#define ARMOR_LASER "laser"
#define ARMOR_LASER_TIER "laser_t"

//? Flat - stacked multiplicatively

#define ARMOR_ENERGY "energy"
#define ARMOR_BOMB "bomb"
#define ARMOR_BIO "bio"
#define ARMOR_RAD "rad"

GLOBAL_REAL_LIST_MANAGED(armor_enums) = list(
	ARMOR_MELEE,
	ARMOR_MELEE_TIER,
	ARMOR_BULLET,
	ARMOR_BULLET_TIER,
	ARMOR_LASER,
	ARMOR_LASER_TIER,
	ARMOR_ENERGY,
	ARMOR_BOMB,
	ARMOR_BIO,
	ARMOR_RAD,
)

//? --- armor tiers ---

#define ARMOR_TIER_LAUGHABLE -3
#define ARMOR_TIER_LOW -2
#define ARMOR_TIER_BELOW -1
#define ARMOR_TIER_DEFAULT 0
#define ARMOR_TIER_ABOVE 1
#define ARMOR_TIER_HIGH 2
#define ARMOR_TIER_OVERWHELMING 3

//? melee

#define MELEE_TIER_UNARMED_FISTS -1
#define MELEE_TIER_UNARMED_CLAW 0
#define MELEE_TIER_DEFAULT ARMOR_TIER_DEFAULT

//? bullet

#define BULLET_TIER_DEFAULT ARMOR_TIER_DEFAULT

//? laser

#define LASER_TIER_DEFAULT ARMOR_TIER_DEFAULT
