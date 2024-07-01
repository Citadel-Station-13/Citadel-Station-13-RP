//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* damage types *//

// todo: refactor damage types

//* damage_mode bitfield *//

#define DAMAGE_MODE_SHARP (1<<0)      //! sharp weapons like knives, spears, etc
#define DAMAGE_MODE_EDGE (1<<1)       //! weapons with an edge, like knives, being used as such. without this, sharp = pierce
#define DAMAGE_MODE_ABLATING (1<<2)   //! pulse lasers, etc, basically blows a crater
#define DAMAGE_MODE_PIERCE (1<<3)     //! specifically highly-piercing weapons like bullets, even worse than sharp.
#define DAMAGE_MODE_SHRED (1<<4)      //! messy, shredded wounds instead of a clean cut / pierce. strong.
#define DAMAGE_MODE_GRADUAL (1<<5)    //! disallow bone breaks, ablation, etc; used for gradual sources like depressurization
#define DAMAGE_MODE_INTERNAL (1<<6)   //! coming from internal; used to flag that something isn't coming through the skin. certain defenses don't work if this is set.
#define DAMAGE_MODE_REDIRECT (1<<7)   //! if zone doesn't exist / etc, allow redirection
#define DAMAGE_MODE_NO_OVERFLOW (1<<8)//! temporary - re-evaluate when health is reworked. prevents damage from overflowing caps.

// todo: DEFINE_BITFIELD

//* damage_classifier enum *//

/// a lightweight enum system used to classify something as a specific type of object
/// this way, we can modify things like damage multipliers or even effects
/// to a specific type of object
///
/// currently used by
/// * explosions

#define DAMAGE_CLASSIFIER_DEFAULT "default"

#define DAMAGE_CLASSIFIER_OBJ "obj"
#define DAMAGE_CLASSIFIER_GLASS "glass"
#define DAMAGE_CLASSIFIER_DOOR "door"

#define DAMAGE_CLASSIFIER_MOB "mob"

#define DAMAGE_CLASSIFIER_WALL "wall"
#define DAMAGE_CLASSIFIER_FLOOR "floor"

#warn DEFINE_ENUM

//* damage_classifier multiplier helpers *//

/// it's annoying as hell to remember to specify everything when we add new classifiers
/// this lets us do that in an easier way
///
/// e.g.
/// var/static/list/multipliers = \
///     DAMAGE_CLASSIFIER_MULTILPIERS_OBJ(3) | \
///     DAMAGE_CLASSIFIER_MULTIPLIERS_MOB(0.5)
///
/// you also want to be least specific to most if merging with |,
/// because otherwise things get overwritten
///
/// always verify your multipliers with debugger before assuming it works!

/**
 * includes everything but walls and mobs
 */
#define DAMAGE_CLASSIFIER_MULTIPLIERS_OBJECTS(MULT) list( \
	DAMAGE_CLASSIFIER_OBJ = MULT, \
	DAMAGE_CLASSIFIER_DOOR = MULT, \
	DAMAGE_CLASSIFIER_GLASS = MULT, \
)

#define DAMAGE_CLASSIFIER_MULTIPLIERS_TURFS(MULT) list( \
	DAMAGE_CLASSIFIER_WALL = MULT, \
	DAMAGE_CLASSIFIER_FLOOR = MULT, \
)

#define DAMAGE_CLASSIFIER_MULTIPLIERS_MOBS (MULT) list( \
	DAMAGE_CLASSIFER_MOB = MULT, \
)
