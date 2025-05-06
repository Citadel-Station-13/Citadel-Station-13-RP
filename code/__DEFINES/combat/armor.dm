//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//? --- armor defines ---
//* Want to add more?
//* Update [code/__HELPERS/datastructs/armor.dm]
//* Add an armor var, define it here,
//* and update the procs accordingly.
//* The system will handle the rest.
//* Make sure the var names match the names in here!

// todo: change melee/bullet to blunt/slash/pierce

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

/**
 * All armor enums that can be stored in an armor datum
 */
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

/**
 * Actual armor types that can be checked for with `damage_flag`
 */
GLOBAL_REAL_LIST(armor_types) = list(
	ARMOR_MELEE,
	ARMOR_BULLET,
	ARMOR_LASER,
	ARMOR_ENERGY,
	ARMOR_BOMB,
	ARMOR_BIO,
	ARMOR_RAD,
	ARMOR_FIRE,
	ARMOR_ACID,
)

//?                              --- armor tiers ---
//? These are defined values so if we want to scale them nonlinearly/whatever later,
//? we don't need to replace everything.

#define ARMOR_TIER_BASELINE 0

//?                              --- armor tier helpers ---

/**
 * Armor barely beats a given tier. Results in little to no values changes, but the checks for beating
 * would pass.
 */
#define ARMOR_TIER_BARELY_BEATS(other) (other + 0.001)
/**
 * Linear tier scaling between A and B, by amount, where 1 is B, 0 is A, 0.5 is between.
 */
#define ARMOR_TIER_BETWEEN(TIER_A, TIER_B, AMOUNT) LERP(TIER_A, TIER_B, AMOUNT)
/**
 * Scale above a tier by an amount, where 1 is an additional tier up.
 * * 1 tier up is a decent boost in damage and penetration from the last
 * * 2 tiers up is a high boost in damage and can generally penetrate the first one semi-trivially.
 */
#define ARMOR_TIER_ABOVE(TIER, AMOUNT) (TIER + AMOUNT)
/**
 * Opposite of [ARMOR_TIER_BELOW]
 */
#define ARMOR_TIER_BELOW(TIER, AMOUNT) (TIER - AMOUNT)

//?  -- armor tiers - melee --

#define MELEE_TIER_DEFAULT MELEE_TIER_MEDIUM

/**
 * toys
 */
#define MELEE_TIER_USELESS ARMOR_TIER_0
/**
 * very light weapons that shouldn't be used as weapons really
 */
#define MELEE_TIER_LAUGHABLE ARMOR_TIER_1
/**
 * light weapons
 */
#define MELEE_TIER_LIGHT ARMOR_TIER_2
/**
 * toolboxes, batons, knives, hammers, etc
 */
#define MELEE_TIER_MEDIUM ARMOR_TIER_3
/**
 * heavy swords, sledgehammers, mech punches, etc
 */
#define MELEE_TIER_HEAVY ARMOR_TIER_4
/**
 * armor piercing / specialized tooling
 */
#define MELEE_TIER_EXTREME ARMOR_TIER_5
/**
 * even heavier armor piercing
 */
#define MELEE_TIER_UNSTOPPABLE ARMOR_TIER_6

//?  -- armor tiers - bullet --

#define BULLET_TIER_DEFAULT BULLET_TIER_MEDIUM

/**
 * generally foam / nerf rounds
 */
#define BULLET_TIER_USELESS ARMOR_TIER_0
/**
 * slingshots
 */
#define BULLET_TIER_LAUGHABLE ARMOR_TIER_1
/**
 * improvised rounds, very low powered pistols, etc
 */
#define BULLET_TIER_I ARMOR_TIER_2
/**
 * most pistol rounds
 */
#define BULLET_TIER_II ARMOR_TIER_3
/**
 * some AP pistol rounds, some lighter rifle rounds
 */
#define BULLET_TIER_ ARMOR_TIER_4
/** */

/// super improvised rounds / pistols / whatever.
#define BULLET_TIER_LAUGHABLE ARMOR_TIER_BELOW
/// pistols
#define BULLET_TIER_LOW ARMOR_TIER_BASELINE
/// smgs
#define BULLET_TIER_MEDIUM ARMOR_TIER_ABOVE
/// rifles
#define BULLET_TIER_HIGH ARMOR_TIER_HIGH
/// hmgs, light mech weapons
#define BULLET_TIER_EXTREME ARMOR_TIER_OVERWHELMING
/// heavy mech weapons
#define BULLET_TIER_RIDICULOUS ARMOR_TIER_RIDICULOUS

//?  -- armor tiers - laser --

#define LASER_TIER_DEFAULT LASER_TIER_MEDIUM

/// improvised laser focis / etc
#define LASER_TIER_LAUGHABLE ARMOR_TIER_BELOW
/// low tier lasers
#define LASER_TIER_LOW ARMOR_TIER_BASELINE
/// laser carbines, energy guns, etc
#define LASER_TIER_MEDIUM ARMOR_TIER_ABOVE
/// x-ray rifles, snipers
#define LASER_TIER_HIGH ARMOR_TIER_HIGH
/// mech weapons, usualy
#define LASER_TIER_EXTREME ARMOR_TIER_OVERWHELMING
/// power transmission laser?
#define LASER_TIER_RIDICULOUS ARMOR_TIER_RIDICULOUS
