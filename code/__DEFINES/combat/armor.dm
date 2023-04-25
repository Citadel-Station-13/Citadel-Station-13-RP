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
#define ARMOR_MELEE_DEFLECT "melee_d"
#define ARMOR_BULLET "bullet"
#define ARMOR_BULLET_TIER "bullet_t"
#define ARMOR_BULLET_SOAK "bullet_s"
#define ARMOR_BULLET_DEFLECT "bullet_d"
#define ARMOR_LASER "laser"
#define ARMOR_LASER_TIER "laser_t"
#define ARMOR_LASER_SOAK "laser_s"
#define ARMOR_LASER_DEFLECT "laser_d"

//? Flat - stacked multiplicatively when layered
//? Standalone:
//? If > 0, decreases damage linearly with 1 being 0x damage.
//? If < 0, increases damage linearly with -1 being 2x damage, -2 being 3x damage.

#define ARMOR_ENERGY "energy"
#define ARMOR_BOMB "bomb"
#define ARMOR_BIO "bio"
#define ARMOR_RAD "rad"
#define ARMOR_FIRE "fire"
#define ARMOR_ACID "acid"

GLOBAL_REAL_LIST(armor_enums) = list(
	ARMOR_MELEE,
	ARMOR_MELEE_TIER,
	ARMOR_MELEE_SOAK,
	ARMOR_MELEE_DEFLECT,
	ARMOR_BULLET,
	ARMOR_BULLET_TIER,
	ARMOR_BULLET_SOAK,
	ARMOR_BULLET_DEFLECT,
	ARMOR_LASER,
	ARMOR_LASER_TIER,
	ARMOR_LASER_SOAK,
	ARMOR_LASER_DEFLECT,
	ARMOR_ENERGY,
	ARMOR_BOMB,
	ARMOR_BIO,
	ARMOR_RAD,
	ARMOR_FIRE,
	ARMOR_ACID,
)

//? --- armor tiers ---

#define ARMOR_TIER_DEFAULT 0

#define ARMOR_TIER_LAUGHABLE -3
#define ARMOR_TIER_LOW -2
#define ARMOR_TIER_BELOW -1
#define ARMOR_TIER_NORMAL 0
#define ARMOR_TIER_ABOVE 1
#define ARMOR_TIER_HIGH 2
#define ARMOR_TIER_OVERWHELMING 3
#define ARMOR_TIER_RIDICULOUS 4

#define ARMOR_BARELY_BEATS(other) (other + 0.001)

//? melee

#define MELEE_TIER_DEFAULT ARMOR_TIER_BELOW

#define MELEE_TIER_UNARMED_FISTS ARMOR_TIER_BELOW
#define MELEE_TIER_UNARMED_CLAW ARMOR_TIER_BELOW
#define MELEE_TIER_LIGHT ARMOR_TIER_DEFAULT
#define MELEE_TIER_MEDIUM AMROR_TIER_ABOVE
#define MELEE_TIER_HEAVY ARMOR_TIER_HIGH
#define MELEE_TIER_EXTREME ARMOR_TIER_OVERWHELMING

//? bullet

#define BULLET_TIER_DEFAULT ARMOR_TIER_DEFAULT

#define BULLET_TIER_LAUGHABLE ARMOR_TIER_BELOW       //! super improvised rounds / pistols / whatever.
#define BULLET_TIER_LOW ARMOR_TIER_DEFAULT           //! pistols
#define BULLET_TIER_MEDIUM ARMOR_TIER_ABOVE          //! smgs
#define BULLET_TIER_HIGH ARMOR_TIER_HIGH             //! rifles
#define BULLET_TIER_EXTREME ARMOR_TIER_OVERWHELMING  //! lmgs, light mech weapons
#define BULLET_TIER_RIDICULOUS ARMOR_TIER_RIDICULOUS //! heavy mech weapons

//? laser

#define LASER_TIER_DEFAULT ARMOR_TIER_DEFAULT

#define LASER_TIER_LAUGHABLE ARMOR_TIER_BELOW        //! improvised laser focis / etc
#define LASER_TIER_LOW ARMOR_TIER_DEFAULT            //! low tier lasers
#define LASER_TIER_MEDIUM ARMOR_TIER_ABOVE           //! laser carbines, energy guns, etc
#define LASER_TIER_HIGH ARMOR_TIER_HIGH              //! x-ray rifles, snipers
#define LASER_TIER_EXTREME ARMOR_TIER_OVERWHELMING   //! mech weapons, usualy
#define LASER_TIER_RIDICULOUS ARMOR_TIER_RIDICULOUS  //! power transmission laser?

//? --- armor calculations ---

/// tierdiff is tier difference of armor against attack; positive = armor is higher tier.
#define ARMOR_TIER_CALC(_armor, _tierdiff) ((_tierdiff) > 0? ((_armor) ** (1 / (1 + (_tierdiff)))) : ((_armor) * (1 / (1 - (_tierdiff)))))
