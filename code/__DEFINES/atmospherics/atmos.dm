// Math constants.
/// kPa*L/(K*mol).
#define R_IDEAL_GAS_EQUATION       8.31
/// kPa.
#define ONE_ATMOSPHERE             101.325
/// (mol^3 * s^3) / (kg^3 * L).
#define IDEAL_GAS_ENTROPY_CONSTANT 1164
///    0.0 degrees celcius
#define T0C  273.15
///   20.0 degrees celcius
#define T20C 293.15
/// -270.3 degrees celcius
#define TCMB 2.7
///    -60 degrees celcius
#define TN60C 213.15
// Radiation constants.
/// W/(m^2*K^4).
#define STEFAN_BOLTZMANN_CONSTANT    5.6704e-8
/// K.
#define COSMIC_RADIATION_TEMPERATURE 3.15
/// W/m^2. Kind of arbitrary. Really this should depend on the sun position much like solars.
#define AVERAGE_SOLAR_RADIATION      200
/// kPa at 20 C. This should be higher as gases aren't great conductors until they are dense. Used the critical pressure for air.
#define RADIATOR_OPTIMUM_PRESSURE    3771
/// K. The critical point temperature for air.
#define GAS_CRITICAL_TEMPERATURE     132.65
/// (3 cm + 100 cm * sin(3deg))/(2*(3+100 cm)). Unitless ratio.
#define RADIATOR_EXPOSED_SURFACE_AREA_RATIO 0.04
///m^2, surface area of 1.7m (H) x 0.46m (D) cylinder
#define HUMAN_EXPOSED_SURFACE_AREA          5.2
/// Moles in a 2.5 m^3 cell at 101.325 kPa and 20 C.
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))
/// Percentage.
#define O2STANDARD 0.21
#define N2STANDARD 0.79

/// Moles in a standard cell after which phoron is visible.
#define MOLES_PHORON_VISIBLE 0.7
/// O2 standard value (21%)
#define MOLES_O2STANDARD     (MOLES_CELLSTANDARD * O2STANDARD)
/// N2 standard value (79%)
#define MOLES_N2STANDARD     (MOLES_CELLSTANDARD * N2STANDARD)
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
#define HUMAN_NEEDED_OXYGEN (MOLES_CELLSTANDARD * BREATH_PERCENTAGE * 0.16)
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

// Must be between 0 and 1. Values closer to 1 equalize temperature faster. Should not exceed 0.4, else strange heat flow occurs.
#define  FLOOR_HEAT_TRANSFER_COEFFICIENT 0.4
#define   WALL_HEAT_TRANSFER_COEFFICIENT 0.0
#define   DOOR_HEAT_TRANSFER_COEFFICIENT 0.0
/// A hack to partly simulate radiative heat.
#define  SPACE_HEAT_TRANSFER_COEFFICIENT 0.2
#define   OPEN_HEAT_TRANSFER_COEFFICIENT 0.4
/// A hack for now.
#define WINDOW_HEAT_TRANSFER_COEFFICIENT 0.1
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
/// Pipe-insulation rate divisor.
#define NORMPIPERATE             30
/// Heat-exchange pipe insulation.
#define HEATPIPERATE             8
/// Fraction of gas transfered per process.
#define FLOWFRAC                 0.99
//Flags for zone sleeping
#define ZONE_ACTIVE   1
#define ZONE_SLEEPING 0

// Defines how much of certain gas do the Atmospherics tanks start with. Values are in kpa per tile (assuming 20C)
/// A lot of N2 is needed to produce air mix, that's why we keep 90MPa of it
#define ATMOSTANK_NITROGEN      90000
/// O2 is also important for airmix, but not as much as N2 as it's only 21% of it.
#define ATMOSTANK_OXYGEN        40000
/// CO2 and PH are not critically important for station, only for toxins and alternative coolants, no need to store a lot of those.
#define ATMOSTANK_CO2           25000
#define ATMOSTANK_PHORON        25000
/// N2O doesn't have a real useful use, i guess it's on station just to allow refilling of sec's riot control canisters?
#define ATMOSTANK_NITROUSOXIDE  10000
