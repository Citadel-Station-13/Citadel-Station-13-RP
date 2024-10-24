// Math constants.
/// (mol^3 * s^3) / (kg^3 * L).
#define IDEAL_GAS_ENTROPY_CONSTANT 1164

/// Percentage.
#define O2STANDARD 0.21
#define N2STANDARD 0.79

/// Moles in a standard cell after which phoron is visible.
#define MOLES_PHORON_VISIBLE 0.7
/// O2 standard value (21%)
#define MOLES_O2STANDARD     (CELL_MOLES * O2STANDARD)
/// N2 standard value (79%)
#define MOLES_N2STANDARD     (CELL_MOLES * N2STANDARD)
#define MOLES_O2ATMOS (MOLES_O2STANDARD*50)
#define MOLES_N2ATMOS (MOLES_N2STANDARD*50)

// These are for when a mob breathes poisonous air.
#define MIN_TOXIN_DAMAGE 1
#define MAX_TOXIN_DAMAGE 10

/// Liters in a normal breath.
#define BREATH_VOLUME       0.5
/// Amount of air to take a from a tile
#define BREATH_MOLES        (ONE_ATMOSPHERE * BREATH_VOLUME / (T20C * R_IDEAL_GAS_EQUATION))
/// Amount of air needed before pass out/suffocation commences.
#define BREATH_PERCENTAGE   (BREATH_VOLUME / CELL_VOLUME)
#define HUMAN_NEEDED_OXYGEN (CELL_MOLES * BREATH_PERCENTAGE * 0.16)
///J/K For 80kg person
#define HUMAN_HEAT_CAPACITY 280000
/// The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE.
#define PRESSURE_DAMAGE_COEFFICIENT 4
/// This used to be 20... I got this much random rage for some stupid decision by polymorph?! Polymorph now lies in a pool of blood with a katana jammed in his spleen. ~Errorage --PS: The katana did less than 20 damage to him :(
#define    MAX_HIGH_PRESSURE_DAMAGE 4
/// The amount of damage someone takes when in a low pressure area. (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).
#define         LOW_PRESSURE_DAMAGE 2

/**
 * these control how "similar" air has to be before it's considered the same and just entirely equalized
 */
/// minimum moles of gas that has to move before we can stop ticking/just equalize
#define MINIMUM_MEANINGFUL_MOLES_DELTA				0.01
/// minimum temperature difference before we can stop ticking/just equalize
#define MINIMUM_MEANINGFUL_TEMPERATURE_DELTA		0.5
/// minimum pressure difference before we can stop ticking/just equalize
#define MINIMUM_MEANINGFUL_PRESSURE_DELTA			0.5
/// when checking for vacuum we're fine with pressure as long as it's below this
#define MINIMUM_MEANINGFUL_PRESSURE_VACUUM			5
/// ZAS: if a sharer and our moles are below this, we nuke both to 0 because we consider it a vacuum
#define MINIMUM_MOLES_TO_DISSIPATE					0.01

/**
 * stupid shit below, all of this needsd redone
 * not to say the rest of the file is good but these are especially bad
 */
// /// Minimum ratio of air that must move to/from a tile to suspend group processing
// #define MINIMUM_AIR_RATIO_TO_SUSPEND 0.005
// // /// Minimum amount of air that has to move before a group processing can be suspended
// #define MINIMUM_AIR_TO_SUSPEND       0.01
// // /// Either this must be active
// // #define MINIMUM_MOLES_DELTA_TO_MOVE  0.01
// // /// or this (or both, obviously)
// // #define MINIMUM_TEMPERATURE_TO_MOVE  (T20C + 100)
// // /// Minimum pressure difference between zones to suspend
// #define MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND (MINIMUM_AIR_TO_SUSPEND*R_IDEAL_GAS_EQUATION*T20C)/CELL_VOLUME
// // /// Minimum temperature difference before group processing is suspended.
// #define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND      0.5
// #define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND      0.5
// // /// Minimum temperature difference before the gas temperatures are just set to be equal.
// #define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER0.5
/// currently unused and requires a rework - eventually we need superconduction
// #define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION   (T20C + 10)
// #define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION (T20C + 200)
/**
 * stupid shit end
 */

// Fire damage.
#define CARBON_LIFEFORM_FIRE_RESISTANCE (T0C + 200)
#define CARBON_LIFEFORM_FIRE_DAMAGE     4

// Phoron fire properties.
///400 K - autoignite temperature in tanks and canisters - enclosed environments I guess
#define PHORON_MINIMUM_BURN_TEMPERATURE    (T0C +  126)
///519 K - autoignite temperature in air if that ever gets implemented.
#define PHORON_FLASHPOINT                  (T0C +  246)
//These control the mole ratio of oxidizer and fuel used in the combustion reaction
///should be greater than the fuel amount if fires are going to spread much
#define FIRE_REACTION_OXIDIZER_AMOUNT	3
#define FIRE_REACTION_FUEL_AMOUNT		2

//These control the speed at which fire burns
#define FIRE_GAS_BURNRATE_MULT			1
#define FIRE_LIQUID_BURNRATE_MULT		0.225

//If the fire is burning slower than this rate then the reaction is going too slow to be self sustaining and the fire burns itself out.
//This ensures that fires don't grind to a near-halt while still remaining active forever.
#define FIRE_GAS_MIN_BURNRATE			0.01
#define FIRE_LIQUD_MIN_BURNRATE			0.0025

//How many moles of fuel are contained within one solid/liquid fuel volume unit
///mol/volume unit
#define LIQUIDFUEL_AMOUNT_TO_MOL		0.45
