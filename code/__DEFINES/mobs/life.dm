//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* This file is called 'life', but realistically is the resting place of all things metabolism, health, and related. *//

//?  Health - Core
/** Round damage values to this value
 * Atom damage uses this too!
 */
#define DAMAGE_PRECISION			0.01
#define DAMAGE_TIER_PRECISION		0.01
#define ARMOR_PRECISION				0.001
#define ARMOR_TIER_PRECISION		0.01

//* Health - Environmental Interactions *//

/// % of temperature recovered when going towards favorable
#define MOB_BODYTEMP_EQUALIZATION_FAVORABLE_RATIO (1 / 6)
/// % of temperature gained/lost when going away from favorable
#define MOB_BODYTEMP_EQUALIZATION_UNFAVORABLE_RATIO (1 / 6)
/// minimum stabilization when far from 'livable' tempreatures, but environment is closer to livable temperature
#define MOB_BODYTEMP_EQUALIZATION_MIN_FAVORABLE 10
/// minimum temperature change when environment is further from livable temperature / is going ot harm us from its temperature
#define MOB_BODYTEMP_EQUALIZATION_MIN_UNFAVORABLE 1
/// maximum temperature change when environment is further from livable temperature / is going to harm us from its temperature
#define MOB_BODYTEMP_EQUALIZATION_MAX_UNFAVORABLE 50
/// temperature of environment has to be within this range of favorable to be considered.. favorable
#define MOB_BODYTEMP_EQUALIZATION_FAVORABLE_LEEWAY 30
/// temperature difference of body from normal, if exceeding this much from normal, makes something able to be favorable even if it's outside of leeway.
#define MOB_BODYTEMP_EQUALIZATION_FAVORABLE_FORCED_THRESHOLD 200

//?  CPR
/// how long CPR suppresses brain decay
#define CPR_BRAIN_STASIS_TIME					(15 SECONDS)
/// how long CPR acts as mechanical ventilation
#define CPR_VENTILATION_TIME					(10 SECONDS)
/// how long CPR acts as mechanical circulation
#define CPR_CIRCULATION_TIME					(7 SECONDS)
/// how long CPR takes to do
#define CPR_ACTION_TIME							(3 SECONDS)
/// how long CPR is on nominal cooldown (doing it faster is less effective)
#define CPR_NOMINAL_COOLDOWN					(7 SECONDS)
/// nominal CPR reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_NOMINAL	(7)								// 100% as effective as living
/// on-cooldown reagent tick strength (as multiplier of normal living)
#define CPR_FORCED_METABOLISM_STRENGTH_CLIPPED	(3 * 0.5)								// 50% as effective as living at best

//?  Organs - General

//?  Organs - Decaying while dead/removed
//? current formula is generally (maxhealth / (seconds to decay))
/// how much damage most organs take per second when the user is dead and it is not preserved
#define ORGAN_DECAY_PER_SECOND_DEFAULT			(60 / (60 * 40))				// most organs decay entirely over 40 minutes, or to lethal degrees in 20
/// how much damage the brain takes per second when the user is dead and it is not preserved
#define ORGAN_DECAY_PER_SECOND_BRAIN			(60 / (60 * 10))				// brain decays entirely over 10 minutes, or to lethal degrees in 5


//? Health - General
/** Store the default minimum health, crit health, soft crit health
 * These are currently only respected by carbons
*/
#define MOB_MINIMUM_HEALTH			-100
#define MOB_CRITICAL_HEALTH			-50
#define MOB_SOFT_CRITICAL_HEALTH 	0
