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

/**
 * The ability of an armor to absorb exotic energy.
 */
#define ARMOR_ENERGY "energy"
/**
 * The ability of an armor to block a shockwave from an explosion.
 */
#define ARMOR_BOMB "bomb"
/**
 * The ability of an armor to block microscale particles from entering.
 */
#define ARMOR_BIO "bio"
/**
 * The ability of an armor to block radiation.
 */
#define ARMOR_RAD "rad"
/**
 * The ability of an armor to resist surface combustion.
 */
#define ARMOR_FIRE "fire"
/**
 * The ability of an armor to resist acidic or corrosive substances from leaking through.
 */
#define ARMOR_ACID "acid"

/**
 * Global randomization ratio for all armor checks.
 * * 0.25 will make all armor randomly
 *
 * TODO: impl
 */
// #define ARMOR_CONF_RAND "conf-rand"

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

/// tierdiff is tier difference of armor against attack; positive = armor is higher tier.
/// * see https://www.desmos.com/calculator/6uu1djsawl
/// * armor at or below 0 (added damage) are passed back without change
/proc/ARMOR_TIER_CALC(armor, tierdiff)
	if(armor <= 0)
		return 0
	if(!tierdiff)
		return armor
	if(tierdiff > 0)
		var/a = armor * (tierdiff + 1)
		return max(a / sqrt(2 + a ** 2), armor)
	else
		return armor / (1 + (((-tierdiff) ** 17.5) / 1.75))

#define ARMOR_TIER_FLOOR 0
#define ARMOR_TIER_DEFAULT 3

/proc/ARMOR_TIER_BLUNT_CHANCE(tierdiff)
	switch(tierdiff)
		if(-INFINITY to -2)
			return 0
		if(-2 to -1)
			return 15
		if(-1 to -0.5)
			return 22.5
		if(-0.5 to -0.3)
			return 30
		if(-0.3 to 0)
			return 45.5
		if(0 to 0.3)
			return 57.5
		if(0.3 to 0.6)
			return 70
		if(0.6 to 1)
			return 85
		if(1 to 2)
			return 90
		else
			return 99 // tf2 critsound.ogg

//?  -- armor tiers - melee --

/**
 * 0: toys
 * 1: very light weapons
 * 2: light weapons
 * 3: toolboxes, batons, knives, your usual
 * 4: heavy swords, sledgehammers, mech punches, etc
 * 5: armor piercing / specialized weapons / eswords / etc
 * 6: idk you got crushed by a titanium rod or something
 * 7: hydraulic press?
 */

#define MELEE_TIER_DEFAULT 3

//?  -- armor tiers - bullet --

/**
 * 0: toys / nerf guns
 * 1: slingshots, bb guns, etc
 * 2: crappy improvised real rounds
 * 3: most pistols and basic-er weapons are here
 * 4: rifles
 * 5: heavy rifles
 * 6: antimaterial rifles
 * 7: idk you got hit by a tank round
 */

#define BULLET_TIER_DEFAULT 3

//?  -- armor tiers - laser --

/**
 * 0: i don't know why there are toys for this but i guess toy guns that do damage? sunburn?
 * 1: improvised crappy laser diodes or smth
 * 2: relatively unfocused weapons, low grade, etc
 * 3: most laser weapons are here
 * 4: heavier laser rifles
 * 5: x-ray lasers, light mech / mounted weapons
 * 6: heavier mech weapons, pulse weapons
 * 7: you got hit by engineering's power transmission laser
 */

#define LASER_TIER_DEFAULT 3
