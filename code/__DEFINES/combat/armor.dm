//? --- armor defines ---
//* Want to add more?
//* Update [code/__HELPERS/datastructs/armor.dm]
//* Add an armor var, define it here,
//* and update the procs accordingly.
//* The system will handle the rest.
//* Make sure the var names match the names in here!

//? Tiered - used to model attacks - stacked with tier system when layered.

#define ARMOR_MELEE "melee"
#define ARMOR_MELEE_TIER "melee_t"
#define ARMOR_MELEE_SOAK "melee_s"
#define ARMOR_BULLET "bullet"
#define ARMOR_BULLET_TIER "bullet_t"
#define ARMOR_BULLET_SOAK "bullet_s"
#define ARMOR_LASER "laser"
#define ARMOR_LASER_TIER "laser_t"
#define ARMOR_LASER_SOAK "laser_s"

//? Flat - stacked multiplicatively when layered
//? Standalone:
//? If > 0, decreases damage linearly with 1 being 0x damage.
//? If < 0, increases damage linearly with -1 being 2x damage, -2 being 3x damage.

#define ARMOR_ENERGY "energy"
#define ARMOR_BOMB "bomb"
#define ARMOR_BIO "bio"
#define ARMOR_RAD "rad"

GLOBAL_REAL_LIST(armor_enums) = list(
	ARMOR_MELEE,
	ARMOR_MELEE_TIER,
	ARMOR_MELEE_SOAK,
	ARMOR_BULLET,
	ARMOR_BULLET_TIER,
	ARMOR_BULLET_SOAK,
	ARMOR_LASER,
	ARMOR_LASER_TIER,
	ARMOR_LASER_SOAK,
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

//? --- armor calculations ---

/// tierdiff is tier difference of armor against attack; positive = armor is higher tier.
#define ARMOR_TIER_CALC(_armor, _tierdiff) ((_tierdiff) > 0? ((_armor) ** (1 / (1 + (_tierdiff)))) : ((_armor) * (1 / (1 - (_tierdiff)))))
